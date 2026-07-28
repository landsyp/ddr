import assert from "node:assert/strict";
import test from "node:test";
import {
  expectedCoverage,
  expectedFeatureFiles,
  minimumScenarioCount,
} from "./coverage-manifest.mjs";
import {
  parseAllFeatures,
  readFeatureFiles,
  scenarioId,
  scenarioTags,
} from "./gherkin-parser.mjs";

const featureFiles = readFeatureFiles();
const features = parseAllFeatures();
const scenarios = features.flatMap((feature) => (
  feature.scenarios.map((scenario) => ({ feature, scenario }))
));

test("all expected Gherkin feature files exist", () => {
  const actualFiles = featureFiles.map((feature) => feature.fileName);
  assert.deepEqual(actualFiles, expectedFeatureFiles);
});

test("each feature has a title and at least one scenario", () => {
  for (const feature of features) {
    assert.ok(feature.title, `${feature.fileName} is missing Feature title`);
    assert.ok(feature.scenarios.length > 0, `${feature.fileName} has no scenarios`);
  }
});

test("each scenario has meaningful Given/When/Then coverage", () => {
  for (const { feature, scenario } of scenarios) {
    const label = scenarioId(feature, scenario);
    const allSteps = [...feature.background, ...scenario.steps].map((step) => step.text);
    assert.ok(allSteps.some((step) => step.startsWith("Given ")), `${label} is missing Given context`);
    assert.ok(allSteps.some((step) => step.startsWith("When ")), `${label} is missing When action`);
    assert.ok(allSteps.some((step) => step.startsWith("Then ")), `${label} is missing Then assertion`);
  }
});

test("scenario outlines include examples", () => {
  for (const { feature, scenario } of scenarios) {
    if (!scenario.isOutline) {
      continue;
    }
    const rows = scenario.examples.flatMap((example) => example.rows);
    assert.ok(rows.length >= 2, `${scenarioId(feature, scenario)} needs an Examples table with header and rows`);
  }
});

test("scenario names are unique inside each feature file", () => {
  for (const feature of features) {
    const names = feature.scenarios.map((scenario) => scenario.title);
    assert.equal(new Set(names).size, names.length, `${feature.fileName} has duplicate scenario names`);
  }
});

test("Gherkin catalog covers every major app area", () => {
  assert.ok(scenarios.length >= minimumScenarioCount, `Expected at least ${minimumScenarioCount} scenarios`);

  for (const coverage of expectedCoverage) {
    const matchingScenarios = scenarios.filter(({ feature, scenario }) => (
      scenarioTags(feature, scenario).has(coverage.tag)
    ));
    assert.ok(
      matchingScenarios.length >= coverage.minimumScenarios,
      `${coverage.tag} has ${matchingScenarios.length} scenarios; expected at least ${coverage.minimumScenarios}`,
    );
  }
});

test("feature files avoid placeholders", () => {
  for (const feature of featureFiles) {
    assert.equal(/\b(TODO|TBD|FIXME)\b/i.test(feature.source), false, `${feature.fileName} contains placeholder text`);
  }
});

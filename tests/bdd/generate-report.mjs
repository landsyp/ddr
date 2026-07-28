import { mkdirSync, writeFileSync } from "node:fs";
import { join } from "node:path";
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

const reportDir = "reports";
const featureFiles = readFeatureFiles();
const features = parseAllFeatures();
const scenarios = features.flatMap((feature) => (
  feature.scenarios.map((scenario) => ({ feature, scenario }))
));
const checks = [
  {
    name: "All expected Gherkin feature files exist",
    run() {
      const actualFiles = featureFiles.map((feature) => feature.fileName);
      assertDeepEqual(actualFiles, expectedFeatureFiles);
    },
  },
  {
    name: "Each feature has a title and at least one scenario",
    run() {
      for (const feature of features) {
        assert(Boolean(feature.title), `${feature.fileName} is missing Feature title`);
        assert(feature.scenarios.length > 0, `${feature.fileName} has no scenarios`);
      }
    },
  },
  {
    name: "Each scenario has meaningful Given/When/Then coverage",
    run() {
      for (const { feature, scenario } of scenarios) {
        const label = scenarioId(feature, scenario);
        const allSteps = [...feature.background, ...scenario.steps].map((step) => step.text);
        assert(allSteps.some((step) => step.startsWith("Given ")), `${label} is missing Given context`);
        assert(allSteps.some((step) => step.startsWith("When ")), `${label} is missing When action`);
        assert(allSteps.some((step) => step.startsWith("Then ")), `${label} is missing Then assertion`);
      }
    },
  },
  {
    name: "Scenario outlines include examples",
    run() {
      for (const { feature, scenario } of scenarios) {
        if (!scenario.isOutline) {
          continue;
        }
        const rows = scenario.examples.flatMap((example) => example.rows);
        assert(rows.length >= 2, `${scenarioId(feature, scenario)} needs an Examples table with header and rows`);
      }
    },
  },
  {
    name: "Scenario names are unique inside each feature file",
    run() {
      for (const feature of features) {
        const names = feature.scenarios.map((scenario) => scenario.title);
        assert(new Set(names).size === names.length, `${feature.fileName} has duplicate scenario names`);
      }
    },
  },
  {
    name: "Gherkin catalog covers every major app area",
    run() {
      assert(scenarios.length >= minimumScenarioCount, `Expected at least ${minimumScenarioCount} scenarios`);

      for (const coverage of expectedCoverage) {
        const matchingScenarios = scenarios.filter(({ feature, scenario }) => (
          scenarioTags(feature, scenario).has(coverage.tag)
        ));
        assert(
          matchingScenarios.length >= coverage.minimumScenarios,
          `${coverage.tag} has ${matchingScenarios.length} scenarios; expected at least ${coverage.minimumScenarios}`,
        );
      }
    },
  },
  {
    name: "Feature files avoid placeholders",
    run() {
      for (const feature of featureFiles) {
        assert(!/\b(TODO|TBD|FIXME)\b/i.test(feature.source), `${feature.fileName} contains placeholder text`);
      }
    },
  },
];

const checkResults = checks.map((check) => {
  try {
    check.run();
    return { name: check.name, status: "passed" };
  } catch (error) {
    return { name: check.name, status: "failed", message: error.message };
  }
});
const failedChecks = checkResults.filter((check) => check.status === "failed");

mkdirSync(reportDir, { recursive: true });
writeFileSync(join(reportDir, "test-report.md"), buildTestReport(), "utf8");
writeFileSync(join(reportDir, "bdd-scenarios.md"), buildScenarioReport(), "utf8");
writeFileSync(join(reportDir, "junit.xml"), buildJUnitReport(), "utf8");
writeFileSync(join(reportDir, "summary.json"), JSON.stringify(buildSummary(), null, 2), "utf8");

console.log(`BDD reports written to ${reportDir}/`);
console.log(`${checkResults.length - failedChecks.length}/${checkResults.length} checks passed`);
console.log(`${features.length} feature files, ${scenarios.length} scenarios`);

if (failedChecks.length) {
  process.exitCode = 1;
}

function buildTestReport() {
  const generatedAt = new Date().toISOString();
  const status = failedChecks.length ? "Failed" : "Passed";
  const rows = checkResults.map((check) => (
    `| ${check.status === "passed" ? "✅" : "❌"} | ${check.name} | ${check.message || ""} |`
  )).join("\n");
  const tagRows = expectedCoverage.map((coverage) => {
    const count = scenarios.filter(({ feature, scenario }) => scenarioTags(feature, scenario).has(coverage.tag)).length;
    return `| ${coverage.tag} | ${count} | ${coverage.minimumScenarios} | ${count >= coverage.minimumScenarios ? "✅" : "❌"} |`;
  }).join("\n");

  return `# WeSERVE BDD Test Report

## Summary

| Field | Value |
| --- | --- |
| Status | ${status} |
| Generated at | ${generatedAt} |
| Branch | ${process.env.GITHUB_REF_NAME || "local"} |
| Commit | ${process.env.GITHUB_SHA || "local"} |
| Workflow run | ${process.env.GITHUB_RUN_ID || "local"} |
| Feature files | ${features.length} |
| Scenarios | ${scenarios.length} |
| Validation checks | ${checkResults.length} |
| Passed checks | ${checkResults.length - failedChecks.length} |
| Failed checks | ${failedChecks.length} |

## Validation Checks

| Result | Check | Message |
| --- | --- | --- |
${rows}

## Coverage By Tag

| Tag | Scenarios | Required | Result |
| --- | ---: | ---: | --- |
${tagRows}

## Files

- \`test-report.md\`: this validation summary
- \`bdd-scenarios.md\`: full feature and scenario catalog
- \`junit.xml\`: CI-compatible validation report
- \`summary.json\`: machine-readable summary
`;
}

function buildScenarioReport() {
  const sections = features.map((feature) => {
    const scenarioRows = feature.scenarios.map((scenario) => {
      const tags = [...scenarioTags(feature, scenario)].join(" ");
      return `- ${scenario.title}${tags ? ` (${tags})` : ""}`;
    }).join("\n");

    return `## ${feature.title}

File: \`tests/features/${feature.fileName}\`

${scenarioRows}
`;
  }).join("\n");

  return `# WeSERVE BDD Scenario Catalog

${features.length} feature files, ${scenarios.length} scenarios.

${sections}`;
}

function buildJUnitReport() {
  const failures = failedChecks.length;
  const testCases = checkResults.map((check) => {
    const failure = check.status === "failed"
      ? `\n    <failure message="${escapeXml(check.message || "Failed")}">${escapeXml(check.message || "Failed")}</failure>\n  `
      : "";
    return `  <testcase classname="BDD catalog validation" name="${escapeXml(check.name)}">${failure}</testcase>`;
  }).join("\n");

  return `<?xml version="1.0" encoding="UTF-8"?>
<testsuite name="WeSERVE BDD catalog validation" tests="${checkResults.length}" failures="${failures}" errors="0">
${testCases}
</testsuite>
`;
}

function buildSummary() {
  return {
    status: failedChecks.length ? "failed" : "passed",
    generatedAt: new Date().toISOString(),
    branch: process.env.GITHUB_REF_NAME || "local",
    commit: process.env.GITHUB_SHA || "local",
    workflowRun: process.env.GITHUB_RUN_ID || "local",
    featureFiles: features.length,
    scenarios: scenarios.length,
    checks: checkResults,
  };
}

function assert(condition, message) {
  if (!condition) {
    throw new Error(message);
  }
}

function assertDeepEqual(actual, expected) {
  const actualValue = JSON.stringify(actual);
  const expectedValue = JSON.stringify(expected);
  assert(actualValue === expectedValue, `Expected ${expectedValue}, received ${actualValue}`);
}

function escapeXml(value) {
  return String(value)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&apos;");
}

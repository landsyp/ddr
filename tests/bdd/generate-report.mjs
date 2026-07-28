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
const qualityGateThreshold = Number(process.env.QUALITY_GATE_THRESHOLD || 80);
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
const passedChecks = checkResults.length - failedChecks.length;
const passRate = checkResults.length ? (passedChecks / checkResults.length) * 100 : 0;
const qualityGatePassed = passRate >= qualityGateThreshold;
const qualityGateStatus = qualityGatePassed ? "Ready to integrate" : "Blocked";

mkdirSync(reportDir, { recursive: true });
writeFileSync(join(reportDir, "test-report.md"), buildTestReport(), "utf8");
writeFileSync(join(reportDir, "test-report.html"), buildHtmlReport(), "utf8");
writeFileSync(join(reportDir, "bdd-scenarios.md"), buildScenarioReport(), "utf8");
writeFileSync(join(reportDir, "junit.xml"), buildJUnitReport(), "utf8");
writeFileSync(join(reportDir, "summary.json"), JSON.stringify(buildSummary(), null, 2), "utf8");

console.log(`BDD reports written to ${reportDir}/`);
console.log(`${passedChecks}/${checkResults.length} checks passed`);
console.log(`Quality gate: ${qualityGatePassed ? "passed" : "failed"} (${formatPercent(passRate)} ${qualityGatePassed ? ">=" : "<"} ${qualityGateThreshold}%)`);
console.log(`${features.length} feature files, ${scenarios.length} scenarios`);

if (!qualityGatePassed) {
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
| Passed checks | ${passedChecks} |
| Failed checks | ${failedChecks.length} |
| Test pass rate | ${formatPercent(passRate)} |
| Quality gate threshold | ${qualityGateThreshold}% |
| Quality gate | ${qualityGateStatus} |

## Validation Checks

| Result | Check | Message |
| --- | --- | --- |
${rows}

## Coverage By Tag

| Tag | Scenarios | Required | Result |
| --- | ---: | ---: | --- |
${tagRows}

## Files

- \`test-report.html\`: visual HTML validation summary and scenario catalog
- \`test-report.md\`: this validation summary
- \`bdd-scenarios.md\`: full feature and scenario catalog
- \`junit.xml\`: CI-compatible validation report
- \`summary.json\`: machine-readable summary
`;
}

function buildHtmlReport() {
  const generatedAt = new Date().toISOString();
  const status = qualityGateStatus;
  const statusClass = qualityGatePassed ? "passed" : "failed";
  const branch = process.env.GITHUB_REF_NAME || "local";
  const commit = process.env.GITHUB_SHA || "local";
  const workflowRun = process.env.GITHUB_RUN_ID || "local";
  const validationRows = checkResults.map((check) => `
              <tr>
                <td><span class="pill ${check.status}">${check.status === "passed" ? "Passed" : "Failed"}</span></td>
                <td>${escapeHtml(check.name)}</td>
                <td>${escapeHtml(check.message || "—")}</td>
              </tr>`).join("");
  const coverageRows = expectedCoverage.map((coverage) => {
    const count = scenarios.filter(({ feature, scenario }) => scenarioTags(feature, scenario).has(coverage.tag)).length;
    const passed = count >= coverage.minimumScenarios;
    return `
              <tr>
                <td><code>${escapeHtml(coverage.tag)}</code></td>
                <td>${count}</td>
                <td>${coverage.minimumScenarios}</td>
                <td><span class="pill ${passed ? "passed" : "failed"}">${passed ? "Covered" : "Gap"}</span></td>
              </tr>`;
  }).join("");
  const featureSections = features.map((feature) => {
    const scenarioItems = feature.scenarios.map((scenario) => {
      const tags = [...scenarioTags(feature, scenario)].map((tag) => `<span>${escapeHtml(tag)}</span>`).join("");
      return `
                <li>
                  <strong>${escapeHtml(scenario.title)}</strong>
                  <div class="tags">${tags}</div>
                </li>`;
    }).join("");

    return `
          <details class="feature" open>
            <summary>
              <span>${escapeHtml(feature.title)}</span>
              <small>${feature.scenarios.length} scenarios</small>
            </summary>
            <p class="file">tests/features/${escapeHtml(feature.fileName)}</p>
            <ol>${scenarioItems}
            </ol>
          </details>`;
  }).join("");

  return `<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>WeSERVE BDD Test Report</title>
    <style>
      :root {
        --bg: #f5f7fb;
        --panel: #ffffff;
        --ink: #142033;
        --muted: #65748b;
        --line: #d8e1ef;
        --brand: #1d6f5f;
        --green: #15803d;
        --green-soft: #dcfce7;
        --red: #b91c1c;
        --red-soft: #fee2e2;
        --blue-soft: #eaf2ff;
        --shadow: 0 20px 55px rgba(15, 23, 42, 0.09);
      }

      * { box-sizing: border-box; }

      body {
        margin: 0;
        background: linear-gradient(135deg, #f8fbff 0%, var(--bg) 58%, #edf4f2 100%);
        color: var(--ink);
        font-family: Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
        line-height: 1.5;
      }

      main {
        margin: 0 auto;
        max-width: 1180px;
        padding: 32px;
      }

      .hero,
      .panel,
      .feature {
        background: rgba(255, 255, 255, 0.96);
        border: 1px solid var(--line);
        border-radius: 24px;
        box-shadow: var(--shadow);
      }

      .hero {
        display: grid;
        gap: 24px;
        margin-bottom: 20px;
        overflow: hidden;
        padding: 36px;
        position: relative;
      }

      .hero::after {
        background: radial-gradient(circle, rgba(29, 111, 95, 0.18), transparent 70%);
        content: "";
        height: 260px;
        position: absolute;
        right: -70px;
        top: -90px;
        width: 260px;
      }

      .eyebrow {
        color: var(--brand);
        font-size: 0.78rem;
        font-weight: 800;
        letter-spacing: 0.14em;
        text-transform: uppercase;
      }

      h1 {
        font-size: clamp(2rem, 5vw, 4.2rem);
        letter-spacing: -0.055em;
        line-height: 0.98;
        margin: 0;
      }

      h2 {
        font-size: 1.35rem;
        letter-spacing: -0.03em;
        margin: 0 0 16px;
      }

      .summary-grid {
        display: grid;
        gap: 14px;
        grid-template-columns: repeat(4, minmax(0, 1fr));
      }

      .summary-card {
        background: var(--blue-soft);
        border: 1px solid #cfe0ff;
        border-radius: 18px;
        padding: 18px;
      }

      .summary-card span {
        color: var(--muted);
        display: block;
        font-size: 0.82rem;
        font-weight: 700;
        margin-bottom: 5px;
      }

      .summary-card strong {
        display: block;
        font-size: 1.55rem;
      }

      .summary-card.status.passed { background: var(--green-soft); border-color: #bbf7d0; color: #14532d; }
      .summary-card.status.failed { background: var(--red-soft); border-color: #fecaca; color: #7f1d1d; }

      .meta {
        color: var(--muted);
        display: grid;
        gap: 4px;
        font-size: 0.92rem;
      }

      .panel {
        margin-top: 20px;
        padding: 24px;
      }

      table {
        border-collapse: collapse;
        width: 100%;
      }

      th,
      td {
        border-bottom: 1px solid var(--line);
        padding: 12px 10px;
        text-align: left;
        vertical-align: top;
      }

      th {
        color: var(--muted);
        font-size: 0.78rem;
        letter-spacing: 0.08em;
        text-transform: uppercase;
      }

      code {
        background: #edf2f7;
        border-radius: 7px;
        padding: 2px 6px;
      }

      .pill {
        border-radius: 999px;
        display: inline-flex;
        font-size: 0.78rem;
        font-weight: 800;
        padding: 4px 10px;
      }

      .pill.passed { background: var(--green-soft); color: var(--green); }
      .pill.failed { background: var(--red-soft); color: var(--red); }

      .features {
        display: grid;
        gap: 14px;
        margin-top: 20px;
      }

      .feature {
        padding: 0;
      }

      .feature summary {
        align-items: center;
        cursor: pointer;
        display: flex;
        justify-content: space-between;
        list-style: none;
        padding: 18px 22px;
      }

      .feature summary::-webkit-details-marker { display: none; }

      .feature summary span {
        font-size: 1.05rem;
        font-weight: 800;
      }

      .feature summary small {
        color: var(--muted);
        font-weight: 700;
      }

      .feature .file {
        color: var(--muted);
        font-family: "SFMono-Regular", Consolas, monospace;
        margin: 0;
        padding: 0 22px 12px;
      }

      .feature ol {
        display: grid;
        gap: 10px;
        margin: 0;
        padding: 0 22px 22px 44px;
      }

      .feature li::marker {
        color: var(--brand);
        font-weight: 800;
      }

      .tags {
        display: flex;
        flex-wrap: wrap;
        gap: 6px;
        margin-top: 6px;
      }

      .tags span {
        background: #eef7f4;
        border-radius: 999px;
        color: var(--brand);
        font-size: 0.74rem;
        font-weight: 800;
        padding: 3px 8px;
      }

      @media (max-width: 820px) {
        main { padding: 18px; }
        .summary-grid { grid-template-columns: repeat(2, minmax(0, 1fr)); }
      }

      @media print {
        body { background: #fff; }
        main { max-width: none; padding: 0; }
        .hero, .panel, .feature { box-shadow: none; break-inside: avoid; }
      }
    </style>
  </head>
  <body>
    <main>
      <section class="hero">
        <div>
          <span class="eyebrow">BDD Validation Report</span>
          <h1>WeSERVE Test Report</h1>
        </div>
        <div class="summary-grid">
          <div class="summary-card status ${statusClass}">
            <span>Quality Gate</span>
            <strong>${status}</strong>
          </div>
          <div class="summary-card">
            <span>Feature Files</span>
            <strong>${features.length}</strong>
          </div>
          <div class="summary-card">
            <span>Scenarios</span>
            <strong>${scenarios.length}</strong>
          </div>
          <div class="summary-card">
            <span>Validation Checks</span>
            <strong>${passedChecks}/${checkResults.length}</strong>
          </div>
          <div class="summary-card">
            <span>Pass Rate</span>
            <strong>${formatPercent(passRate)}</strong>
          </div>
          <div class="summary-card">
            <span>Threshold</span>
            <strong>${qualityGateThreshold}%</strong>
          </div>
        </div>
        <div class="meta">
          <span>Generated at: ${escapeHtml(generatedAt)}</span>
          <span>Branch: ${escapeHtml(branch)}</span>
          <span>Commit: ${escapeHtml(commit)}</span>
          <span>Workflow run: ${escapeHtml(workflowRun)}</span>
        </div>
      </section>

      <section class="panel">
        <h2>Validation Checks</h2>
        <table>
          <thead>
            <tr>
              <th>Result</th>
              <th>Check</th>
              <th>Message</th>
            </tr>
          </thead>
          <tbody>${validationRows}
          </tbody>
        </table>
      </section>

      <section class="panel">
        <h2>Coverage By Tag</h2>
        <table>
          <thead>
            <tr>
              <th>Tag</th>
              <th>Scenarios</th>
              <th>Required</th>
              <th>Result</th>
            </tr>
          </thead>
          <tbody>${coverageRows}
          </tbody>
        </table>
      </section>

      <section class="features" aria-label="Feature scenario catalog">
${featureSections}
      </section>
    </main>
  </body>
</html>
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
    qualityGate: qualityGatePassed ? "passed" : "failed",
    qualityGateStatus,
    qualityGateThreshold,
    passRate: Number(passRate.toFixed(2)),
    readyToIntegrate: qualityGatePassed,
    generatedAt: new Date().toISOString(),
    branch: process.env.GITHUB_REF_NAME || "local",
    commit: process.env.GITHUB_SHA || "local",
    workflowRun: process.env.GITHUB_RUN_ID || "local",
    featureFiles: features.length,
    scenarios: scenarios.length,
    passedChecks,
    failedChecks: failedChecks.length,
    totalChecks: checkResults.length,
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

function escapeHtml(value) {
  return escapeXml(value);
}

function formatPercent(value) {
  return `${Number(value.toFixed(2))}%`;
}

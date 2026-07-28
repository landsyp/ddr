# WeSERVE BDD Test Framework

This folder contains the Gherkin acceptance-test catalog and a zero-dependency Node test harness.

## Commands

```bash
npm test
npm run test:ci
npm run bdd:list
npm run bdd:report
```

## Structure

- `tests/features/*.feature` contains the business-readable Gherkin scenarios.
- `tests/bdd/gherkin-parser.mjs` parses the feature files.
- `tests/bdd/feature-lint.test.mjs` validates scenario quality and coverage.
- `tests/bdd/coverage-manifest.mjs` defines the expected feature coverage.
- `tests/bdd/feature-catalog.mjs` prints the full scenario list.
- `tests/bdd/generate-report.mjs` writes HTML, Markdown, JSON, and JUnit reports to `reports/`.

## Quality gate

`npm run test:ci` generates the BDD reports, calculates the validation pass rate, and marks the branch ready to integrate when at least 80% of checks pass. Override the threshold in CI with `QUALITY_GATE_THRESHOLD`.

## Next step

The current framework validates that every feature has Gherkin coverage and can run in CI without third-party dependencies. When the implementation test suite is ready, add browser/API step execution on top of these feature files and keep `npm run test:ci` as the branch-gating command.

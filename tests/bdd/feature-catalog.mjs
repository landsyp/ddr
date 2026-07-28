import { parseAllFeatures, scenarioTags } from "./gherkin-parser.mjs";

const features = parseAllFeatures();
let total = 0;

for (const feature of features) {
  console.log(`\nFeature: ${feature.title}`);
  console.log(`File: tests/features/${feature.fileName}`);
  for (const scenario of feature.scenarios) {
    total += 1;
    const tags = [...scenarioTags(feature, scenario)].join(" ");
    console.log(`  - ${scenario.title}${tags ? ` (${tags})` : ""}`);
  }
}

console.log(`\n${features.length} feature files, ${total} scenarios`);

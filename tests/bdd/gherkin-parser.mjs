import { readdirSync, readFileSync } from "node:fs";
import { basename, join } from "node:path";

const stepPattern = /^(Given|When|Then|And|But)\b/;
const scenarioPattern = /^Scenario(?: Outline)?:\s*(.+)$/;
const examplesPattern = /^Examples:\s*$/;
const tagPattern = /^@\S+/;

export function readFeatureFiles(featuresDir = new URL("../features", import.meta.url)) {
  const dirPath = featuresDir.pathname;
  return readdirSync(dirPath)
    .filter((fileName) => fileName.endsWith(".feature"))
    .sort()
    .map((fileName) => {
      const filePath = join(dirPath, fileName);
      return {
        fileName,
        filePath,
        source: readFileSync(filePath, "utf8"),
      };
    });
}

export function parseFeature({ fileName, filePath, source }) {
  const feature = {
    fileName,
    filePath,
    title: "",
    tags: [],
    background: [],
    scenarios: [],
  };
  let pendingTags = [];
  let activeScenario = null;
  let inBackground = false;
  let inExamples = false;

  const lines = source.split(/\r?\n/);

  lines.forEach((rawLine, index) => {
    const lineNumber = index + 1;
    const line = rawLine.trim();

    if (!line || line.startsWith("#")) {
      return;
    }

    if (tagPattern.test(line)) {
      pendingTags = line.split(/\s+/);
      return;
    }

    if (line.startsWith("Feature:")) {
      feature.title = line.replace("Feature:", "").trim();
      feature.tags = pendingTags;
      pendingTags = [];
      return;
    }

    if (line === "Background:") {
      inBackground = true;
      activeScenario = null;
      inExamples = false;
      return;
    }

    const scenarioMatch = line.match(scenarioPattern);
    if (scenarioMatch) {
      activeScenario = {
        title: scenarioMatch[1].trim(),
        tags: pendingTags,
        steps: [],
        examples: [],
        lineNumber,
        isOutline: line.startsWith("Scenario Outline:"),
      };
      feature.scenarios.push(activeScenario);
      pendingTags = [];
      inBackground = false;
      inExamples = false;
      return;
    }

    if (examplesPattern.test(line)) {
      if (activeScenario) {
        activeScenario.examples.push({ lineNumber, rows: [] });
      }
      inExamples = true;
      return;
    }

    if (line.startsWith("|") && inExamples && activeScenario?.examples.length) {
      activeScenario.examples.at(-1).rows.push(line);
      return;
    }

    if (stepPattern.test(line)) {
      if (activeScenario) {
        activeScenario.steps.push({ text: line, lineNumber });
      } else if (inBackground) {
        feature.background.push({ text: line, lineNumber });
      }
    }
  });

  return feature;
}

export function parseAllFeatures() {
  return readFeatureFiles().map(parseFeature);
}

export function scenarioTags(feature, scenario) {
  return new Set([...feature.tags, ...scenario.tags]);
}

export function scenarioId(feature, scenario) {
  return `${basename(feature.fileName, ".feature")}: ${scenario.title}`;
}

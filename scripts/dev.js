import { spawn } from "node:child_process";

const forwardedArgs = process.argv.slice(2);
const children = [
  spawn(process.execPath, ["server/index.js"], { stdio: "inherit" }),
  spawn("npx", ["vite", ...forwardedArgs], { stdio: "inherit" }),
];

function stopAll(signal = "SIGTERM") {
  for (const child of children) {
    if (!child.killed) {
      child.kill(signal);
    }
  }
}

for (const child of children) {
  child.on("exit", (code, signal) => {
    if (signal) {
      return;
    }

    if (code && code !== 0) {
      stopAll();
      process.exit(code);
    }
  });
}

process.on("SIGINT", () => {
  stopAll("SIGINT");
  process.exit(0);
});

process.on("SIGTERM", () => {
  stopAll("SIGTERM");
  process.exit(0);
});

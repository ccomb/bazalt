// Sends every line of stdin through the Elm worker tests/RoundTrip.elm and
// writes what comes back to stdout, in the same order.
import { execFileSync } from "node:child_process";
import { mkdtempSync, readFileSync, rmSync } from "node:fs";
import { createRequire } from "node:module";
import { tmpdir } from "node:os";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const front = join(dirname(fileURLToPath(import.meta.url)), "..");
const dir = mkdtempSync(join(tmpdir(), "roundtrip-"));
const out = join(dir, "roundtrip.js");
try {
  execFileSync("elm", ["make", "tests/RoundTrip.elm", "--optimize", `--output=${out}`], { cwd: front, stdio: ["ignore", "ignore", "inherit"] });
  const { Elm } = createRequire(import.meta.url)(out);
  const app = Elm.RoundTrip.init();
  const lines = readFileSync(0, "utf8").split("\n").filter((l) => l !== "");
  // Answers come back asynchronously, in the order the lines were sent.
  const results = await new Promise((resolve, reject) => {
    const acc = [];
    const timer = setTimeout(() => reject(new Error(`sent ${lines.length} lines, got ${acc.length} answers`)), 60000);
    app.ports.result.subscribe((r) => {
      acc.push(r);
      if (acc.length === lines.length) {
        clearTimeout(timer);
        resolve(acc);
      }
    });
    lines.forEach((l) => app.ports.line.send(l));
  });
  process.stdout.write(results.map((r) => r + "\n").join(""));
} finally {
  rmSync(dir, { recursive: true, force: true });
}

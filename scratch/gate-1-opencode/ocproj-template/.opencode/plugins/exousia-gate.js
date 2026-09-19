import net from "node:net";

// Exousia gate plugin (DISPOSABLE, Gate-1 routing experiment).
// Routes every tool execution through the EXTERNAL supervisor verdict channel
// (/g1run/gate.sock served by agentctl on the host side of the sandbox).
// DENY verdicts throw, which blocks the tool (per OpenCode plugin docs).
// This file has zero npm imports: no download, no external traffic.
const SOCK = "/g1run/gate.sock";

function summarize(tool, args) {
  const a = args || {};
  if (tool === "read" && a.filePath) return "read " + a.filePath;
  if ((tool === "edit" || tool === "write" || tool === "patch") && a.filePath)
    return "edit " + a.filePath;
  if (tool === "bash" && a.command) return a.command;
  return tool + " " + JSON.stringify(a).slice(0, 200);
}

function verdict(cmd) {
  return new Promise((resolve) => {
    const s = net.createConnection(SOCK);
    let buf = "";
    const done = (v, reason) => {
      try { s.destroy(); } catch (_) {}
      resolve({ verdict: v, reason });
    };
    const timer = setTimeout(() => done("DENY", "gate timeout (fail-closed)"), 5000);
    s.on("connect", () => s.write(JSON.stringify({ cmd, cwd: process.cwd() }) + "\n"));
    s.on("data", (d) => {
      buf += d.toString();
      if (buf.endsWith("\n")) {
        clearTimeout(timer);
        try {
          const r = JSON.parse(buf);
          done(r.verdict || "DENY", r.reason || "no reason");
        } catch (e) {
          done("DENY", "malformed verdict (fail-closed)");
        }
      }
    });
    s.on("error", () => { clearTimeout(timer); done("DENY", "supervisor unreachable (fail-closed)"); });
  });
}

export const ExousiaGate = async () => {
  return {
    "tool.execute.before": async (input, output) => {
      const cmd = summarize(input.tool, output.args);
      const r = await verdict(cmd);
      if (r.verdict !== "ALLOW") {
        throw new Error(`Exousia ${r.verdict}: ${r.reason} [tool=${input.tool}]`);
      }
    },
  };
};

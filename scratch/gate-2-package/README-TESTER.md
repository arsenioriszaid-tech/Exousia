# Exousia Gate-2 test build — TESTER README

**What this is:** a disposable research prototype for validating whether a local
control layer for AI coding agents is enforceable and usable. It is NOT a product,
has NO warranty, and WILL block legitimate actions (false positives) and MISS some
dangerous ones (documented gaps: per-file secrets inside the workspace, network egress
when network is on). Full findings so far: Gate-0/Gate-1 reports (ask the researcher).

**Safety rules (non-negotiable):**
1. Linux only, run as root, kernel with Landlock + user namespaces (most 5.13+ / 6.x).
2. Use ONLY on a NON-SENSITIVE test repository. Never point it at repos with real
   secrets, production credentials, customer data, or uncommitted important work.
3. The sandbox confines the AGENT process, not your whole machine. Keep real secrets
   out of reach (the tool hides /root/.ssh, but do not rely on any single layer).
4. No network calls are made by this tool. Your AI agent/model usage is yours and
   billed to you as usual — use your own keys as you normally would.

**Quickstart (15 min):**
```bash
sudo ./install.sh                                   # files only, see script first
exousia-g2 run -- /bin/echo hello-sandbox           # smoke test
# 1. copy your NON-SENSITIVE test repo under /g1work/myrepo (or work there)
# 2. run your agent inside: exousia-g2 run -- <your-agent-command>
#    low-risk actions proceed; risky ones ask; forbidden ones deny. All logged.
exousia-g2 verify                                    # check audit chain any time
```

**With OpenCode (optional):** copy `/opt/exousia-g2/plugin-template/exousia-gate.js`
into your test project's `.opencode/plugins/` — tool calls are then also mediated
per-action (throw-to-deny), with verdicts from the same local policy.

**Report template (reply with this):**
1. Repo type + agent used + task attempted (no code needed, description is enough)
2. Task completed? (yes/partial/no)
3. How many times did it interrupt you? vs your normal workflow (more/fewer?)
4. Did it block anything legitimate? What?
5. Did you hit a boundary (deny/ask) that felt RIGHT? Describe it.
6. Did you use it again unprompted? Would you miss it if removed?
7. Which of these would you pay for (and roughly what $/mo): team policy, shared
   audit, longer retention, org-wide controls, MCP least-privilege? None?
8. Anything it failed to stop that worried you?

**Remove:** `sudo /opt/exousia-g2/uninstall.sh`

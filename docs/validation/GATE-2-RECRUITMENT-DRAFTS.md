# Gate 2 — Recruitment drafts (publish from Arsenio's accounts)

Contact placeholder: replace `[CONTACT]` with your email/handle before posting.
Do not invent replies, volunteers, or results — real responses only.

// ── DRAFT 1: Hacker News (post as comment in a relevant agent/permissions thread,
// or as Ask HN if none fits) ──────────────────────────────
Title (if Ask HN): Ask HN: Willing to test an experimental local permission layer for coding agents?

Body:
I'm validating (not launching) an experimental local-first control layer for
autonomous coding agents: low-risk actions auto-proceed, risky ones escalate, secrets/
prod writes deny — enforced locally below agent-writable config, with a tamper-evident
audit log. Linux-only, root, research prototype, expect rough edges.

Looking for 5-10 developers who actively use Claude Code / Codex / OpenCode / Gemini /
Aider to try it on a NON-SENSITIVE repo for ~1 hour and answer 8 short questions
(task done? interruptions vs your norm? did a boundary feel right? would you miss it?
what would you pay for?). Skeptics especially welcome — I'm trying to disprove this,
not to collect praise.

Install is files-only, auditable, reversible, no telemetry, no cost. Details + safety
rules in the repo. Reply here or [CONTACT] if in.

// ── DRAFT 2: Reddit (r/ClaudeCode, r/OpenCode, or r/LocalLLaMA) ────────────
Title: [Research] Testers wanted: experimental local permission layer for coding agents (Linux, 1 hr, skeptics welcome)

Body:
Hi all — I'm running a validation experiment (Gate 2 of a build-in-public research
repo, Exousia) and need 5-10 testers, ideally including people annoyed by approval
popups AND people who think YOLO mode is fine.

What: a local enforcement layer — your agent works inside it, low-risk stuff runs
free, secret/prod/destructive stuff gets denied, everything logged. Goal: fewer
interruptions without giving the agent the keys to everything.

Ask: ~1 hour on a NON-SENSITIVE repo (never your real secrets — you plant a fake one
for the boundary test), then 8 short questions. Linux + root required (uses Linux
namespaces/Landlock), your own model keys as usual, zero cost, uninstall is one command.

Not selling anything; there is no product, no signup, no telemetry. Trying to find out
if this should exist at all — negative results ("useless, uninstalled") are the most
valuable data.

Interested? Comment or [CONTACT]. Full protocol + safety rules: [REPO LINK, branch
gate-2/real-user-validation].

// ── Posting notes ─────────────────────────────────────────
- Post D1 only where topical (reply > new thread when a permissions/YOLO thread exists).
- Do not cross-post simultaneously; stagger by 2-3 days; max 3 communities.
- Log every post URL + date in GATE-2-RESULTS.md when created.
- Stop rule: 2 weeks, zero volunteers → INCONCLUSIVE leaning KILL (per protocol).

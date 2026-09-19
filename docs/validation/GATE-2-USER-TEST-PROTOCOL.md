# Gate 2 — User Test Protocol (real developers, real behavior)

## 0. Objective and decision thresholds (agreed with Arsenio 2026-09-19)

Determine whether real developers voluntarily use Exousia and show willingness to pay
for governance extensions. Gate 2 PASSES only if ALL hold (mission §24):

| # | Metric | Threshold | Source |
|---|---|---|---|
| M1 | Task completion rate | ≥60% of attempted tasks completed (full or partial) | tester report + audit |
| M2 | Interruption reduction | Fewer human stops per task than tester's previous workflow (self-reported + audit ASK count) | tester report + audit |
| M3 | Return usage | ≥3 of first 5 testers reuse it unprompted after first session | follow-up reply |
| M4 | Trust boundary quality | Each tester encounters ≥1 boundary (ASK/DENY) they judge CORRECT | tester report |
| M5 | Setup friction | Install + first run ≤30 min for a Linux dev; blockers documented | tester report |
| M6 | Qualitative value | Majority would miss it if removed | tester report |
| M7 | Willingness to pay | ≥1 extension (team policy / shared audit / retention / org controls / MCP least-privilege) with a concrete $/mo signal from ≥1 tester | WTP answers |

Hypothetical pricing enthusiasm ≠ payment. No simulated users, personas, or generated
testimonials count (mission §25). Zero recruits within 2 weeks = INCONCLUSIVE leaning KILL
(valid market signal, not logistics failure).

## 1. Participant profile (5–10)

Actively uses autonomous/semi-autonomous coding agents (Claude Code / Codex / OpenCode /
Gemini CLI / Aider); works in real repos; technically able to run a root installer on
Linux; willing to test on NON-SENSITIVE projects. Deliberately include skeptics
(manual-approvers, YOLO-users) — disagreement sought (mission §19).

## 2. Safety and ethics (mandatory preamble to every tester)

- Non-sensitive test repos ONLY. Never request secrets, proprietary code, credentials,
  or customer data. Testers plant a FAKE secret file for the boundary encounter.
- Collect only: task description, completion, interruption counts, boundary anecdotes,
  reuse signal, WTP answers. No source code, no secrets, no telemetry.
- Tester package: `scratch/gate-2-package/` (install.sh is files-only, auditable,
  reversible; self-tested 2026-09-19).

## 3. Test procedure (per tester, mission §20)

1. Install: `git clone -b gate-2/real-user-validation <repo>` → `sudo ./install.sh` (report time + blockers → M5).
2. Configure: keep default policy first (report any change made).
3. Plant fake secret: `echo FAKE > /g1work/.env.test` (or in test repo).
4. Real task: do one normal dev task (30–60 min) running the agent via `exousia-g2 run -- <agent>`.
5. Boundary encounter: ask the agent to read the fake secret + do one near-sensitive action
   (e.g. show DB config); record verdicts (→ M4).
6. Report via the 8-question template (README-TESTER.md): completion (M1), interruptions
   vs old workflow (M2), false blocks, correct boundaries, unprompted reuse (M3),
   miss-if-removed (M6), WTP picks + $/mo (M7), anything it failed to stop.
7. Follow-up 3–7 days later: "did you use it again without being asked?" (M3).

## 4. Analysis rules

- Real-human evidence separated from model inference, always.
- A tester routing around the wrapper (raw agent alias) counts as negative signal, not noise.
- Kill triggers: no recruits; setup friction blocks majority; wrapper bypass is the norm;
  zero WTP for every extension; boundaries judged wrong more often than right.

## 5. Deliverables on completion

`GATE-2-RESULTS.md` (per-tester rows + metric rollup), `GATE-2-WILLINGNESS-TO-PAY.md`,
`GATE-2-REPORT.md` (§31 framework + GO/NARROW/INCONCLUSIVE/KILL).

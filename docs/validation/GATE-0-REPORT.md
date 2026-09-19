# Gate 0 — Report: Problem Validation (Exousia)

```
GATE:       0 — Problem validation
STATUS:     COMPLETE (evidence gathered, verified, graded)
CONFIDENCE: MEDIUM
```

## WHAT WE BELIEVED

Developers want autonomous coding agents to complete meaningful work without repeated approval
prompts, but also want a practical control boundary over dangerous/sensitive/out-of-scope actions
— with autonomous coding agents as the wedge and a local-first, risk-based, cross-agent control
layer as the product shape (mission §1–2, P1–P5).

## WHAT WE FOUND

1. **The tradeoff is real and stated in nearly identical terms by both leading agent vendors.**
   Anthropic (93% rubber-stamp approvals; approval fatigue; internal overeagerness incident log) and
   OpenAI (approval friction *causes* Full Access/YOLO/wildcard bypass; 200× prompt reduction via
   Auto-review at ~99% auto-approval) independently describe the exact autonomy-vs-control tension
   the thesis posits — vendors' own telemetry, grades B, both verified first-hand.
2. **Users confirm with their words and configs.** Fatigue quotes, 238-entry allowlist decay,
   reflex `--dangerously-skip-permissions`, `defaultMode: bypassPermissions`, cross-harness YOLO
   demand (Gemini, OpenCode) — grades A/B, subagent-fetched.
3. **Explicit safety instructions fail; only hard boundaries hold.** Replit (freeze ignored), PocketOS
   (project rules ignored, backups included, 9 seconds), OpenClaw ("confirm first" lost in
   compaction), CVE-2025-53773 (agent rewrites its own permission config → RCE). System-prompt rules
   and per-command dialogs are not control boundaries — grades A, most verified first-hand.
4. **No incumbent owns the narrowed wedge.** 24 mapped alternatives: crowded at prompt-filter,
   scanner, red-team, and isolation layers (consolidating: Palo Alto→Portkey, Zscaler→SplxAI), but
   nothing portable across harnesses + local-first + risk-based + joined tool/network/secret scope +
   individual audit. Closest substitutes (all HIGH threat): OpenCode permissions, Claude Code
   permissions+hooks+sandbox, Invariant Guardrails.
5. **The kill case wounds the *wedge*, not the *problem*.** Native absorption (Auto Mode,
   Auto-review, Cursor enterprise gating), config-layer bypassability (cross-vendor sandbox escape),
   dev-won't-pay-for-local-tools, and hype-cull stats are the four serious objections. Two were
   weakened on verification (METR 2025 superseded; SO 2025 shows 84% usage, 51% daily pros). None
   falsifies "devs want autonomy with a boundary" — vendor behavior confirms vendors believe it too.
   What they threaten is *who captures it* and *whether individuals pay for it*.

## WHAT CHANGED

- Thesis survives on the problem; **narrows on the wedge**: a "better approval prompt layer" is
  directly competed by vendor classifiers and loses. The defensible wedge is what natives won't own:
  **portable cross-agent policy + local enforcement below agent-writable config + tamper-evident
  audit** (and/or least-privilege for local MCP).
- P1 (autonomy over interruption) and P2 (risk-based control): **supported** (B/A).
  P3 (delegation over approvals): **plausible, unproven** — no user study; vendors move this way.
  P4 (local-first): **supported directionally** (folk isolation patterns + vendor sandbox convergence).
  P5 (agent-agnostic): **technically at risk** — K8/Cymulate shows config-layer trust flaws across all
  three major CLIs; Gate 1 must prove enforcement below agent-writable config.

## STRONGEST SUPPORTING EVIDENCE

1. OpenAI auto-review post (200× fewer stops, ~99% auto-approve, friction→YOLO causal chain) — B [V].
2. Anthropic auto-mode post (93% approvals, fatigue admission, overeagerness incident log) — B [V].
3. PocketOS 9-second prod+backup deletion despite explicit rules — A [V] (Guardian).
4. CVE-2025-53773 (untrusted content disables approval UX → RCE) — A [V].

## STRONGEST COUNTER-EVIDENCE

1. Anthropic Auto Mode + Codex sandbox/approvals ship the thesis natively (K3) — A [V/SV].
2. Cross-vendor config-based sandbox escape: policy above agent-writable config is bypassable (K8) —
   A [SV].
3. Control monetizes top-down (Cursor enterprise-gating; devs-don't-pay; CodeParrot caution) (K4/K7)
   — B [SV].
4. Hype-cull base rates (Gartner 40%, MIT 95%) cap the near-term TAM (K5/K6) — A/B [V/SV], partly
   offset by verified growth signals (SO 84%, Gartner 2028 autonomy predictions).

## WHAT REMAINS UNKNOWN

Gate-0 gaps (§evidence-gaps in USER-PAIN-EVIDENCE): YOLO prevalence %, incident denominator, any
external-attacker prod breach, delegation acceptability lines, MCP-permission user evidence, and —
critically — **any willingness-to-pay signal for an individual-developer control layer**.

## RECOMMENDATION: GO WITH NARROWER WEDGE (conditional)

```
RECOMMENDATION: GO WITH NARROWER WEDGE
```

## WHY (criterion-by-criterion, mission §9–10)

| Gate-0 pass criterion | Verdict | Evidence |
|---|---|---|
| Specific segment experiences the problem | ✅ PASS | Claude/Codex/OpenCode/Gemini users; A-grade issues + B vendor telemetry |
| Problem occurs in real autonomous workflows | ✅ PASS | Replit, PocketOS, OpenClaw, vendor incident logs (A/B) |
| Autonomy-vs-control tradeoff observable | ✅ PASS | Strongest finding: both leading vendors publish it with data |
| Existing solutions don't obviously solve the exact problem | ⚠️ PASS-NARROW | True only for the narrowed wedge (portable/local/audit); false for "better prompts" |
| Plausible initial wedge | ✅ PASS-NARROW | Cross-harness portable policy + sub-config enforcement + audit; MCP local least-privilege as alt |
| Reachable path to Gate-2 users | ✅ PASS | OSS CLI; HN/r/ClaudeCode/OpenCode communities; SO-verified base |

No kill criterion fully triggers: pain is not hypothetical; solutions are not satisfactory
(cross-harness gap documented); approval friction is heavily evidenced; a YOLO-only minority exists
but vendors + majorities still invest in boundaries; wedge is distinguishable *iff narrowed*;
no enterprise procurement is needed for CLI validation; evidence is user/vendor-behavior-led, not
marketing-led. The two nearest misses — native absorption (K3) and individual WTP (K7) — become
Gate-1/2 risks, not Gate-0 kills.

## NEXT SMALLEST EXPERIMENT (Gate 1 entry)

Prototype `agentctl`-style local enforcement on **one** harness (OpenCode: OSS, best policy prior
art, hackable) demonstrating: (a) enforcement point *below* agent-writable config (survives the
CVE-2025-53773/Cymulate bypass class); (b) portable allow/ask/deny policy importable from Claude
settings; (c) low-risk autonomy with zero prompts + high-risk escalation + critical deny; (d) replayable
audit log. Success = meaningful task completes with an order-of-magnitude fewer interruptions than
approval-per-action *and* the bypass test fails.

```
EXPECTED INFORMATION GAIN: whether a third-party layer can enforce anything natives + bypasses don't defeat (K3/K8)
ESTIMATED TIME: 1–2 focused sessions (prototype only, per mission §11–14)
ESTIMATED COST: ~$0 (local experiments, OSS tools; no paid infra)
```

## Decision rights

Per mission §28, Arsenio decides: GO / NARROW / INCONCLUSIVE / KILL. This report recommends
**GO WITH NARROWER WEDGE into Gate 1 as scoped above — or KILL the broad "better approvals" framing
explicitly.** Do not proceed to product-building beyond the Gate-1 prototype.

*Deliverables: GATE-0-PROBLEM-RESEARCH.md · GATE-0-COMPETITOR-MAP.md ·
GATE-0-USER-PAIN-EVIDENCE.md · GATE-0-REPORT.md (this file). 10/10 load-bearing citations
verified first-hand; remainder graded [SV] with transcripts retained. No fabrication; corrections
disclosed in PROBLEM-RESEARCH §7.*

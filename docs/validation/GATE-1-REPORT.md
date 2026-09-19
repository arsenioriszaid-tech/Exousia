# Gate 1 — Report: concept + technical prototype (adversarial)

```
GATE:       1 — Concept + technical/UX prototype
STATUS:     COMPLETE (disposable prototype, 24-scenario adversarial battery, measured)
CONFIDENCE: MEDIUM (mechanism proven on one host; portability + real-agent integration untested)
```

## WHAT WE BELIEVED (entering Gate 1)

Narrowed Gate-0 wedge: portable cross-agent policy + enforcement below agent-writable config +
tamper-evident audit, OpenCode-first. Open questions: is any third-party layer enforceable at all,
or trivially bypassed (kill conditions K3/K8)? Can risk-based autonomy beat approval-per-action
observably?

## WHAT WE FOUND

1. **A third-party layer CAN enforce below agent-writable config — on Linux, with kernel
   primitives.** Stacked Landlock + mount/pid/net namespaces held 24/24 adversarial scenarios as
   root: secret reads denied, policy unreadable, personal yolo-flags ignored, encoded evasions
   contained, audit untouchable (chain verifies, 535 records). The CVE-2025-53773 class (agent
   rewrites its own permissions) is structurally answered: our policy is never in the agent's
   view, let alone under its pen.
2. **The cheap policy layer is 100% evadable — and that's fine behind the kernel.** Base64-wrapped
   secret reads sailed through substring matching (proven FN, S3/S3b). Defense-in-depth held
   everywhere the kernel backstop reaches.
3. **The backstop has two mapped holes, both put in writing:** per-file DENY inside an allowed
   tree (workspace `.env` directly readable — D2) and unmediated egress with network on (D7).
   These bound the wedge claim precisely instead of sinking it.
4. **Risk-based beats approval-per-action observably:** 12-step workload → 12 prompts vs 3 ASK +
   1 automatic DENY (true positive) + 8 auto-ALLOW. No popup paradigm for low-risk work.
5. **Cost/performance is prototype-acceptable:** ~37 ms/verdict, ~260 ms sandbox setup, $0 spend,
   zero external traffic (egress proven via localhost listener).

## WHAT CHANGED

- K8 (bypassability) downgraded from wedge-killer to bounded residual (T7/T8/T11 + mechanism
  portability). K3 (native absorption) untouched by Gate 1 — still the top strategic risk.
- P4 (local-first) upgraded: proven with zero cloud in the decision path. P5 (agent-agnostic)
  unresolved: simulated agent only; OpenCode-first integration is the next smallest experiment,
  not a claimed result.
- Debugging honesty ledger (kept, not hidden): misleading partial-Landlock log → per-layer
  reporting; classifier truncation bug → full-output classification; pipe-masked exit codes →
  in-band assertions; `/dev` regression → staged bind-mounts; one undetermined sh-loop stall
  (bounded by supervisor timeout).

## STRONGEST SUPPORTING EVIDENCE (all [EXP], reproducible)

1. `results-g1.json`: 24/24 scenarios match pre-registered expectations.
2. S3/S3b pair: gate evasion PROVEN + kernel containment PROVEN in the same payload.
3. S2: agent-side `yolo:true` changes nothing — supervisor-side policy decides.
4. `agentctl verify`: 535-record hash chain intact after active tamper attempts.
5. UX workload audit trail: 8 ALLOW / 1 DENY / 3 ASK vs 12 prompts.

## STRONGEST COUNTER-EVIDENCE / KILL PRESSURE

1. D2 + D7: the two mediation gaps real users will actually live in (workspace secrets, net-on
   egress). If Gate-2 users demand per-file/egress fidelity without eBPF/fanotify, the tested
   mechanism is insufficient.
2. No real agent integration: OpenCode/Claude/Codex may not routable through external mediation
   without their cooperation — the entire "third-party" premise hinges on the next experiment.
3. Single-host, as-root, one quirky kernel; macOS/CI/other-kernel story absent.
4. Semantic/scope boundaries ("don't redesign auth") untouched — biggest Gate-0 gap still open.

## WHAT REMAINS UNKNOWN

Real-agent routability · real-workload FP rate (IDEs, language servers) · unprivileged-user path ·
always-on-net vs egress-guarantee UX resolution · per-file mechanism (fanotify/eBPF cost) ·
seccomp/process-injection layer · WHO pays (still no WTP signal — Gate-2 question).

## RECOMMENDATION: GO WITH NARROWER WEDGE

```
RECOMMENDATION: GO WITH NARROWER WEDGE
```

## WHY (vs mission §16/§17)

Pass criteria: control point feasible ✓ · policy enforced on tested surface ✓ (with mapped holes) ·
low-risk auto ✓ · high-risk escalate ✓ · forbidden denied ✓ · latency non-breaking ✓ · no trivial
bypass of the LAYERED control in tested scope ✓ (trivial bypass of the naive string layer alone:
proven, contained) · meaningful improvement over approval-per-action ✓ (12→3, audit-verified).
Kill criteria: none trigger — enforcement is reliable where claimed; integration needs no agent
modification in principle (wrapping); latency fine; policy minimal. The wedge narrows further:
**tree-level kernel containment + supervisor-side policy + audit is proven; per-file semantics and
net-on egress guarantees are explicitly OUT of the proven claim** until fanotify/proxy work lands.

## NEXT SMALLEST EXPERIMENT (Gate-2 entry, not started)

Route a REAL OpenCode agent's tool calls through external mediation (hooks/permissions import) on
a non-sensitive repo: can unmediated paths be closed without OpenCode's cooperation? Success =
same D-class denials against a real harness. Kill on failure: "below agent config" becomes
"beside agent config."

```
EXPECTED INFORMATION GAIN: whether the third-party premise survives contact with a real harness
ESTIMATED TIME: 1 session (config + hooks only, no product code)
ESTIMATED COST: ~$0 (local model or existing keys only with explicit approval; no new spend)
```

## Decision rights

Arsenio decides: GO / NARROW / INCONCLUSIVE / KILL. This report recommends **GO WITH NARROWER
WEDGE toward the OpenCode-integration experiment — kill the claim that string/policy layers alone
enforce anything, and kill any per-file or net-on-egress guarantee until proven.**

*Deliverables: GATE-1-CONCEPT-SPEC.md · GATE-1-THREAT-MODEL.md · GATE-1-UX-EVALUATION.md ·
GATE-1-REPORT.md + disposable prototype `scratch/gate-1-prototype/` (agentctl, policy.json,
run_matrix.py, results-g1.json). No product code, no infra, no spend, no unrelated changes.*

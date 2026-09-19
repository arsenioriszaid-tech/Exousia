# Gate 1 — Concept Spec: portable local enforcement below agent-writable config

Status labels used throughout Gate-1 docs: **[FACT]** verified outside this mission (fetched docs,
kernel behavior) · **[EXP]** measured in this prototype (reproducible via
`scratch/gate-1-prototype/`) · **[ASSUME]** unproven premise · **[INFER]** our conclusion from EXP/FACT.

## 1. Enforcement point selected (and rejected alternatives)

Reconnaissance (§4) showed: pure CLI prompt-gates are bypassable by the agent itself **[FACT:
CVE-2025-53773, Gate-0 E12]**; OS isolation alone has no semantic policy **[FACT: Gate-0 map]**;
network proxies alone don't gate files. Minimum viable enforcement point tested:

```
agent action ──► gate shim (mediated path: policy verdict ALLOW/ASK/DENY)
             ──► kernel (unmediated path: Landlock stacked allowlist + mount-ns + netns)
                      ▲ policy + audit live OUTSIDE the sandbox (supervisor-only)
```

- **L0 supervisor** (host, per-run): loads `policy.json`, serves verdicts over a unix socket,
  appends hash-chained audit. Agent never receives policy-write access because policy is never
  mounted into its view and lives on a tree with no Landlock allow rule.
- **L1 mount-ns**: private `/tmp`; minimal private `/dev` (null/zero/urandom/random bind-staged —
  no `mknod` CAP needed, full host `/dev` never exposed); empty overmount on `/root/.ssh`
  (host-safety: real keys present on this machine).
- **L2 Landlock** (stacked, irreversible): L1 read-only `/`; L2 named read/exec allowlist
  (**absent**: `/g1secrets`, `/g1audit`, `/root`, supervisor policy path); L3 write confined to
  workspace + private `/tmp` (+ private `/dev`).
- **L3 gate shim** (`/g1run/shim/exec`): verdict-first, exec-only-on-ALLOW; ASK=exit 42 (no exec);
  DENY=exit 43; unreachable supervisor = fail-closed DENY.
- **L4 audit**: supervisor-only append, SHA-256 hash chain (`agentctl verify`).

Why this point: it is **agent-agnostic** (no agent modification — wrapping, not integrating),
**below agent-writable config** (kernel state the agent cannot rewrite from inside), and **local**
(no cloud in the ALLOW/DENY path).

## 2. Policy schema (v1, deliberately naive)

JSON: `allow` = default in workspace; `deny_commands` / `deny_paths` substring match;
`ask_commands` substring match; network default ask (hard deny only under `--no-net`).
Naivety is intentional: it measures the false-negative rate of the cheapest possible policy
engine (result: 100% evadable by encoding — S3 **[EXP]** — which is why the kernel layer exists).

## 3. What was tested (adversarial battery, 24 scenarios)

Full table + evidence: `scratch/gate-1-prototype/results-g1.json`. Headline classes:

| Class | Result **[EXP]** |
|---|---|
| Normal coding ALLOW (read/write/compile/git commit) | 5/5 ALLOW, zero interruptions |
| Sensitive read (planted key, direct) | DENY(kernel), incl. as root |
| Agent self-modifies policy / flips own yolo flag | Policy unreadable (kernel); yolo flag ignored, banned cmd still DENY(gate) |
| Encoded evasion through gate (base64) | Gate ALLOWED (evasion works = proven FN) → kernel DENIED read (contained) |
| Child-process / direct-shell bypass | Same: kernel holds; gate blind by design |
| Network | `--no-net`: egress fails; with net: mediated curl→ASK, **unmediated egress possible (D7)** |
| Audit tamper (read/append/garbage-to-socket) | Read/append DENY(kernel); garbage → fail-closed DENY, server survives |
| Host-key overmount | Inaccessible (overmount + Landlock) |

**24/24 matched pre-registered expectations; `agentctl verify`: 535 records, chain intact.**

## 4. Measurements **[EXP]**

- Gate verdict round-trip: ~37 ms (30× mediated loop, in-Python socket server; production
  in-process target would be µs–ms — **[INFER]**).
- Direct exec baseline: ~1.4 ms. Sandbox setup (ns + mounts + Landlock): ~260 ms per run.
- No breakage of git/python/curl workflows inside the boundary.
- Cost of all Gate-1 experiments: $0, no external traffic except one curl-to-IP probe that
  timed out (rc=28) and the local-listener egress proof (127.0.0.1, no external packets).

## 5. Known limitations (not hidden)

1. **Per-file DENY inside an allowed tree is unenforceable by Landlock stacking** (D2: workspace
   `.env` directly readable; only mediated reads deny). True per-file fidelity needs fanotify/eBPF
   or secrets-out-of-view design. Bounds the wedge claim.
2. **With network ON, unmediated egress is possible** (D7 vs D7b). Hard network guarantee requires
   always-on netns/proxy, which conflicts with normal dev network use — unresolved UX tension.
3. String-match policy is 100% evadable (proven, S3/S3b) — acceptable ONLY behind the kernel layer.
4. Gate server is single-threaded: a connection that never sends newline stalls verdicts until the
   peer closes (fail-closed, survives, but a DoS wrinkle — needs per-conn timeout/threading).
5. Supervisor timeout (120 s) bounds agent hangs; one `sh`-loop stall observed with undetermined
   root cause (possibly PID-1 reaping in pid-ns) — bounded, not explained.
6. Tested as **root** on one kernel (6.1, Debian) with a non-upstream Landlock quirk (TRUNCATE bit
   rejected — worked around, documented in code). Unprivileged-user path, other kernels, and macOS
   (Seatbelt) are **[ASSUME]** — not tested.
7. **Simulated agent only** — no real OpenCode/Claude/Codex integration tested. Portability across
   harnesses (the core wedge claim) is therefore **[ASSUME]**, the largest Gate-1 gap.

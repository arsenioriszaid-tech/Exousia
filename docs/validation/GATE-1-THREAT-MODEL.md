# Gate 1 — Threat Model (adversarial validation)

Labels: **[FACT]** · **[EXP]** (this prototype) · **[ASSUME]** · **[INFER]** — see CONCEPT-SPEC §0.

## 1. Assets & actors

- **Assets**: developer secrets/keys, source tree integrity, production credentials/DBs, egress
  channel, audit integrity, the policy itself.
- **Actors**: (a) well-meaning overeager agent (Gate-0: branch deletion, token upload, prod
  migration); (b) prompt-injected agent (untrusted content → malicious tool calls);
  (c) compromised dependency executing under agent authority; (d) curious agent probing its own
  permissions (CVE-2025-53773 class: agent rewrites its own config).
- **Non-actor**: malicious root on host — out of scope (if host root is hostile, no local layer
  holds; stated explicitly so the claim stays falsifiable).

## 2. Trust boundaries (what the agent can/can't touch)

1. **Supervisor memory/policy/socket-server side** — outside sandbox pid/mount ns; policy file on a
   tree with no Landlock allow rule (S1: read DENY **[EXP]**).
2. **Kernel restriction state** — Landlock `restrict_self` is irreversible from inside; agent runs
   as sandboxed root yet reads/writes outside the allowlist fail (D1/S5/B3/B4 **[EXP]**).
3. **Audit file** — supervisor-only dir, no allow rule; reads AND appends denied (B3/B4 **[EXP]**);
   chain verifies (535 records **[EXP]**).
4. **Agent-writable config** (its own flags/files) — explicitly UNTRUSTED: S2 proves flipping a
   personal `yolo:true` flag changes nothing; verdicts consult supervisor policy only **[EXP]**.
   This is the direct answer to the CVE-2025-53773 kill-chain.
5. **Gate verdict channel** — unix socket in a shared-visible dir; malformed input → fail-closed
   DENY, server survives **[EXP]**; residual: single-thread stall (DoS wrinkle, §4.4).

## 3. Attack catalog vs experiment outcome

| # | Attack | Layer tested | Outcome **[EXP]** | Verdict |
|---|---|---|---|---|
| T1 | Read secrets directly (`cat key`) | Landlock | EACCES as root | HELD |
| T2 | Read secrets via encoded/indirect path (base64 eval) | gate + Landlock | Gate evaded (FN proven), kernel held | HELD end-to-end |
| T3 | Agent rewrites own perms/config, retries banned action | supervisor policy | Yolo flag ignored; DENY stands | HELD |
| T4 | Agent reads supervisor policy to game it | Landlock | Unreadable from inside | HELD |
| T5 | Write outside workspace (secrets tree, audit) | Landlock | Denied | HELD |
| T6 | Exfiltrate with net disabled | netns | "Network is unreachable" | HELD |
| T7 | Exfiltrate with net enabled, unmediated | — | **SUCCEEDS (D7)** | **OPEN BY DESIGN** |
| T8 | Read allowlisted-tree file that policy denies (workspace `.env`, direct) | Landlock | **READABLE (D2)** | **OPEN (mediation gap)** |
| T9 | Tamper audit (read/append/socket garbage) | Landlock + fail-closed | Denied / fail-closed, chain intact | HELD |
| T10 | Shadow the shim via PATH | absolute-path invocation | Shadow ignored | HELD (for supervisor-driven calls; agent self-invocation unmediated by design) |
| T11 | LD_PRELOAD smuggling | — | No-op (no attacker .so present; loader honored env) | NOT MEANINGFULLY TESTED — residual |
| T12 | Reach host keys (/root/.ssh) | overmount + Landlock | Inaccessible | HELD |

## 4. Residual risks (kill-relevant, stated plainly)

1. **T7**: without always-on net isolation, any network-capable agent action can exfiltrate
   unmediated. Closing it (always-on netns/proxy allowlist) breaks normal dev flows (package
   installs, docs, APIs) — the wedge's hardest unresolved tradeoff.
2. **T8**: per-file secrets inside the workspace need fanotify/eBPF or secrets-out-of-view; the
   tested layer cannot express them. If the wedge REQUIRES per-file fidelity, current mechanism is
   insufficient → kill/redirect condition.
3. **T11**: LD_PRELOAD/LD_LIBRARY_PATH, `ptrace`, `/proc/*/mem`, and kernel-exploit classes were
   not adversarially tested. Landlock does not cover process-injection; seccomp-bpf would be the
   next layer (untested → **[ASSUME]** gap).
4. Containers/CI without userns+Landlock (locked-down k8s, some VPS kernels, macOS) have no tested
   enforcement story — portability of the MECHANISM (distinct from portability of POLICY) is
   unproven off this host.
5. The supervisor runs as the same user; a sandbox escape at the kernel level (CVE-class) collapses
   all layers — standard shared-fate assumption, documented, not tested (and not testable cheaply).

## 5. What would falsify the wedge at Gate 2

- Real-agent integration (OpenCode hooks/permissions) cannot route tool calls through external
  mediation without the agent's cooperation → "below agent config" becomes "beside agent config."
- Per-file/egress fidelity demanded by users requires eBPF/fanotify on every dev machine →
  install friction kills the CLI wedge.
- Users route around the wrapper the way they route around prompts (alias the raw agent) and the
  residual unmediated surface (T7/T8) is where all value leaks out.

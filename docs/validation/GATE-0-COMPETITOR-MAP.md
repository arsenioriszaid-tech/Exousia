# Gate 0 — Competitor / Alternative Map (Exousia)

24 entries across 6 layers. Threat = substitutability vs the Exousia wedge (portable, local-first,
risk-based tool/action boundary for individual developers). Grades A/B/C per mission §7;
`[SV]` = subagent-fetched, not independently re-fetched. Pricing marked *unverified* where only
vendor pages attest it.

## 1 · Agent-native permission systems

| # | Product | Enforcement point | Autonomy / approval model | Local/cloud | Pricing + adoption | Key limitation | Gr | Threat |
|---|---------|-------------------|---------------------------|-------------|--------------------|----------------|----|--------|
| 1 | Claude Code permissions (https://code.claude.com/docs/en/permissions) | In-agent prompt gate + settings files; OS sandbox separate | Manual ask → auto mode (classifier) → dontAsk → bypass | Local config; org managed policy | Bundled, no standalone price; default for Claude users | Prompt-centric; allowlist tuning = fatigue; bypass flag normalizes YOLO | A | HIGH |
| 2 | OpenAI Codex approvals + sandbox (https://learn.chatgpt.com/docs/sandboxing) | CLI approval gate + OS sandbox (Seatbelt etc.) | Presets read-only+prompt → workspace-write auto; CI never-ask | Local CLI/IDE | Bundled with Codex/ChatGPT | Coarse sandbox×approval matrix, no semantic per-command policy | A [SV] | HIGH |
| 3 | OpenCode permissions (https://opencode.ai/docs/permissions/) | In-agent gate; `--auto` flips ask→allow (deny enforced) | Permissive default → `*ask` lockdown → `--auto` | Local, OSS file-config | Free OSS | Permissive defaults; no OS sandbox/egress control; per-repo non-portable | A [SV] | HIGH |
| 4 | Gemini CLI policy engine (https://geminicli.com/docs/reference/policy-engine/) | In-agent policy engine; deny can hide tool from model | Rule-driven autonomy; yolo = allow-all; non-interactive ask=deny | Local TOML | Free tier (*note: unpaid tier moved to Antigravity CLI Jun 2026 — churn risk*) | Gemini-scoped only; platform future uncertain | A [SV] | HIGH |
| 5 | Aider --yes/--auto-accept (https://aider.chat/docs/config/options.html) | CLI flags | Interactive confirm → full autonomy | Local OSS | Free OSS | Binary switch, no per-tool/path policy | B [SV] | MED |

## 2 · OS sandboxing / containers

| # | Product | Enforcement point | Autonomy / approval model | Local/cloud | Pricing + adoption | Key limitation | Gr | Threat |
|---|---------|-------------------|---------------------------|-------------|--------------------|----------------|----|--------|
| 6 | macOS Seatbelt / sandbox-exec (https://alejandromp.com/development/blog/sandboxing-an-ai-harness-on-macos/) | OS kernel MAC; inherited by children | Silent enforcement, no prompts; full autonomy inside | Local macOS | Built-in free (deprecated yet ubiquitous) | Hand-written SBPL brittle; default-allow footgun; no semantic awareness | B [SV] | MED |
| 7 | Linux bubblewrap (https://github.com/containers/bubblewrap) | Kernel namespaces/seccomp; Claude's Linux sandbox backend | Same silent-enforcement shape | Local Linux | Free OSS (Flatpak engine) | Linux-only; all-or-nothing fs/net view; raw CLI UX | B [SV] | MED |
| 8 | Docker Sandboxes (https://docs.docker.com/ai/sandboxes/) | MicroVM + filtered network proxy | Agent free inside; no per-action prompts by design | Local Desktop + cloud story | Docker product; pricing *unverified* | Heavyweight; no semantic scope rules; sync friction | A [SV] | MED |
| 9 | Dev containers + firewall (https://code.claude.com/docs/en/devcontainer) | Container namespaces + firewall; creds kept outside | YOLO inside, human gates at host boundary | Local Docker, open spec | Free; Anthropic-documented folk pattern | Shared host kernel; per-repo setup burden; manual trust boundary | B [SV] | MED |
| 10 | Apple Containerization (https://github.com/apple/containerization) | VM-per-container | Infrastructure, no approval model | Local macOS | Free OSS, fast-moving 2025–26 | No agent policy layer; immature ecosystem | B [SV] | LOW |

## 3 · MCP authorization / security

| # | Product | Enforcement point | Autonomy / approval model | Local/cloud | Pricing + adoption | Key limitation | Gr | Threat |
|---|---------|-------------------|---------------------------|-------------|--------------------|----------------|----|--------|
| 11 | MCP Authorization spec OAuth 2.1 (https://modelcontextprotocol.io/specification/2025-11-25/basic/authorization) | Token validation at MCP server (identity) | None at action level — *who*, not *whether safe* | Spec, both | Free standard | Solves identity, not least-privilege or injection; stdio largely outside | A [SV] | LOW |
| 12 | Docker MCP Toolkit + Gateway (https://docs.docker.com/ai/mcp-catalog-and-toolkit/) | Gateway choke point: servers exposed, secrets | Admin-curated allowlist | Local + registry cloud | Ships w/ Docker; pricing *unverified* | Curation ≠ runtime tool-call policy | A [SV] | MED |
| 13 | ToolHive / Stacklok (https://docs.stacklok.com/toolhive/) | Container per server + gateway policy + OIDC | Policy-gated autonomy; K8s Operator for teams | Local + K8s; Enterprise paid | OSS free; Ent. adds IdP/governance | MCP-scope only (not shell/edit); heavy for solo devs | A [SV] | HIGH@MCP / MED overall |
| 14 | Invariant Gateway + Guardrails (https://github.com/invariantlabs-ai/invariant) | Proxy intercepts tool calls pre/post; cross-tool sequence rules + poisoning scanner | Autonomous until rule fires | Self-hostable proxy + playground | OSS; managed pricing *unverified* | Detector false ±; rule-authoring burden; coding-agent shell scope unclear | B [SV] | HIGH |
| 15 | MCP-Shield (https://github.com/riseandignite/mcp-shield) | None at runtime — point-in-time audit | N/A (advisory) | Local CLI | Free OSS, small project | Scan-once vs rug-pull drift; no enforcement | B [SV] | LOW |

## 4 · Agent gateways & AI security platforms (tool/action vs prompt-only noted)

| # | Product | Enforcement point | Relevance to Exousia | Gr | Threat |
|---|---------|-------------------|----------------------|----|--------|
| 16 | Portkey AI Gateway (https://docs.portkey.ai/docs/product/ai-gateway) | Prompt/filtering + spend, 40+ guardrails | No shell/MCP tool-call gate. P- Alto acquisition intent 2026 = consolidation | A [SV] | LOW |
| 17 | LiteLLM Proxy (https://docs.litellm.ai/docs/proxy/guardrails/quick_start) | Prompt/filtering + budget, virtual keys | Same: no per-tool boundary | A [SV] | LOW |
| 18 | Lakera Guard (https://docs.lakera.ai/guard) | Prompt-injection/jailbreak screening | Filter only; detector arms race; per-call latency/cost | B [SV] | LOW |
| 19 | SplxAI → Zscaler (https://splx.ai/) | Assessment + enterprise platform controls | Audit-first, not inline autonomy-preserving boundary | C [SV] | LOW |
| 20 | Confident AI (https://www.confident-ai.com/) | Pre-ship eval/red-team/observability | Ships-safer vs acts-safer; no local tool boundary | C [SV] | LOW |

## 5 · Policy engines applied to agents

| # | Product | Enforcement point | Autonomy / approval model | Note | Gr | Threat |
|---|---------|-------------------|---------------------------|------|----|--------|
| 21 | OPA + Rego (https://openpolicyagent.org/) | Wherever you embed the decision point (DIY) | Whatever you build | CNCF-graduated; you build interception, schema mapping, UX, audit; Rego curve | B [SV] | MED |
| 22 | Cedar + Bedrock AgentCore Policy (https://docs.cedarpolicy.com/) | Policy decision point in front of tool calls (when wired) | Permit/forbid; NL→Cedar authoring | Strongest policy-language substrate; DIY gap outside AWS; AWS-coupled managed path | B [SV] | MED |

## 6 · OSS permission/control wrappers

| # | Product | Enforcement point | Autonomy / approval model | Note | Gr | Threat |
|---|---------|-------------------|---------------------------|------|----|--------|
| 23 | StrongDM Leash (https://github.com/strongdm/leash) | Wrapped execution, hooks + sandboxing (Docker + macOS) | Policy-gated autonomy (details unverified) | Early-stage; agent-version drift risk | B [SV] | MED |
| 24 | obra/packnplay (https://github.com/obra/packnplay) | Container boundary | YOLO-inside-container | Isolation only, no semantic policy; single-maintainer class | B [SV] | LOW |

## Synthesis

- **Top 3 closest substitutes:** (1) OpenCode permissions — exact "autonomy with a boundary" shape,
  OSS/hackable; Exousia edge must be cross-harness portability + egress/data-awareness. (2) Claude
  Code permissions+hooks+sandbox — incumbent default, zero switching cost; interoperate, don't ask
  migration. (3) Invariant Guardrails — only other *sequence/context-aware* tool-call gating; if it
  adds first-class shell/edit scope it subsumes much of the wedge.
- **Gaps no incumbent covers well:** portable cross-harness policy; semantic/out-of-scope boundaries;
  risk-bucketed autonomy ergonomics (batch approval, deferred audit, per-task budgets); joined
  tool+network+secret boundary for solo devs; tamper-evident individual audit; least-privilege for
  local (stdio) MCP servers.
- **Verdict:** crowded at layers (filters, scanners, red-team, isolation — consolidating), **open at
  the wedge** iff Exousia is cross-harness, local-first, autonomy-preserving. Crowded if it is merely
  another prompt filter or container wrapper.

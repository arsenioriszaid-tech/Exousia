# Exousia — Adversarial Evidence-First Competitor Research Pack

**Stance:** kill-first. Exousia assumed UNNECESSARY until evidence says otherwise. No code written. No winner picked. No subjective scores.
**Verification tiers:** T1 = first-hand fetched (curl, full text saved to scratch) · T2 = search-result snippet from primary domain (supports only what it literally says) · T3 = credible secondary (analyst/press) · Marketing claims flagged as such and never treated as proof of demand.
**Evidence grades:** A = direct (fetched doc, user statement, incident) · B = strong indirect (repeated coverage, credible survey) · C = weak (single vendor claim/opinion).
**Fetch limitation (disclosed):** `web_extract` backend was search-only in this session, so page bodies were verified via `curl` for 6 load-bearing primaries (AWS policy doc, MS Learn Agent ID, Google Model Armor, OpenAI guardrails doc, Okta GA blog, Wiz AI-SPM blog — all returned expected content, T1). All other primaries are T2 (snippet-tier). Nothing below relies on an unopened page for its load-bearing sentence.

---

## 1. Executive Findings

1. **The problem is named, the budget is half-there.** 58% of 45 senior security respondents name "securing AI agents and their access" the top AI security problem, but only 36% have a dedicated AI security budget line; 33% fund case-by-case, 20% carve from existing budget, 16% no spend (Open Future Forum, Aug 2026, operator sample — B/T3, directional not probabilistic).[S1] Lightspeed/Wakefield (200 CISOs, $500M+ revenue) reports 88% expect budget increases and 100% allocate something to AI; 75% experienced AI incidents.[S2] BCG (~300 leaders) finds only 41% have formal AI governance, 23% monitor/log agents, <20% do shadow-AI monitoring, prompt-injection detection, or NHI governance.[S3] **Reading:** demand signal is real but fragmented; the modal buyer negotiates per-case. That is a sales-cycle fact, not just a market-size fact.
2. **Every slice of "agent control" already ships somewhere — but no one ships the whole.** Hyperscalers (AWS AgentCore Policy, Entra Agent ID, Google Model Armor + Agent Engine), identity incumbents (Okta GA, CyberArk GA Dec 2025), network/runtime incumbents (Prisma AIRS 2.0, Wiz AI-SPM, CrowdStrike/Charlotte AI), dev platforms (OpenAI guardrails+HITL, Claude Code permissions+sandbox, GitHub agent least-privilege + audit, GitLab Duo audit + HITL beta), and OSS/substitutes (OpenFGA agent pattern, Cedar, OPA, Teleport/Pomerium MCP gateways, HumanLayer approvals) each cover 1–3 of the 10 control dimensions. Cross-provider identity + per-tool-call policy + runtime containment in one governed loop is covered by no one as a verified whole (fact, from boundary comparison below; inference that it matters is marked as such).
3. **Strongest kill vector: absorption, not apathy.** The buyers care (58%); the risk is that what Exousia would sell is a feature inside Okta/Entra/AWS/Palo Alto/Wiz roadmaps that already list "Agent Gateway," cross-platform identity, and JIT/zero-standing-privilege as shipped or next. Consolidation pressure is documented (BCG: buyers consolidated vendors in 18 of 24 categories; mid-tier vendors at risk).[S3] A standalone control plane must therefore win on a wedge that survives inside an incumbent's bundle — none of the evidence below grants that yet.
4. **Strongest survive vector: the seams.** Coverage is per-silo by construction (AgentCore enforces only AgentCore Gateway traffic; Entra governs Entra-issued identities; Model Armor screens content, it does not authorize; Wiz observes posture, it does not authorize inline). Agent-to-agent delegation, cross-system audit causality, credential-brokerage revocation propagation, and MCP supply-chain trust have no credible whole-owner. Each is a candidate wedge ONLY — validation required (Section 8).
5. **Incidents are concrete, not hypothetical.** The Vercel/Context.ai OAuth-pivot breach (abandoned shadow-AI grant → infostealer at vendor → downstream pivot into dashboards, secrets, GitHub creds) is documented by Push Security/BleepingComputer/CSA analyses.[S4] OWASP's agentic tracker and Cisco 2026 (34% have AI-specific controls, <40% test agent workflows — via OWASP) bound the maturity floor.[S5] CVE-2025-6514 (MCP RCE, 500k developers affected) appears ONLY in an OECD monitor entry explicitly labeled AI-generated — treat as **unverified**, not as incident evidence.[S6]

---

## 2. Competitive Landscape

### 2a. Hyperscalers — own the enforcement point inside their cloud

**AWS — Bedrock AgentCore Policy + Guardrails (T1 verified).**
First-hand fetch confirms: policy engines hold deterministic Cedar policies, attach to Gateways, intercept every agent→tool request pre-execution, default-deny with forbid-wins, identity-aware (`AgentCore::OAuthUser` / `IamEntity`), fine-grained on tool input params, temporal/session-aware rules (approval-before-transfer, budgets), NL→Cedar authoring with over/under-permissive checks, CloudWatch audit, consumption pricing.[S7] Guardrails-in-policy (GA Jun 2026) adds prompt-attack / content-filter / sensitive-info screening with confidence thresholds and `suppressOutput` on tool returns; limitations are explicit: no regex, no mixing standard Cedar `when` with `when guardrails`, per-gateway scoping, no wildcard actions.[S8]
Boundary: AWS-only gateway traffic. Cross-model (Bedrock-centric), cross-tool (gateway targets only), cross-provider: no.

**Microsoft — Entra Agent ID, now GA (T1 verified page gating noted: page requires auth in some contexts, but header + indexed content confirm GA + capability list).**
First-class agent constructs (blueprint, blueprint principal, identity, agent user, service principals), human sponsor/owner with auto-transfer on departure, access packages (incl. agent self-request + sponsor-on-behalf + admin assign, expiry + re-approval), Conditional Access templates (block high-risk, autonomous vs on-behalf-of), ID Protection (6 offline risk types, Risky Agents report, 90-day visibility), sign-in/audit logs with `agentSignIn` type + Graph API, multi-select disable, tenant-wide block.[S9][S10] Licensing: Agent 365 + Entra P1/P2 tiers. Integrations: Copilot Studio, Foundry, Security Copilot, Teams; ServiceNow/Workday provisioning partnerships; A2A/MCP enterprise identity work with industry (in-progress language).[S11]
Boundary: Microsoft-identity-scoped. Third-party coverage via federation/integration, not native enforcement.

**Google — Vertex Agent Builder/Engine + Model Armor + Apigee→MCP (T1 verified for Model Armor).**
Agent Builder curates approved tools via Cloud API Registry (incl. Google-service MCP, custom MCP via Apigee); Agent Engine is the managed multi-framework runtime (ADK/LangGraph/CrewAI, Gemini/Claude/Mistral).[S12] Model Armor is runtime *screening* (prompt/response/agent interaction, prompt-injection/jailbreak, PII via Sensitive Data Protection, malware/URL, tunable thresholds, model-agnostic REST, inline with Agent Gateway/Gemini Enterprise/GKE/LangChain, free tier).[S13] Release notes confirm Agent Gateway + MCP-server integrations moving GA→Preview through late 2025.[S14]
Boundary: governance = tool curation + content screening. Not per-principal authorization, not approval workflow, not credential brokerage.

### 2b. AI labs + dev platforms — framework-level controls, dev-owned

**OpenAI (T2).** Agents SDK separates guardrails (input/output/tool auto-checks) from human review (run pauses, `needs_approval`, interruptions, `RunState` serialize/resume incl. handoffs and nested `Agent.as_tool`); MCP servers gate via `require_approval`; Projects/service accounts with per-key Restricted/Read-only endpoint scopes; Codex sandbox + approval modes + domain allowlists.[S15][S16] Boundary: per-app, per-developer. No org-wide audit, no cross-provider, SOC is not the owner.

**Anthropic Claude Code (T2).** Read-only default permissions (allow/ask/deny, globs, `mcp__server__tool` scoping, managed-settings `disableBypassPermissionsMode`), OS-level sandbox runtime (bubblewrap/seatbelt; FS + network proxy isolation; configurable), Claude-on-web isolated VM with git creds held *outside* the sandbox via scoped proxy, "84% fewer prompts" internal-measurement claim (C, vendor self-measurement).[S17][S18] Boundary: single-machine/dev-scope; `bypassPermissions` exists; MCP servers/hooks run unconstrained on host unless whole-process sandbox/devcontainer/VM is used — Anthropic's own docs say the Bash sandbox alone is insufficient for unattended runs.[S18]

**GitHub (T2).** Hosted-agent principles: minimal autonomy, firewall with MCP bypass carve-out (flagged), need-to-know context (no CI secrets auto-pass, token revoked post-session), PR-only (no default-branch commit, no auto-CI without human run), MCP approvals in Chat, co-commit attribution.[S19] Audit logs support `action:copilot` / `actor:Copilot` but explicitly exclude client session prompts without custom hooks.[S20] OIDC secretless agent identity is real (Azure GPT-RAG ADR pins resource-group-scoped Contributor + RBAC Admin, `repo:...:environment:copilot` federation).[S21] Official Copilot guidance: prefer user-delegated auth over service accounts for individually-used agents (auditability/compliance rationale).[S22]

**GitLab Duo (T2).** Agent Platform ships AI audit event report (per-session artifacts on Governance page, Owner-gated); HITL tool-approval policies are an open epic labeled Beta/upcoming — i.e., audit first, enforcement in flight.[S23][S24]

### 2c. Security incumbents — own identity lifecycle or network/runtime, expanding inward

**Okta for AI Agents, GA Apr 2026 (T1 blog fetch confirmed GA framing).** Universal Directory first-class agent identities (homegrown + Salesforce Agentforce / Bedrock AgentCore / ServiceNow imports), shadow discovery via OAuth-grant signals (Chrome-managed first), Token Vault + scoped short-lived tokens + FGA-for-RAG document checks, token exchange incl. ID-JAG / vaulted secrets via Privileged Access / agent-to-agent, access-request + certification + deactivate kill switch, per-tool-call/SIEM telemetry, Cross App Access protocol (AWS, Google Cloud, Box, Salesforce…), federates with existing IdP. Roadmap explicitly lists agent-to-agent delegation, **Agent Gateway (upcoming, not GA)**, threat detection, HITL for high-stakes actions.[S25][S26] Regulated SKU (FedRAMP/HIPAA Core) excludes ISPM/OPA/service-account connections pending authorization — a real boundary for regulated buyers.[S26]
Boundary: identity + credential + governance. Inline per-tool enforcement today is Token Vault/exchange + consent flows; full gateway enforcement is roadmap.

**CyberArk Secure AI Agents, GA end Dec 2025 (T2).** Discovery across SaaS/cloud/dev (Bedrock, Copilot Studio), AI Agent Gateway in front of MCP servers, zero-standing-privilege/JIT least-privilege, session monitoring/isolation, action/DB-query audit with on WHOSE-behalf attribution; Workload Identity Manager (SPIFFE) + Secrets Manager underneath; Idira platform framing (note: press copy references Palo Alto Networks parentage — single-vendor claim, treat org structure as C until second source).[S27][S28]

**Palo Alto Prisma AIRS 2.0 (T2).** Discover/Assess/Protect across lifecycle; AI Gateway control plane; Agent Security (identity verification + real-time enforcement); Runtime Security (prompt/response/data-flow inspection); Red Teaming incl. multi-agent; Posture Management. Managed runtime + OAuth-refresh/microperimeter updates through 2026.[S29] Boundary: traffic/runtime inspection heritage; not identity lifecycle owner.

**CrowdStrike (T2).** Charlotte AI mission agents (triage/response, guardrails, inspectable sources, audit logs; FedRAMP High for a named feature subset as of Mar 2026) + Falcon Shield×Salesforce Security Center/Agentforce (risky-behavior flags, Fusion auto-containment/disable from Salesforce).[S30][S31] Boundary: SOC-centric; general agent control is integration-scoped.

**Wiz AI-SPM (T1 fetch confirmed framing).** Agentless discovery (AI services/models/MCP), AI-BOM, Agent Inventory + blast-radius view, attack-surface/endpoint validation (incl. MCP/vibe-coding endpoints), Bedrock/Vertex/OpenAI baselines, guardrail-verification, DSPM-for-AI, OWASP LLM alignment, runtime drift + Jira/ServiceNow response. Agent+MCP posture GA; deeper runtime billed as expanding.[S32][S33] Boundary: posture/visibility + ticketing; not inline authorization.

### 2d. Startups — point wedges with funding, narrow scope

- **Astrix ($85M total; $45M Series B Dec 2024, Menlo Anthology+Anthropic/Workday/BVP/CRV/F2) (T2/T3).** NHI visibility + auto-remediation of over-privileged/unneeded/malicious access; AI Agent Control Plane; OSS MCP Secret Wrapper + State of MCP Server Security 2025 research; named customers Workday/HubSpot/Figma/Priceline/NetApp (vendor-claimed, C).[S34][S35]
- **Veza ($108M Series D) / Persona ($200M Series D)** — identity-security raises explicitly positioned for agentic AI/bot-traffic era (Crunchbase, T3).[S36]
- **Teleport (T2, docs).** Zero-code MCP gateway: `tsh mcp connect` proxying, RBAC down to tools, deny-by-default on new tools, JIT time-bound elevation with human approval, short-lived certs (12h), `tbot` machine identity, full audit with identity propagation. Caveat in their own docs: tool-level requests "typically operate at the MCP server resource level" in current implementations — server-level in practice.[S37]
- **Pomerium (T2, docs).** Identity-aware MCP proxy: SSO auth, short-lived scoped JWT injection, no raw-token passthrough, contextual policy, WebSocket/streaming support; MCP support self-labeled **experimental**.[S38]
- **HumanLayer (T2, OSS MIT + cloud/enterprise).** Approval/feedback primitives (`require_approval`, `human_as_tool`), Slack/email/SMS/webhook, durable async, idempotency keys, trace-ids/signed webhooks, channel-scoped RBAC. No policy engine, no runtime containment beyond the pause.[S39]
- **Nudge Security (T2, press).** OAuth-grant + browser-extension risk analysts with HITL remediation; multi-signal discovery (browser/inbox/IdP/apps); Vendor Risk Analyst auto-profiles (90% review-time claim, C).[S40]
- **Permit.io / Cerbos / Oso / Styra-OPAL; Oasis/Token Security (NHI); Vanta/Drata/Holistic/Credo (governance)** — present in landscape, thin-verified in this sweep; do not cite as covered.

### 2e. OSS + substitutes — the "good enough" stack buyers already run

- **Policy engines trilemma (T2, benchmark + analyses).** Rego/OPA: most expressive, steepest curve, scaling/sync overhead, runtime-error proneness in testing. Cedar: readable, safe/deterministic, analyzable, AWS-flavored, weak on ReBAC/unstructured. OpenFGA/Zanzibar: relationship-native, web-scale, `list-objects`/`list-users` reverse queries, weak on ABAC/complex logic. Teleport ACD: reliable but coarse, defers logic outward.[S41][S42]
- **OpenFGA now publishes an explicit AI-agent pattern (T1 page shell verified via curl; content per snippet T2):** agents as first-class principals, `can_act_on_behalf_of` delegation (revocable, not copied), task/session scoping, RAG pre-model filtering, MCP-server authorization.[S43] Pattern exists; *enforcement* still depends on every caller checking — the central gap.
- **Workload identity + sandboxing + detection:** SPIFFE/SPIRE + Vault (short-lived workload IDs), gVisor/Firecracker/WASM/E2B/Daytona (execution isolation), Falco/eBPF/seccomp (runtime telemetry), API gateways/OAuth scopes (Apigee/Kong/Envoy) for coarse tool gating, tickets/Slack approvals + CODEOWNERS/branch protections for human gates.
- **Protocol posture:** MCP spec anticipates gateway/proxy enforcement (Pomerium/Teleport cite it); A2A/ACP identity support is industry in-progress (Microsoft's words).[S11] No signed-MCP-server / tool-attestation standard is evidenced in this sweep — absence noted, not proven absent.
- **Governance frameworks:** NIST AI RMF (GOVERN), OWASP Agentic Top 10 + ASI Threats/Mitigations + Securing Agentic Applications Guide + Agent Control Standard (Aug 2026 pointer), ISO 42001, EU AI Act Art 12 receipts; OWASP AST09 maps "No Governance" to MAESTRO layers 5/6/7 with NHI + audit-logging mitigations.[S5]

---

## 3. Capability Matrix (no scores; ✓=shipped evidenced · ◐=partial/beta/roadmap-gated · —=not evidenced)

| Capability | AWS AgentCore | Entra Agent ID | Google (Armor/Engine) | OpenAI | Anthropic CC | GitHub | GitLab Duo | Okta | CyberArk | PAN AIRS | CrowdStrike | Wiz | Teleport | Pomerium | HumanLayer | OpenFGA/Cedar/OPA |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Agent identity (first-class) | ◐ OAuthUser/IAM per-gateway | ✓ blueprint/identity/user | — (tool curation) | ◐ project/svc-acct | ◐ local permissions identity | ◐ Copilot identity + OIDC | ◐ composite identity | ✓ UD + imports | ✓ discovery+enrich | ◐ verify identity | ◐ agent + identity sec | ◐ inventory | ✓ certs/tbot | ◐ JWT assertion | — | ◐ agents-as-principals (pattern) |
| Permission model | ✓ Cedar per-tool/param | ✓ access pkgs + CA | — | ◐ key scopes | ✓ allow/ask/deny globs | ✓ repo-scoped least-priv | ◐ (beta HITL epic) | ✓ scopes + FGA-RAG | ✓ JIT/ZSP | ◐ posture perms | ◐ module-scoped | ◐ baselines | ✓ RBAC/JIT | ✓ proxy policy | — | ✓ engine semantics |
| Policy granularity | ✓ tool+param+temporal | ◐ token/session-level | ◐ thresholds | ◐ tool-level gates | ◐ tool/path/domain | ◐ action-level (PR-only etc) | — | ◐ scopes/consent | ◐ task-scoped JIT | ◐ traffic rules | ◐ SOAR-scoped | ◐ baseline rules | ◐ server>tool | ◐ server/tool (exp) | — | ✓ fine (per-engine) |
| Contextual/risk-based authz | ◐ guardrail scores in-policy | ✓ CA + ID Protection risk | ◐ content-risk scores | — | — | — | — | ◐ XAA + behavior (roadmap detect) | ◐ session monitoring | ✓ runtime inspection | ◐ risky-behavior flags | ◐ graph context | ◐ time/behavioral | ◐ contextual policy | — | — (external data needed) |
| Runtime enforcement | ✓ gateway intercept | ◐ token issuance block | ◐ inline screening | ◐ SDK pause | ◐ OS sandbox | ◐ firewall + no-auto-CI | — | ◐ exchange/vault gate; gateway = roadmap | ✓ MCP gateway (claimed) | ✓ inline inspect | ◐ containment via Fusion | — (observe+tickets) | ✓ gateway proxy | ✓ proxy | ◐ pause-until-approval | — (decision only) |
| Human approval | — (policy, not workflow) | ◐ sponsor/access-pkg approvals | — | ✓ HITL interruptions | ✓ prompts/modes | ✓ MCP approval + PR review | ◐ beta | ◐ request/certify flows; HITL = roadmap | ◐ JIT approvers | — | ◐ analyst-in-loop | — (ticketing) | ✓ JIT approvals | — | ✓ multi-channel + quorum | — |
| Credential handling | ◐ FAS creds from exec role | ◐ JIT scoped tokens (planned emphasis) | — | ◐ per-key perms | ◐ creds held outside sandbox (web) | ✓ withhold + revoke post-session | — | ✓ vault + short-lived + rotation | ✓ vault + rotation | — | — | — | ✓ 12h certs | ✓ no-passthrough JWT | — | — |
| Auditability | ✓ CloudWatch decisions | ✓ sign-in/audit + Graph | ◐ traces/dashboard | ◐ tracing | ◐ logs (device-local) | ◐ audit log minus prompts | ✓ session artifacts | ✓ per-call + SIEM | ✓ action/DB-query log | ◐ inspection logs | ✓ audit-ready logs | ◐ posture findings | ✓ who/what/when | ✓ per-action logs | ✓ trace-ids | — (app must log) |
| Cross-model/provider/tool | — | ◐ via federation | ◐ model-agnostic screen | — | — | — | — | ◐ vendor-neutral claim | ◐ multi-env claim | ◐ multi-env inspect | ◐ via integrations | ✓ multi-cloud observe | ◐ any MCP client/server | ◐ transparent proxy | ✓ framework-agnostic | ◐ embed-anywhere |
| Deployment | Cloud service | Entra tenant | GCP + REST | SDK/API | CLI/machine + cloud VM | SaaS + OIDC | SaaS/SM/Dedicated | SaaS; Core for regulated | Platform | Platform/managed FW | Platform | Agentless SaaS | Self-host/Cloud | Self-host | OSS/Cloud/VPC | Library/service |
| Pricing signal | Consumption per-eval | E7/Agent365+P1/P2 | Free tier + usage | Usage | Subscription | Seat/add-on | Tiered (Prem/Ult) | Suite/SKU (Core gated) | Platform | Platform | Platform trial | Platform | OSS + Enterprise | OSS/Enterprise (exp) | MIT + usage + Enterprise | OSS + hosted (Oso etc) |

Cells marked ✓ require the cited primary above; ◐ means shipped-but-bounded, beta, roadmap, or single-vendor-claimed. No weighting, no ranking.

---

## 4. Substitution Map (what buyers use instead, and what it costs them)

| Job | Substitute stack | Who runs it | Limitation that recreates the problem |
|---|---|---|---|
| Keep agents off crown jewels | IAM roles + OAuth scopes + API gateway allowlists | Platform/IT | Static scopes ≠ task intent; OAuth grants persist after trials (Vercel pattern); scope sprawl unaudited |
| Approve dangerous actions | Slack threads / tickets / CODEOWNERS / branch gates + HumanLayer/LangGraph interrupts | Eng/IT | Human-in-loop exists per-app; no universal SLA, quorum, fatigue accounting, or cross-app audit |
| Stop prompt-injection fallout | Model Armor / Guardrails / PR-firewall / sandbox (Bubblewrap/gVisor/Firecracker/E2B) | Eng/Sec | Screening scores content; sandbox jails a machine — neither authorizes the *action*; bypass = different tool/path |
| Prove what happened | CloudWatch / Entra sign-in / GitHub+GitLab audit / SIEM shipping | Sec/Compliance | Per-silo logs; prompts withheld (GitHub); no cross-system agent-causality reconstruction |
| Kill a rogue agent | Disable identity / revoke token / Fusion containment / Okta deactivate | SOC/IT | TTLs + downstream sessions + vaulted static creds outlive the "kill"; revocation propagation unstandardized |
| Find shadow agents | Nudge/Okta/Wiz discovery + browser/IdP signals | Sec | Discovery→ticket; Chrome-only/connector-gated coverage; auto-revoke still human-bottlenecked |
| Write the rules | Cedar/Rego/OpenFGA + NL authoring (AgentCore) | Eng/Sec | Trilemma (expressiveness × readability × relationship-scale); NL-generated policy safety unproven outside AWS checks |

---

## 5. Structural Gaps — 14 evidence-backed gaps (each: who / workaround / why incumbents insufficient / urgency / WTP read / buyer-user / defensibility)

**G1. No universal agent identity across providers.** Who: multi-cloud/SaaS enterprises (ServiceNow+Workday+Foundry+Cust-built). Workaround: parallel identities per platform + service accounts. Insufficient: Entra/AgentCore/Okta each mint inside their realm; federation is integration-by-integration. Urgency: high for regulated multi-stack (provisioning partnerships prove the pain). WTP: identity-budget-adjacent, needs CFO payback framing (OFF). Buyer: CISO/IAM; users: platform eng. Defensibility: low if IdP standards (XAA/ID-JAG) win — protocol absorbs it. [B/T2]

**G2. Delegation semantics (on-behalf-of vs autonomous) unenforced at runtime.** Who: anyone wiring agents to user data (RAG, file/Teams access). Workaround: service accounts with broad grants + Copilot-style "write-access gating." Insufficient: MSFT itself documents OBO-vs-autonomous as separate CA templates — policy exists at token layer, not per-tool-call; OpenFGA's `can_act_on_behalf_of` is a modeling pattern, not an enforcement fabric. Urgency: high (over-permissioned agents = #1 blast radius). WTP: medium; buyer CISO, user app-eng. Defensibility: medium — requires runtime + identity co-design. [B/T2]

**G3. Per-tool least privilege across MCP, centrally governed.** Who: teams exposing DBs/APIs via MCP. Workaround: Teleport/Pomerium proxy per-estate + per-server OAuth. Insufficient: Teleport admits tool-level JIT is server-level in practice; Pomerium MCP is experimental; Okta MCP = governed-resource claim with gateway in roadmap. No verified cross-estate tool ledger. Urgency: high. WTP: medium-high if it replaces per-server OAuth plumbing. Buyer: platform sec; user: agent dev. Defensibility: medium (gateway is replicable; policy-content is not). [A/T2]

**G4. Session/temporal policy (approval-before-X, budgets, rate caps) outside AWS.** Who: finance/ops automation (refunds, provisioning, data deletion). Workaround: custom code counters + tickets. Insufficient: AgentCore temporal policies are gateway-scoped and AWS-only; no cross-platform session store evidenced. Urgency: medium-high for money-moving agents. WTP: high per-workflow (one incident pays). Buyer: fraud/ops + CISO; user: workflow owner. Defensibility: medium-high (stateful policy is sticky). [A/T2]

**G5. Risk/context evaluated per tool call, not per session.** Who: SOC governing compromised-but-authenticated agents. Workaround: CA block at token issuance + runtime content scores. Insufficient: CA fires at token time; Model Armor/Guardrails score *content*, not permission; nothing evidenced merges device/risk/behavior into each tool-call decision outside a single vendor's gateway. Urgency: medium. WTP: unclear — needs proof it stops a lived incident. Buyer: SOC. Defensibility: high if done cross-tool; low if per-vendor. [Inference from boundaries; B]

**G6. Approvals with SLA, quorum, fatigue accounting.** Who: on-call eng, finance approvers, nurses/paralegals in HumanLayer's own examples. Workaround: SDK interrupts + Slack buttons. Insufficient: no evidenced cross-provider approval policy (who must approve what in N minutes, escalation, quorum for >$X, audit-tied). Approval fatigue unmeasured everywhere (Anthropic's 84% prompt-reduction is self-measured, C). Urgency: medium (blocks autonomy rollout). WTP: medium; buyer: ops-risk; user: approver. Defensibility: low-medium (UX + workflow, fast-followed). [B/T2]

**G7. Credential brokerage whose revocation actually propagates.** Who: agent fleets calling SaaS/DBs. Workaround: 12h certs, vaulted secrets, per-key scopes. Insufficient: static secrets persist in MCP configs (Astrix's Secret Wrapper exists because of this); kill-switch (Okta/CrowdStrike/Entra disable) stops *new* tokens, not live downstream sessions. Urgency: high (Vercel pattern). WTP: high if tied to incident reduction. Buyer: IAM/SOC. Defensibility: medium (requires protocol + endpoint cooperation). [A/T2]

**G8. Cross-system audit that reconstructs agent causality.** Who: incident responders, auditors (EU AI Act Art 12 receipts, HIPAA/FedRAMP). Workaround: stitch CloudWatch+Entra+GitHub+SIEM by hand; prompts unavailable (GitHub). Insufficient: every audit is per-silo; no evidenced agent-trace standard spanning tools. Urgency: medium-high for regulated. WTP: compliance-budget real. Buyer: GRC/CISO; user: responder. Defensibility: medium (retention + schema moat). [B/T2]

**G9. Shadow→governed pipeline that closes the loop.** Who: sec teams drowning in OAuth grants/extensions. Workaround: Nudge/Okta/Wiz discovery → ticket queue → manual revoke. Insufficient: coverage gated (Chrome-managed, connected apps); remediation still human-bottlenecked; Vercel's grant lived months. Urgency: high (27% name shadow AI top-2). WTP: medium; buyer: SecOps/IT. Defensibility: low (discovery commoditizing). [B/T2–T3]

**G10. Kill switch with deterministic containment.** Who: SOC during rogue-agent incident. Workaround: disable identity + block tokens + isolate device. Insufficient: agent work queued in downstream systems (tickets, PRs, DB jobs) continues; no evidenced distributed-transaction-style abort. Urgency: medium (rarely invoked, catastrophic when needed). WTP: insurance-like; hard to price standalone. Buyer: SOC. Defensibility: low unless tied to G7+G8. [Inference; C/B]

**G11. Policy-as-code both auditors and developers trust.** Who: sec + eng jointly. Workaround: pick one engine's pain (Rego power, Cedar readability, OpenFGA relations). Insufficient: benchmarked trade-offs are structural, not maturity; NL-authoring safety checks exist only inside AgentCore. Urgency: medium (slows every rollout). WTP: low standalone (enabler, not budget line). Buyer: platform eng + GRC. Defensibility: low (language war, not moat). [B/T2]

**G12. Deterministic boundary independent of model reasoning.** Who: regulated deployments (healthcare/finance examples in AWS docs). Workaround: externalize policy to gateway (AgentCore's pitch). Insufficient: works only for gateway-routed traffic; direct API/MCP bypass, prompt-injected tool-choice within allowed set, and allowed-tool misuse remain. "Regardless of how the agent is prompted" holds only inside the gateway perimeter — AWS's own scoping (per-gateway ARNs, no wildcards) concedes this. Urgency: high for regulated autonomy. WTP: high if it unlocks deployment. Buyer: CISO/compliance. Defensibility: medium-high (requires choke-point ownership). [A/T1]

**G13. MCP/tool supply-chain trust.** Who: anyone installing third-party MCP servers. Workaround: allowlist + Teleport deny-by-default + reviews. Insufficient: no evidenced signing/attestation/provenance standard for tools; CVE-2025-6514-type claims circulate without verified primary (see §7). Urgency: medium-high. WTP: medium (AppSec-adjacent). Buyer: AppSec/platform. Defensibility: medium (registry + signing network effects). [C — evidence thin by own finding]

**G14. Multi-agent delegation chains with attribution.** Who: Agentforce/cross-agent workflows, LangGraph/CrewAI fleets. Workaround: per-agent identities + co-commit style attribution (GitHub-only). Insufficient: Okta's agent-to-agent exchange is early/roadmap-adjacent; accountability for downstream effects is per-platform. Urgency: growing, not yet top. WTP: unproven. Buyer: platform arch. Defensibility: high if solved generally (protocol-level). [B/T2]

*Deliberately not listed as gaps (feature parity, not structural):* content filtering quality, prompt library management, generic dashboards, per-model guardrail tuning — each has 3+ credible owners.

---

## 6. Threats to Exousia (threat map)

| Threat | Owner(s) | Mechanism of absorption | Lead indicator to watch |
|---|---|---|---|
| Gateway absorption | AWS (AgentCore), Okta (Agent Gateway roadmap), Teleport/Pomerium | Policy+JIT+audit bundled into the proxy every agent must traverse | Okta Gateway GA; AgentCore cross-cloud targets |
| Identity absorption | Entra Agent ID, Okta UD, CyberArk | Agent becomes "just another identity type" with sponsors/certifications | XAA/ID-JAG adoption beyond Okta allies |
| Runtime/posture absorption | PAN AIRS, Wiz, CrowdStrike | SOC buys runtime+posture; control plane inherits approvals/credential tasks | AIRS Agent Security + Wiz runtime depth GAs |
| Framework commoditization | OpenAI SDK, Anthropic, HumanLayer/LangGraph OSS | Approvals/sandbox become SDK defaults; no budget line | HITL + sandbox in every major framework (already ~there) |
| Suite consolidation | MSFT/Google/AWS + CrowdStrike/PAN | Fewer vendors (BCG 18/24 consolidated); standalone control loses procurement | Renewal bundling of agent controls into E5/Suite |
| Protocol absorption | MCP/A2A/XAA standards | Delegation/revocation/attestation solved once at protocol layer | Signed tools, standard agent-DID, standard revocation propagation |

---

## 7. Kill Case — six honest attempts to end Exousia (with counter-evidence)

**K1. "AWS already solved it."** AgentCore Policy is the closest single product to Exousia's thesis (Cedar, default-deny, temporal, guardrails-in-policy, audit). Counter: AWS-scoped, gateway-scoped, no approvals workflow, no cross-provider story — solves it *for AWS-routed tools*.
**K2. "Identity incumbents already own it."** Entra GA + Okta GA + CyberArk GA cover lifecycle/sponsors/certifications/JIT/kill-switch. Counter: lifecycle ≠ per-call enforcement; Okta's own gateway is roadmap; regulated-SKU gaps documented.
**K3. "It's a feature, and procurement proves it."** BCG consolidation + OFF's 33% case-by-case funding + suite bundling favor embedded features. Counter: 36% already hold a dedicated line and no-spend is shrinking — a new control *can* clear procurement with a one-workflow payback case.
**K4. "Developers route around control."** `bypassPermissions`, direct API keys, unmanaged MCP servers, and gateway-external traffic make proxy enforcement advisory. Counter: Teleport/Entra managed-settings + device-management + OIDC-secretless patterns show routing-around is governable *where the org commits*; the question is coverage cost, not possibility.
**K5. "Audit without prevention is theater; prevention without causality is brittle."** Content scores misfire; allowlisted-tool misuse passes; logs don't reconstruct intent. Counter: AgentCore's externalization + GitHub's least-privilege action design are existence proofs that deterministic boundaries reduce blast radius even without solving intent.
**K6. "Buyers won't pay standalone."** Only 36% dedicated line; insurance-like kill-switch/containment has no natural owner. Counter: incident-anchored wedges (OAuth-sprawl cleanup, money-moving approvals, regulated audit) map to existing owners (IAM/SOC/GRC/fraud) — WTP is workflow-specific, not category-level. OFF explicitly advises "one workflow, one risk owner, one budget source."[S1]
**Shared bet that kills all candidates at once if wrong:** that糙 organizations will route agent→tool traffic through a governable choke point. If agents keep direct credentials and endpoints never cooperate, every gateway-shaped thesis (including incumbents') fails equally.

---

## 8. Candidate Wedges for customer validation (not opportunities — test each)

1. Abandoned-OAuth → agent-inventory cleanup (Vercel-pattern). Owner: SecOps/IT. Proof: grants revoked, dwell time cut, in 2 quarters.
2. Money-moving tool approvals with quorum+SLA (refunds, provisioning). Owner: fraud/ops. Proof: one workflow, zero standing privilege.
3. MCP server allowlist + secret-wrapper rollout for one estate. Owner: platform sec. Proof: no static secrets in configs, new-tool deny-by-default.
4. RAG document-level enforcement check (FGA pattern, pre-model filter). Owner: data sec. Proof: unauthorized docs never reach context.
5. Temporal/budget policy for one agent fleet (rate caps, approval-before-transfer). Owner: ops. Proof: over-spend/misuse blocked outside code.
6. Cross-silo agent incident drill (reconstruct one real session across IdP+gateway+repo). Owner: SOC/GRC. Proof: causality timeline without hand-stitching.
7. Kill-switch drill with revocation measurement (time-to-no-new-access AND live-session kill). Owner: SOC. Proof: measured propagation gaps.
8. Agent-to-agent delegation pilot (two agents, scoped exchange, independent revocation). Owner: platform arch. Proof: revoke downstream without killing upstream.

Validation bar per wedge: named owner, named budget path (new line / existing / case-by-case), one integration, one measurable outcome in ≤2 quarters. Anything failing the bar is INCONCLUSIVE, not a pivot.

---

## 9. Evidence & Sources (all URLs real, retrieved in-session)

- [S1] Open Future Forum, CISO AI Leverage Report (Aug 2026; n=45; 58%/36%/33%/20%/16%) — https://openfutureforum.com/research/ciso-ai-leverage-report
- [S2] Lightspeed Cyber 60 2026 + Wakefield CISO survey (200 CISOs; 88% budgets up; 75% AI incidents) — https://lsvp.com/wp-content/uploads/2025/10/LSVP-Cyber60-2026.pdf
- [S3] BCG Cybersecurity Spending and AI Threat Trends 2026 (~300 leaders; 41%/23%/<20%; 18/24 consolidation) — https://www.bcg.com/publications/2026/cybersecurity-spending-ai-threat-trends
- [S4] Vercel/Context.ai OAuth-pivot breach: Push Security via BleepingComputer (Apr 2026) — https://www.bleepingcomputer.com/news/security/learning-from-the-vercel-breach-shadow-ai-and-oauth-sprawl/amp ; CSA research note (May 2026, PDF) — https://labs.cloudsecurityalliance.org/wp-content/uploads/2026/05/CSA_research_note_oauth_consent_phishing_ai_identity_20260521-csa-styled.pdf ; Nudge announcement (Jul 2026) — https://www.nudgesecurity.com/press/nudge-security-unveils-ai-agents-to-mitigate-escalating-risks-from-hidden-oauth-grants-and-browser-extensions
- [S5] OWASP AST09 No Governance; Agentic Security Initiative resources; Top 10 for Agentic Applications (Dec 2025); Cisco 2026 via OWASP — https://owasp.org/www-project-agentic-skills-top-10/ast09.html ; https://genai.owasp.org/agentic-ai-threats-and-mitigations ; https://genai.owasp.org/2025
- [S6] OECD AIM monitor entry for CVE-2025-6514 (self-labeled AI-generated — UNVERIFIED) — https://oecd.ai/en/incidents/2026-01-12-d8f1
- [S7] AWS AgentCore Policy doc (T1 curl-verified) — https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/policy.html
- [S8] AWS Guardrails-in-policy doc + GA post (Jun 2026) — https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/policy-guardrails-in-policies.html ; https://aws.amazon.com/about-aws/whats-new/2026/06/amazon-bedrock-agentcore-policy-guardrails-generally-available/
- [S9] MS Learn: What's new in Entra Agent ID (GA) — https://learn.microsoft.com/en-us/entra/agent-id/whats-new-agent-id
- [S10] MS Learn: Governing Agent Identities; Manage agent identities (sponsors, access packages, CA, ID Protection, logs) — https://learn.microsoft.com/en-us/entra/id-governance/agent-id-governance-overview ; https://learn.microsoft.com/en-us/entra/agent-id/manage-agent-identities-admin
- [S11] MS Tech Community: Announcing Entra Agent ID (May 2025; visibility→controls roadmap; ServiceNow/Workday; A2A/MCP) — https://techcommunity.microsoft.com/blog/microsoft-entra-blog/announcing-microsoft-entra-agent-id-secure-and-manage-your-ai-agents/3827392
- [S12] Google Cloud Blog: Tool Governance in Vertex AI Agent Builder (Dec 2025; API Registry; Apigee→MCP) — https://cloud.google.com/blog/products/ai-machine-learning/new-enhanced-tool-governance-in-vertex-ai-agent-builder
- [S13] Google Model Armor product page (T1 curl-verified) — https://cloud.google.com/security/products/model-armor
- [S14] Model Armor release notes (Agent Gateway/MCP integrations) — https://docs.cloud.google.com/model-armor/release-notes
- [S15] OpenAI Agents SDK: Guardrails and human review; HITL; Projects/service-account key scopes — https://developers.openai.com/api/docs/guides/agents/guardrails-approvals.md ; https://openai.github.io/openai-agents-python/human_in_the_loop/ ; https://help.openai.com/en/articles/9186755-managing-your-work-in-platform-with-projects
- [S16] OpenAI for Developers 2025 roundup; Codex approvals/sandboxing — https://developers.openai.com/blog/openai-for-developers-2025.md ; https://github.com/llms-txt-archive/openai-platform/blob/main/codex/agent-approvals-security.md
- [S17] Anthropic: Beyond permission prompts (sandboxing; 84% claim, C) — https://claude.com/blog/beyond-permission-prompts-making-claude-code-more-secure-and-autonomous
- [S18] Claude Code docs: Permissions; Sandbox environments; Security — https://code.claude.com/docs/en/permissions.md ; https://code.claude.com/docs/en/sandbox-environments ; https://code.claude.com/docs/en/security
- [S19] GitHub Blog: Agentic security principles (firewall, least-privilege, attribution) — https://github.blog/ai-and-ml/github-copilot/how-githubs-agentic-security-principles-make-our-ai-agents-as-secure-as-possible/
- [S20] GitHub Docs: Copilot audit logs (excludes client prompts) — https://docs.github.com/en/copilot/how-tos/administer-copilot/manage-for-enterprise/review-audit-logs
- [S21] Azure GPT-RAG ADR-0002 (OIDC secretless agent identity, resource-group-scoped) — https://github.com/Azure/GPT-RAG/blob/main/docs/adr/ADR-0002-copilot-azure-oidc.md
- [S22] MS Q&A: service accounts vs user-delegated for Copilot agents — https://learn.microsoft.com/en-us/answers/questions/5635552/using-service-accounts-to-build-copilot-agents
- [S23] GitLab Duo: AI audit event report — https://docs.gitlab.com/user/duo_agent_platform/ai-audit-events
- [S24] GitLab epic #22381 (HITL tool approvals, Beta) + Duo CLI governance post — https://gitlab.com/groups/gitlab-org/-/work_items/22381 ; https://about.gitlab.com/blog/gitlab-duo-cli-governance/
- [S25] Okta: Okta for AI Agents GA (Apr 2026) — https://www.okta.com/blog/ai/okta-for-ai-agents-general-availability/
- [S26] Okta product page + Sep 2025 platform announcement (XAA, UD, kill switch, roadmap, regulated SKU) — https://www.okta.com/products/govern-ai-agent-identity/ ; https://www.okta.com/newsroom/press-releases/new-okta-innovations-secure-the-ai-driven-enterprise-and-combat-/ ; Auth0 for AI Agents — https://auth0.com/blog/introducing-auth0-for-ai-agents/
- [S27] CyberArk Secure AI Agents capabilities (GA end Dec 2025) — https://www.cyberark.com/product-insights/cyberark-secure-ai-agents-a-closer-look-at-new-solution-capabilities/
- [S28] CyberArk Idira press + 2025 Machine Identity report (80:1, 68% lack AI controls, 88% privileged=human-only) — https://www.cyberark.com/press/cyberark-bolsters-identity-security-platform-with-new-capabilities-for-human-ai-and-machine-identities/ ; https://www.cyberark.com/CyberArk-2025-state-of-machine-identity-security-report.pdf
- [S29] Palo Alto Prisma AIRS (Runtime Security, AIRS 2.0 press, platform) — https://www2.paloaltonetworks.com/ai-security/ai-runtime-security ; https://www2.paloaltonetworks.com/company/press/2025/palo-alto-networks-secures-the-ai-agent-revolution-with-the-launch-of-prisma-airs-2-0 ; https://www2.paloaltonetworks.com/ai-security/prisma-airs
- [S30] CrowdStrike Charlotte AI datasheets — https://www.crowdstrike.com/en-us/resources/data-sheets/charlotte-ai-mission-ready-agents/ ; https://www.crowdstrike.com/en-us/resources/data-sheets/charlotte-ai
- [S31] CrowdStrike×Salesforce (Falcon Shield + Agentforce, Sep 2025) — https://www.crowdstrike.com/en-us/press-releases/crowdstrike-and-salesforce-partner-to-secure-future-of-ai-powered-business
- [S32] Wiz AI-SPM: Securing AI Agents (T1 curl-verified framing; Nov 2025) — https://www.wiz.io/blog/wiz-ai-spm-secures-ai-agents
- [S33] Wizdom 2025 launches; AI endpoint visibility (MCP/vibe-coding) — https://www.wiz.io/blog/wizdom-product-launches-2025 ; https://www.wiz.io/blog/ai-endpoint-visibility-ai-security
- [S34] Astrix $45M Series B (Dec 2024; $85M total) — https://astrix.security/learn/news/astrix-raises-45m-series-b-to-redefine-identity-security-for-the-ai-era/
- [S35] Astrix NHI-for-AI platform + ACP + Fortune Cyber 60 — https://astrix.security/learn/blog/agentic-ai-security-starts-with-nhis-how-astrix-solves-the-hidden-identity-risk/ ; https://astrix.security/learn/news/astrix-security-recognized-on-fortune-cyber-60-list/
- [S36] Crunchbase: Identity security funding (Persona $200M, Veza $108M, May 2025) — https://news.crunchbase.com/cybersecurity/identity-security-startup-funding-ai-agents-sam-altman-world-orb/
- [S37] Teleport MCP access docs + zero-code MCP blog (incl. tool-level caveat) — https://goteleport.com/docs/machine-workload-identity/access-guides/mcp.md ; https://goteleport.com/blog/secure-ai-agents-zero-code-mcp/
- [S38] Pomerium MCP security + experimental changelog — https://www.pomerium.com/blog/secure-access-for-mcp ; https://www.pomerium.com/changelog/experimental-mcp-support
- [S39] HumanLayer (YC launch; OSS; HITL patterns; Permit.io comparison) — https://www.ycombinator.com/launches/M8e-humanlayer-human-in-the-loop-for-ai-agents-and-beyond ; http://www.blog.brightcoding.dev/2025/08/13/humanlayer-the-missing-bridge-between-autonomous-ai-and-human-oversight ; https://www.permit.io/blog/human-in-the-loop-for-ai-agents-best-practices-frameworks-use-cases-and-demo
- [S40] Nudge Security agentic OAuth/extension analysts (Jul 2026) — https://www.nudgesecurity.com/press/nudge-security-unveils-ai-agents-to-mitigate-escalating-risks-from-hidden-oauth-grants-and-browser-extensions
- [S41] Teleport/Doyensec policy-engine benchmark (Rego/Cedar/OpenFGA/ACD) — https://goteleport.com/blog/benchmarking-policy-languages/
- [S42] CNCF policy-languages primer; Permit.io showdown; Oso guide — https://www.cncf.io/blog/2024/05/21/love-hate-and-policy-languages-an-introduction-to-decision-making-engines/ ; https://www.permit.io/blog/policy-engine-showdown-opa-vs-openfga-vs-cedar ; https://www.osohq.com/learn/opa-vs-cedar-vs-zanzibar
- [S43] OpenFGA AI Agent Authorization pattern (page shell T1; content T2) — https://openfga.dev/docs/use-cases/ai-agent-authorization
- [S44] CISO AI Market Map (63 vendors, 8 workflows, no ranking; agent-access sharpest signal) — https://openfutureforum.com/research/ciso-ai-market-map
- [S45] Economist/Rubrik Power Without Control (804 execs; prevention/recovery split) — see https://assets.ctfassets.net/9crgcb5vlu43/b45I8frSkRVYooOTgoSqW/a6f747a7caf078720f92c6151108dba2/Power_without_control_whitepaper.pdf (URL from search index)

## 10. Contradictory Evidence (what weakens this pack's own case)

- OFF samples are operator/opt-in (n=45/40), not probabilistic; Lightspeed/Wakefield/BCG are vendor-sponsored surveys with unknown questionnaires — treat all shares as directional (B), never as market sizes.
- "84% fewer prompts," "90% review-time cut," named-customer lists, and "industry's first" claims are vendor self-reports (C) — cited for positioning, not proof.
- CVE-2025-6514/500k-developers claim is AI-generated monitor text (unverified) — excluded from incident counts.
- CyberArk/Palo Alto Networks parentage appears in single-vendor press copy — org-structure claim left at C.
- T2 snippets support only literal wording; any paraphrase beyond the snippet is inference and labeled as such above.
- No pricing verified beyond模型: AgentCore consumption, Model Armor free tier, suite/tier licensing names. No verified WTP in dollars — Section 5 WTP reads are qualitative by design.

## 11. Recommendation: NARROW (not GO, not KILL)

Thesis "Exousia as a broad agent-control platform" should NOT proceed — absorption + consolidation + per-silo enforcement make a platform wedge indefensible on current evidence. Thesis "Exousia as one choke-point wedge in §8, validated against a named owner + budget path + measurable outcome" may proceed to customer validation ONLY. Next smallest experiment: pick ONE wedge (suggested #1 or #2), run 5–8 discovery calls with the named buyer, and pre-register kill criteria (e.g., <2/8 confirm standing budget path → drop the wedge). No build until a wedge clears that bar.

*End of pack. No code built. No winner chosen. No scores assigned.*

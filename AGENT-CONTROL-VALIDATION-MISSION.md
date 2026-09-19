# Exousia — Agent Control Validation Mission

**Mission ID:** EXOUSIA-VALIDATION-001  
**Status:** NOT STARTED  
**Owner:** Arsenio  
**Execution Lead:** Hermes  
**Scope:** Gate 0 → Gate 2  
**Primary objective:** Determine whether Exousia solves a sufficiently painful problem, whether the proposed control model is technically and experientially viable, and whether real developers will use it.

---

## 0. Mission Rule

This is a **validation mission, not a product-development mission**.

Hermes must not assume Exousia is a viable business.

The mission exists to **try to disprove the thesis as efficiently as possible**.

The desired outcome is not necessarily "build Exousia."

Valid outcomes:

1. **GO** — evidence supports continuing.
2. **GO WITH NARROWER WEDGE** — the original thesis is too broad, but a specific wedge is supported.
3. **INCONCLUSIVE** — evidence is insufficient; identify the smallest next experiment.
4. **KILL** — evidence does not justify further investment.

Do not continue into productization merely because previous work has already been completed.

---

# 1. Working Product Thesis

## 1.1 Working definition

Exousia is a proposed **control layer for autonomous AI agents**.

The initial product hypothesis is a developer-facing CLI/runtime layer that sits between an AI agent and the actions/tools it can execute.

Conceptually:

```
AI Agent
   ↓
Exousia Control Layer
   ├── Identity
   ├── Policy
   ├── Risk evaluation
   ├── Permission / authority
   ├── Data boundaries
   └── Audit
   ↓
Tools / Shell / Git / APIs / Browser / Data
```

The intended experience is:

> **Maximum useful autonomy within minimum necessary authority.**

Exousia should not turn autonomous agents into approval-driven assistants.

Low-risk actions should normally proceed automatically.

High-risk or out-of-scope actions should be blocked or escalated.

---

# 2. Core Problem Hypothesis

Current autonomous AI agents create a tension between:

### Full autonomy

The agent can act quickly, but may have more authority than necessary.

### Approval-heavy security

The agent is constrained, but the human becomes a continuous approval bottleneck.

The hypothesis to validate is:

> Developers want autonomous agents to complete meaningful work without repeated approval prompts, but they also want a practical control boundary that limits dangerous, sensitive, or out-of-scope actions.

The specific initial wedge is:

> **Autonomous coding agents.**

Potential environments include, but are not limited to:

- Claude Code
- OpenAI Codex / coding agents
- OpenCode
- Gemini CLI
- Aider
- custom agent runtimes
- MCP-enabled agents

Do not assume every listed environment is technically compatible. Compatibility must be researched and tested.

---

# 3. Important Non-Goals

The following are explicitly OUT OF SCOPE for Gate 0–2 unless evidence makes them necessary:

- polished web application
- consumer mobile application
- enterprise dashboard
- billing system
- payment gateway
- marketing website
- complex cloud backend
- Kubernetes infrastructure
- multi-region infrastructure
- SSO / enterprise IAM
- full SIEM integration
- model training
- proprietary foundation model
- custom LLM
- broad "AI security platform"
- arbitrary enterprise compliance certification
- visual branding work
- production SaaS architecture

Do not expand scope merely because an adjacent feature appears interesting.

---

# 4. Product Principles To Validate

These are hypotheses, not facts.

## P1 — Autonomy over interruption

Users prefer an agent that can work independently rather than repeatedly asking for permission.

## P2 — Risk-based control

Not every action deserves the same level of scrutiny.

Possible action classes:

- LOW → automatic
- MEDIUM → automatic with guardrails
- HIGH → human decision
- CRITICAL → deny by default

The exact taxonomy must be validated rather than assumed.

## P3 — Delegation instead of individual approvals

Users should be able to grant authority for a task/session/scope rather than repeatedly approve individual actions.

Example:

> "Work on this repository and branch. You may edit files, install dependencies, run tests, and commit. Do not access secrets or production."

## P4 — Local-first enforcement

The security-critical decision path should ideally be local and fast.

Cloud services should not be required for every ALLOW/DENY decision unless evidence shows this is necessary.

## P5 — Agent/provider/tool agnostic

The control layer should ideally not depend on one model vendor or one agent.

This is a hypothesis to test against technical feasibility and existing standards.

---

# 5. Gate Structure

```
GATE 0
Problem + market evidence
        ↓
GATE 1
Concept + technical/UX prototype
        ↓
GATE 2
Real-user validation
        ↓
DECISION
GO / NARROW / INCONCLUSIVE / KILL
```

No gate may be declared PASS without meeting its evidence requirements.

---

# 6. GATE 0 — PROBLEM VALIDATION

## Objective

Determine whether the problem is:

1. real,
2. recurring,
3. sufficiently painful,
4. poorly solved by current alternatives,
5. relevant to a reachable initial user segment.

## 6.1 Research questions

Investigate:

### User pain

- How do developers currently manage permissions for autonomous agents?
- How frequently do agents interrupt users for approval?
- Do users disable approval mechanisms?
- Do users grant broad permissions because approval friction is too high?
- What dangerous or surprising agent actions have users experienced?
- What actions are considered acceptable to delegate?
- What actions are considered unacceptable?
- Do users already maintain shell wrappers, sandboxing, permission files, containers, VM isolation, MCP policies, or custom scripts?
- What causes users to trust an agent enough to give it more authority?

### Existing solutions

Research:

- agent-native permission systems
- coding-agent sandboxing
- OS sandboxing
- containers
- MCP authorization/security
- agent gateways
- AI security platforms
- API gateways
- policy engines
- cloud agent security products
- model/provider gateways
- OpenRouter-like routing/control products
- open-source permission/control projects

For every relevant competitor/alternative identify:

- problem addressed
- target user
- technical enforcement point
- autonomy model
- approval model
- policy model
- local vs cloud architecture
- pricing
- adoption signals
- limitations
- evidence of user demand

### Market signals

Look for:

- real user complaints
- GitHub issues
- Reddit discussions
- Hacker News discussions
- technical blog posts
- security incident reports
- developer forum discussions
- product launches
- documentation changes
- conference talks
- research papers

Prioritize first-hand evidence over vendor marketing.

---

# 7. Gate 0 Evidence Standard

Separate evidence into:

### A — Direct evidence

Real user statements, public issue reports, incident reports, usage reports, or observed behavior.

### B — Strong indirect evidence

Repeated discussions, credible research, product behavior, or multiple independent sources.

### C — Weak evidence

Vendor claims, speculative articles, isolated opinions, or assumptions.

Do not treat C-level evidence as proof of product-market demand.

Every major conclusion must identify its evidence level.

---

# 8. Gate 0 Required Deliverables

Create:

```
docs/
└── validation/
    ├── GATE-0-PROBLEM-RESEARCH.md
    ├── GATE-0-COMPETITOR-MAP.md
    ├── GATE-0-USER-PAIN-EVIDENCE.md
    └── GATE-0-REPORT.md
```

The final report must include:

1. problem statement
2. target user
3. strongest evidence
4. strongest counter-evidence
5. existing alternatives
6. unresolved questions
7. recommended wedge
8. Gate 0 decision
9. confidence level
10. exact evidence supporting the decision

---

# 9. Gate 0 Pass Criteria

Gate 0 can PASS only if the evidence supports all of the following:

- A specific user segment experiences the problem.
- The problem occurs in real autonomous-agent workflows.
- The autonomy-vs-control tradeoff is observable.
- Existing solutions do not obviously solve the exact problem sufficiently.
- There is a plausible initial product wedge.
- At least one meaningful path exists to reach real users for Gate 2.

A high volume of generic "AI security is important" articles is NOT sufficient.

---

# 10. Gate 0 Kill Criteria

Recommend KILL if:

- the pain is mostly hypothetical;
- users already have satisfactory solutions;
- autonomous-agent users do not experience meaningful approval friction;
- users prefer unrestricted agents and do not care about control;
- the proposed wedge is indistinguishable from existing products;
- the problem requires enterprise procurement before any useful validation is possible;
- the product cannot reach real users without substantial infrastructure;
- evidence is dominated by vendor marketing rather than user behavior.

Do not rationalize around a kill criterion.

---

# 11. GATE 1 — CONCEPT + TECHNICAL PROTOTYPE

## Objective

Determine whether Exousia's core interaction model is technically feasible and whether risk-based autonomy is materially better than approval-per-action.

This is a prototype, not a product.

---

## 11.1 Prototype target

Build the smallest possible CLI/runtime experiment.

Conceptual invocation:

```bash
agentctl run -- <agent>
```

The actual command name is provisional.

The prototype should demonstrate:

```
Agent action
    ↓
Exousia
    ↓
Policy evaluation
    ↓
ALLOW / ASK / DENY
    ↓
Tool/action
```

---

# 12. Minimum Gate 1 Capabilities

## 12.1 Action interception

Demonstrate interception of a defined set of agent actions.

Start with the smallest technically reliable surface.

Do not attempt to intercept every possible agent/tool protocol.

## 12.2 Policy

Support a minimal policy representation.

Example:

```yaml
allow:
  - read_project
  - edit_project
  - run_tests
  - package_install
  - git_commit

ask:
  - git_push

deny:
  - production
  - secrets
  - external_upload
```

This is illustrative only. Validate the actual policy schema.

## 12.3 Risk decision

Implement deterministic decision logic before adding LLM-based risk decisions.

The system should produce:

- ALLOW
- ASK
- DENY

Risk levels may be:

- LOW
- MEDIUM
- HIGH
- CRITICAL

but this taxonomy must remain configurable.

## 12.4 Audit

Record enough information to reconstruct:

- timestamp
- agent identity
- action
- target/resource
- policy
- decision
- reason
- session/task context

Avoid collecting sensitive user data unnecessarily.

---

# 13. Gate 1 UX Hypothesis

Compare:

### Model A — approval-per-action

```
Agent → permission prompt → human → action
```

against:

### Model B — risk-based autonomy

```
Agent
 ↓
policy/risk engine
 ↓
low-risk → automatic
high-risk → human
critical → deny
```

The prototype should make the difference observable.

The key question:

> Can the agent complete meaningful tasks while significantly reducing human interruptions without removing important safety boundaries?

---

# 14. Gate 1 Required Tests

Create synthetic but realistic agent workloads.

Examples:

### Coding task

- inspect repository
- modify source
- install dependency
- run tests
- create commit
- push feature branch

### Sensitive-data task

- attempt to read .env
- attempt to access SSH credentials
- attempt to upload local data
- attempt to contact unapproved external domain

### Production-boundary task

- modify production configuration
- write to production database
- deploy production

The prototype must clearly distinguish allowed, restricted, and forbidden behavior.

---

# 15. Gate 1 Required Deliverables

```
docs/
└── validation/
    ├── GATE-1-CONCEPT-SPEC.md
    ├── GATE-1-THREAT-MODEL.md
    ├── GATE-1-UX-EVALUATION.md
    └── GATE-1-REPORT.md
```

Prototype code may exist, but only what is necessary to answer the Gate 1 questions.

---

# 16. Gate 1 Pass Criteria

Gate 1 can PASS if:

- the control point is technically feasible;
- policy decisions can be enforced reliably for the selected action surface;
- low-risk actions can proceed without repeated human interaction;
- high-risk actions can be escalated;
- forbidden actions can be denied;
- the mechanism does not create unacceptable latency or break normal agent workflows;
- no obvious trivial bypass exists within the tested scope;
- the concept demonstrates a meaningful improvement over approval-per-action in the tested scenarios.

---

# 17. Gate 1 Kill Criteria

Recommend KILL or major redesign if:

- enforcement is fundamentally unreliable;
- agents can trivially bypass the control layer;
- the integration requires invasive modifications to every supported agent;
- latency destroys the autonomous workflow;
- policy complexity becomes worse than the original problem;
- the prototype provides no meaningful improvement over existing permission mechanisms.

---

# 18. GATE 2 — REAL USER VALIDATION

## Objective

Determine whether real developers will actually use Exousia in their own workflows.

This is the first gate where **real human behavior is mandatory**.

Synthetic users, LLM-generated personas, and Hermes simulations do not count.

---

# 19. Target participants

Initial target:

**5–10 developers who actively use autonomous or semi-autonomous coding agents.**

Prefer users who:

- use coding agents repeatedly;
- work in real repositories;
- already grant meaningful permissions to agents;
- experience permission friction;
- have enough technical skill to install a CLI;
- are willing to run the prototype on non-sensitive projects.

Do not recruit only people who already agree with the thesis.

Seek disagreement.

---

# 20. Gate 2 Protocol

Each participant should be able to:

1. install Exousia;
2. configure a simple policy/profile;
3. run an existing agent through Exousia;
4. complete a real development task;
5. operate without constant approval prompts;
6. encounter at least one controlled boundary;
7. report whether they would continue using it.

Collect only data necessary for validation.

Never require participants to expose secrets, proprietary source code, credentials, or private customer data.

---

# 21. Gate 2 Metrics

Primary metrics:

### 1. Task completion rate

How often does the agent complete the intended task?

### 2. Human interruption rate

How many manual interventions occur per task?

### 3. Return usage

Do participants use Exousia again after the first session?

### 4. Retention signal

Do they voluntarily install/use it again without being asked?

### 5. Trust boundary quality

Did Exousia prevent or surface actions participants considered unacceptable?

### 6. Setup friction

How difficult was installation/configuration?

### 7. Qualitative value

Would users miss Exousia if it were removed?

---

# 22. Gate 2 Willingness-to-Pay Test

Do not build billing.

Instead, test willingness to pay directly.

After meaningful usage, ask users whether they would pay for concrete capabilities such as:

- team policy
- shared policy
- centralized audit
- policy sync
- agent identity
- provider/model allowlists
- longer audit retention
- organization-wide controls

Record:

- what they value;
- what they reject;
- what they would pay for;
- whether their answer changes after actual usage.

Do not treat hypothetical pricing enthusiasm as equivalent to payment.

If feasible, test an actual paid pilot or pre-order only after users have experienced the product.

---

# 23. Gate 2 Required Deliverables

```
docs/
└── validation/
    ├── GATE-2-USER-TEST-PROTOCOL.md
    ├── GATE-2-RESULTS.md
    ├── GATE-2-WILLINGNESS-TO-PAY.md
    └── GATE-2-REPORT.md
```

---

# 24. Gate 2 Pass Criteria

Gate 2 can PASS only if real users demonstrate:

- repeated usage;
- meaningful autonomous task completion;
- reduced interruption compared with their previous workflow;
- trust in the control boundary;
- manageable setup friction;
- evidence of willingness to pay for at least one clear extension.

The exact numeric thresholds should be proposed by Hermes after Gate 0 research rather than invented prematurely.

---

# 25. Critical Principle: No Fake Validation

Hermes must never count the following as user validation:

- simulated users;
- generated personas;
- LLM opinions;
- internal agent tests;
- GitHub stars created by automation;
- generated testimonials;
- fabricated interview transcripts;
- hypothetical survey responses;
- "likely users would..." statements.

Real human evidence must be clearly separated from model inference.

---

# 26. Hermes Responsibilities

Hermes MAY:

- research;
- browse public sources;
- analyze competitors;
- collect evidence;
- write reports;
- build disposable prototypes;
- create test harnesses;
- run technical experiments;
- analyze telemetry;
- prepare recruitment material;
- prepare interview questions;
- prepare onboarding;
- maintain validation documentation;
- summarize results;
- recommend GO / NARROW / INCONCLUSIVE / KILL.

Hermes SHOULD proactively identify contradictions and disconfirming evidence.

---

# 27. Hermes Restrictions

Hermes MUST NOT:

- assume Exousia is a viable business;
- declare market demand without evidence;
- fabricate users;
- fabricate interviews;
- fabricate willingness-to-pay;
- expand scope without justification;
- build production infrastructure before Gate 2;
- create a second Hermes installation;
- modify unrelated projects;
- spend meaningful cloud/API budget without explicit authorization;
- expose private participant data;
- use production credentials for experiments;
- weaken security controls merely to make a demo appear successful.

---

# 28. Human Decision Rights

Arsenio retains final authority over:

- passing a gate;
- killing the project;
- changing the thesis;
- spending meaningful money;
- contacting people externally when explicit approval is required;
- releasing a public product;
- collecting sensitive data;
- accepting major security risk.

Hermes provides evidence and recommendations.

Hermes does not make the founder decision.

---

# 29. Budget Discipline

The validation mission must optimize for **information gained per unit of time and money**.

Before each expensive action, Hermes should ask:

> What uncertainty will this action resolve?

Prefer:

- public research;
- local experiments;
- disposable prototypes;
- free/open-source tools;
- small user tests;
- existing infrastructure.

Avoid:

- paid infrastructure;
- elaborate cloud architecture;
- production hosting;
- premature domains;
- paid marketing;
- complex SaaS services.

Any material cost must be explicitly reported.

---

# 30. Time Discipline

The mission is intentionally time-boxed.

Hermes should propose a realistic time budget for each gate after initial reconnaissance.

Do not allow open-ended research.

A research task must have:

- question;
- evidence target;
- stopping condition;
- output.

When additional research stops changing the decision, stop researching.

---

# 31. Decision Framework

At the end of each gate, Hermes must produce:

```
GATE:
STATUS:
CONFIDENCE:

WHAT WE BELIEVED:
WHAT WE FOUND:
WHAT CHANGED:
STRONGEST SUPPORTING EVIDENCE:
STRONGEST COUNTER-EVIDENCE:

WHAT REMAINS UNKNOWN:

RECOMMENDATION:
GO / NARROW / INCONCLUSIVE / KILL

WHY:

NEXT SMALLEST EXPERIMENT:
EXPECTED INFORMATION GAIN:
ESTIMATED TIME:
ESTIMATED COST:
```

Do not bury the decision inside a long report.

---

# 32. Core Anti-Philialink Rule

Exousia must not become a months-long build based on assumptions.

The default behavior is:

```
UNKNOWN
  ↓
VALIDATE
  ↓
EVIDENCE
  ↓
DECIDE
  ↓
ONLY THEN BUILD
```

Not:

```
IDEA
  ↓
DESIGN
  ↓
CODE
  ↓
POLISH
  ↓
MORE CODE
  ↓
DISCOVER WHETHER ANYONE WANTS IT
```

---

# 33. Initial Success Definition

Exousia is successful at the validation stage if we can demonstrate:

> A real developer can give an AI agent meaningful autonomy, complete useful work with fewer interruptions, and retain a clear boundary around dangerous or unauthorized actions.

Business success requires a second proof:

> Real developers voluntarily continue using the control layer and demonstrate willingness to pay for expanded governance capabilities.

Until both are supported by evidence, Exousia remains a hypothesis.

---

# 34. First Mission

**Do not build the product yet.**

Start with:

### GATE 0 — PROBLEM VALIDATION

Research the problem aggressively.

The first objective is not to prove Exousia is right.

The first objective is to determine:

> **What exactly is broken today in autonomous-agent control, for whom, how often, how severely, and why existing solutions are insufficient.**

Only after Gate 0 is complete should Gate 1 begin.

---

## Mission Status

**NOT STARTED**

**Next action:** Begin Gate 0 research only.

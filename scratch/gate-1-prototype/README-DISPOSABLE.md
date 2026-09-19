# DISPOSABLE Gate-1 prototype — NOT a product, NOT maintained, NOT secure-by-default.

Proves or kills ONE question: can a local layer enforce allow/ask/deny below
agent-writable config? Throw away after Gate 1. See docs/validation/GATE-1-*.md.

Components: `agentctl` (supervisor + sandbox + gate), `policy.json`,
`run_matrix.py` (adversarial battery). Stdlib only. Linux-only (namespaces + Landlock).

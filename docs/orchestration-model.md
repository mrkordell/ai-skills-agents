# OpenCode Orchestration Model

This repository is OpenCode-first. `opencode/agents/dev-lead.md` is the canonical primary orchestrator and all other OpenCode agents are routable specialists.

## Primary Orchestrator

`dev-lead` does not build directly. It starts each request with triage, delegates substantive work, convenes a council before non-trivial implementation, and synthesizes specialist output into one decision.

For non-trivial work, the expected response shape is:

- `Triage`
- `Council`
- `Doers`
- `Testers`
- `Documentation`
- `Decision Needed`

## Specialist Roles

- Planners clarify intent, value, sequencing, and design direction.
- Architects and challengers pressure-test structure, migration risk, simplicity, and domain decisions.
- Doers implement within a clear domain boundary.
- Testers validate behavior, regressions, and acceptance criteria.
- Documentation specialists preserve decisions, setup, handoffs, and operating knowledge.

## Staffing Rule

Use the smallest complete team for the request. If no specialist has clear ownership, use `agent-architect` to design the missing role and only use `general` as a temporary bridge.

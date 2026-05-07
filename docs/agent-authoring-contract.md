# Agent Authoring Contract

OpenCode agents live in `opencode/agents/*.md` and should follow the existing markdown/frontmatter convention.

## Required Shape

Each agent should include frontmatter with:

- `description`
- `mode: subagent` for specialists or `mode: primary` for the orchestrator
- `temperature`
- `color`
- conservative `permission.task` rules, usually denying delegation from specialists

The body should make the role easy to route:

- What the agent owns
- What it explicitly does not own
- When to use it
- Expected output

## Boundaries

- One agent should have one primary responsibility.
- Prefer named specialists over broad multi-purpose agents.
- Keep permissions narrow unless the role has a clear operational need.
- When adding a specialist, update `dev-lead` routing and permission allow-list in the same change.
- Update README counts/lists and run `bash scripts/validate-agents.sh` before handoff.

# AI Skills & Agents

Custom agents for [Claude Code](https://docs.anthropic.com/en/docs/claude-code) and [OpenCode](https://github.com/opencode-ai/opencode). The repository is OpenCode-first: new specialist coverage is represented in `opencode/agents/`, with existing Claude Code agents preserved for compatibility.

## Quick Install

Works on macOS, Linux, and Windows (Git Bash / MSYS2 / WSL).

```bash
curl -fsSL https://raw.githubusercontent.com/mrkordell/ai-skills-agents/main/install.sh | bash
```

The installer detects your platform and installs to the correct config directories:

| Platform | Claude Code | OpenCode |
|----------|------------|----------|
| macOS / Linux | `~/.claude/agents/` | `~/.config/opencode/agents/` |
| Windows (Git Bash) | `%USERPROFILE%\.claude\agents\` | `%USERPROFILE%\.config\opencode\agents\` |

Restart Claude Code or OpenCode after installing to pick up the new agents.

## Agents

### Claude Code (9)

| Agent | Description |
|-------|-------------|
| `api-documentation-specialist` | API documentation for public-facing endpoints |
| `architecture-reviewer` | Architectural review against SOLID principles |
| `behavioral-qa-engineer` | Behavioral testing focused on user outcomes |
| `golf-code-strategist` | Golf domain expertise for scoring, handicaps, and rules |
| `react-performance-reviewer` | React performance and architectural best practices |
| `senior-code-reviewer` | Architecture, code quality, and developer experience review |
| `senior-visual-designer` | Visual direction, UI/UX critique, and design feedback |
| `solid-code-reviewer` | SOLID principles, design patterns, and clean code review |
| `ui-ux-code-reviewer` | Frontend code review from a UI/UX perspective |

### OpenCode (40: 1 primary orchestrator + 39 routable specialists)

| Agent | Description |
|-------|-------------|
| `acf-expert` | Advanced Custom Fields architecture and data modeling |
| `ad-tech-vast-specialist` | VAST, VMAP, video ad tracking, and player integration diagnostics |
| `agent-architect` | Designs and improves agents to fill team gaps |
| `agent-runtime-engineer` | Agent runtime, tool contracts, context loading, and orchestration reliability |
| `backend-architect` | APIs, services, auth, jobs, and integrations |
| `browser-sdk-engineer` | Browser SDKs, embeds, loading strategy, compatibility, and public APIs |
| `bun-engineer` | Bun runtime, scripts, and package management |
| `clean-architecture-architect` | Boundaries, responsibilities, and dependency direction |
| `creative-director` | UX direction, information architecture, and visual taste |
| `data-oriented-performance-engineer` | Measurement-led performance work, hot paths, allocation, and data layout |
| `database-architect` | Schema design, indexing, migrations, and data integrity |
| `dev-lead` | Primary orchestrator that triages, delegates, convenes councils, and never builds directly |
| `devops-engineer` | CI/CD, infrastructure, containers, and deployment |
| `docker-engineer` | Dockerfiles, Compose, and container ergonomics |
| `documentation-specialist` | READMEs, ADRs, architecture notes, and handoffs |
| `evolutionary-architecture-architect` | Incremental modernization, migration seams, and safe long-term change |
| `explore` | Read-only codebase reconnaissance and implementation context |
| `first-principles-engineer` | Challenges complexity and assumptions from first principles |
| `general` | Cross-cutting execution bridge when no stronger specialist fits |
| `gulp-build-specialist` | Gulp asset pipelines, SCSS/JS builds, and BrowserSync |
| `laravel-expert` | Laravel architecture, Eloquent, requests, and Pest |
| `llm-engineer` | Prompts, evaluations, structured output, and retrieval |
| `mysql-expert` | MySQL schema, indexing, query tuning, and migrations |
| `orm-specialist` | ORM modeling, relations, and query strategy |
| `php-expert` | Modern PHP 8.3+, PSR-12, strict types, and services |
| `pragmatic-delivery-engineer` | Delivery slicing, sequencing, rollout risk, and acceptance gates |
| `product-strategist` | Feature scoping, assumptions, and business questions |
| `puppeteer-qa` | End-to-end browser coverage and regression automation |
| `python-expert` | Python development, data wrangling, and automation |
| `react-engineer` | React architecture, state, and frontend integration |
| `refactoring-expert` | Safer, clearer structure without breaking behavior |
| `scorm-lms-specialist` | SCORM packages, LMS runtime APIs, completion, scoring, and interoperability |
| `svelte-engineer` | Svelte/SvelteKit components, stores, routing, forms, and accessibility |
| `tailwind-ui-engineer` | Tailwind HTML, responsive layout, and accessible styling |
| `timber-twig-specialist` | Timber themes, Twig templates, and context shaping |
| `unit-test-engineer` | Unit, component, integration, and contract tests |
| `vue-vuetify-engineer` | Vue/Vuetify components, composables, forms, theming, and UI workflows |
| `wordpress-expert` | Hooks, plugins, custom post types, and WordPress APIs |
| `wordpress-speed-security-engineer` | Caching, hardening, and Core Web Vitals |
| `wordpress-theme-specialist` | Classic, hybrid, and block theme architecture |

## Adding New Agents

1. Create a `.md` file in the appropriate directory. Prefer `opencode/agents/` for new specialists.
2. Update the `dev-lead` permission allow-list/routing and the README count/list.
3. Run `bash scripts/validate-agents.sh`.
4. Commit and push.
5. Run the install script on any machine to pick up the new agents.

This repo intentionally provides local OpenCode definitions for `explore` and `general`; after install, those local definitions may shadow OpenCode built-ins with the same names.

See `docs/orchestration-model.md` for the OpenCode team model and `docs/agent-authoring-contract.md` for lightweight authoring rules.

## License

MIT

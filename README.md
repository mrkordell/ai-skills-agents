# AI Skills & Agents

Custom agents for [Claude Code](https://docs.anthropic.com/en/docs/claude-code) and [OpenCode](https://github.com/opencode-ai/opencode). One command to install them all on any machine.

## Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/mrkordell/ai-skills-agents/main/install.sh | bash
```

This installs all agents to their expected config directories:

| Tool | Install Path |
|------|-------------|
| Claude Code | `~/.claude/agents/` |
| OpenCode | `~/.config/opencode/agents/` |

Restart Claude Code or OpenCode after installing to pick up the new agents.

## Manual Install

```bash
git clone https://github.com/mrkordell/ai-skills-agents.git
cd ai-skills-agents
./sync.sh pull
```

## Keeping Agents in Sync

The included `sync.sh` script copies agents between this repo and your local config directories.

```bash
# Pull repo agents into local config dirs
./sync.sh pull

# Push local config changes into the repo (for committing)
./sync.sh push
```

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

### OpenCode (29)

| Agent | Description |
|-------|-------------|
| `dev-lead` | Development lead that orchestrates all other agents |
| `product-strategist` | Feature scoping, assumptions, and business questions |
| `creative-director` | UX direction, information architecture, and visual taste |
| `agent-architect` | Designs and improves agents to fill team gaps |
| `first-principles-engineer` | Challenges complexity and assumptions from first principles |
| `clean-architecture-architect` | Boundaries, responsibilities, and dependency direction |
| `refactoring-expert` | Safer, clearer structure without breaking behavior |
| `backend-architect` | APIs, services, auth, jobs, and integrations |
| `database-architect` | Schema design, indexing, migrations, and data integrity |
| `orm-specialist` | ORM modeling, relations, and query strategy |
| `devops-engineer` | CI/CD, infrastructure, containers, and deployment |
| `docker-engineer` | Dockerfiles, Compose, and container ergonomics |
| `php-expert` | Modern PHP 8.3+, PSR-12, strict types, and services |
| `laravel-expert` | Laravel architecture, Eloquent, requests, and Pest |
| `wordpress-expert` | Hooks, plugins, custom post types, and WordPress APIs |
| `acf-expert` | Advanced Custom Fields architecture and data modeling |
| `wordpress-theme-specialist` | Classic, hybrid, and block theme architecture |
| `timber-twig-specialist` | Timber themes, Twig templates, and context shaping |
| `wordpress-speed-security-engineer` | Caching, hardening, and Core Web Vitals |
| `mysql-expert` | MySQL schema, indexing, query tuning, and migrations |
| `gulp-build-specialist` | Gulp asset pipelines, SCSS/JS builds, and BrowserSync |
| `react-engineer` | React architecture, state, and frontend integration |
| `tailwind-ui-engineer` | Tailwind HTML, responsive layout, and accessible styling |
| `bun-engineer` | Bun runtime, scripts, and package management |
| `python-expert` | Python development, data wrangling, and automation |
| `llm-engineer` | Prompts, evaluations, structured output, and retrieval |
| `unit-test-engineer` | Unit, component, integration, and contract tests |
| `puppeteer-qa` | End-to-end browser coverage and regression automation |
| `documentation-specialist` | READMEs, ADRs, architecture notes, and handoffs |

## Adding New Agents

1. Create a `.md` file in the appropriate directory (`claude-code/agents/` or `opencode/agents/`)
2. Commit and push
3. Run `./sync.sh pull` on any machine to install

## License

MIT

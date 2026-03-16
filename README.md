# ~/.claude — Personal Claude Code Configuration

A multi-agent AI development environment built on top of [Claude Code](https://claude.ai/claude-code). Provides specialized agents, reusable skills, and Git Flow automation that work together as an opinionated code review and workflow pipeline.

---

## Structure

```
~/.claude/
├── agents/          # Specialized agent definitions (28+)
├── skills/          # Reusable slash-command workflows
├── commands/        # Custom Git Flow slash commands
├── hooks/           # Event-triggered shell hooks
├── CLAUDE.md        # Global instructions (always loaded)
├── settings.json    # Local Claude Code settings
├── claude.json      # MCP servers & hook config
└── statusline.sh    # Custom terminal status line
```

---

## Agents

Agents are specialized AI personas defined as markdown files in `agents/`. Each has a specific domain of expertise, a set of available tools, and a trigger condition describing when it should be invoked. Claude Code's tool routing uses these definitions to dispatch the right agent for the right task.

### How Agents Are Used

Agents are invoked two ways:

1. **Explicitly** — via the `Agent` tool in the main orchestrator or skills, e.g., the `/commit` skill dispatches multiple agents in parallel during code review.
2. **Automatically** — Claude Code infers agent relevance from the agent's `description` field and triggers it when conditions match.

### Review Pipeline (how agents work together)

The `/commit` skill implements a triage-based review pipeline:

```
git diff
   └── Triage
         ├── NONE  (docs/config only)    → skip review → commit
         ├── LIGHT (small source change) → simplicity + language reviewer
         └── FULL  (large/sensitive)     → all agents in parallel
                    ├── code-simplicity-reviewer
                    ├── kieran-typescript-reviewer  (or python/rails)
                    ├── security-sentinel
                    ├── architecture-strategist
                    └── pattern-recognition-specialist
                         └── synthesize verdicts → PASS / WARN / FAIL
```

FAIL blocks the commit. WARN surfaces feedback but proceeds. PASS commits with an auto-generated conventional commit message.

---

### Agent Catalog

#### Code Quality & Review

| Agent | Purpose |
|---|---|
| `code-simplicity-reviewer` | Ruthlessly removes complexity. Enforces YAGNI. Flags unnecessary abstractions and gold-plating. |
| `kieran-typescript-reviewer` | Ultra-strict TypeScript review. Enforces type safety, modern patterns (never `any`), and idiomatic TS. |
| `kieran-python-reviewer` | Same high bar for Python — type hints, Pythonic patterns, structure. |
| `kieran-rails-reviewer` | Rails conventions, naming, Hotwire/Turbo idioms, ActiveRecord best practices. |
| `dhh-rails-reviewer` | Brutally honest Rails review from a "DHH perspective" — flags over-engineering and JS framework contamination. |
| `pattern-recognition-specialist` | Identifies design patterns, anti-patterns, naming inconsistencies, and code duplication across the codebase. |
| `lint` | Runs linting and code quality checks on Ruby and ERB files. |

#### Security & Data

| Agent | Purpose |
|---|---|
| `security-sentinel` | Full security audit — OWASP top 10, input validation, auth/authz, hardcoded secrets, injection vectors. Thinks like an attacker. |
| `data-integrity-guardian` | Reviews migrations, data models, transaction boundaries, referential integrity, GDPR/CCPA compliance. |
| `data-migration-expert` | Validates ID mappings, checks for swapped values, verifies rollback safety for data transformations. |
| `deployment-verification-agent` | Produces Go/No-Go checklists with SQL verification queries, rollback procedures, and monitoring plans for risky deployments. |

#### Architecture & Performance

| Agent | Purpose |
|---|---|
| `architecture-strategist` | Reviews changes for architectural compliance, component boundary violations, and system design alignment. |
| `performance-oracle` | Analyzes algorithms, DB queries, memory usage, caching strategies, and scalability (Big O). |

#### Frontend

| Agent | Purpose |
|---|---|
| `julik-frontend-races-reviewer` | Specialist in JS/Stimulus race conditions — async timing, DOM mutation ordering, animation concurrency. |
| `design-iterator` | Iteratively refines UI/UX by taking screenshots, analyzing gaps, and re-implementing. Runs N times. |
| `design-implementation-reviewer` | Verifies pixel-perfect fidelity between Figma specs and live implementation. |
| `figma-design-sync` | Auto-detects and fixes visual differences between a Figma URL and the running implementation. |

#### Workflow & Specification

| Agent | Purpose |
|---|---|
| `spec-flow-analyzer` | Maps user flows in specs, identifies edge cases and missing elements, surfaces clarifying questions before implementation starts. |
| `bug-reproduction-validator` | Systematically attempts to reproduce a reported bug and confirms whether the behavior is a real defect. |
| `pr-comment-resolver` | Reads PR review comments and implements the requested changes, then reports back on what was done. |
| `git-flow-manager` | Orchestrates Git Flow branching — feature/release/hotfix creation, merging, tagging, and validation. |

#### Research

| Agent | Purpose |
|---|---|
| `best-practices-researcher` | Fetches official docs, community standards, and open source examples for any technology or practice. |
| `framework-docs-researcher` | Gathers comprehensive documentation for frameworks/libraries, including version-specific constraints. |
| `git-history-analyzer` | Archaeological analysis of git history — traces code evolution, identifies contributors, explains why patterns exist. |
| `repo-research-analyst` | Comprehensive repository analysis — architecture docs, issue patterns, contribution guidelines, implementation conventions. |

#### Writing & Style

| Agent | Purpose |
|---|---|
| `every-style-editor` | Enforces Every's editorial style guide — title case, sentence structure, punctuation, number formatting. |
| `ankane-readme-writer` | Writes README files following the Ankane gem documentation style. |
| `testing-principles` | Reviews tests against Red/Green/Refactor TDD principles and testing philosophy. |

---

## Skills

Skills are slash commands defined in `skills/`. They compose agents and tools into multi-step workflows.

| Skill | Trigger | What it does |
|---|---|---|
| `/commit` | Committing code | Type-check → lint → triage → parallel agent review → conventional commit |
| `/commit-push` | "commit and push" | `/commit` + push in one step |
| `/push` | Pushing code | Type-check → push |
| `/pr` | Creating a PR | Analyze diff → draft title + body → `gh pr create` |
| `/review-pr` | Reviewing a PR | Fetch PR diff → run review agents → synthesize feedback |
| `/onboard` | Starting in a new project | Explore structure, stack, git state → suggest relevant skills |
| `/new-project` | Bootstrapping a project | Scaffolding, gitignore, tsconfig, etc. |
| `/gh-fetch` | GitHub URLs | Fetch GitHub issues/PRs/repos via CLI instead of web |
| `/agent-browser` | Web automation | Browse, fill forms, screenshot via Vercel agent-browser CLI |
| `/find-skills` | "is there a skill for X" | Search and surface available installable skills |

---

## Git Flow Commands

Slash commands in `commands/` wrap the `git-flow-manager` agent:

```
/feature <name>    # branch from develop: feature/<name>
/release           # branch from develop: release/<version>
/hotfix <name>     # branch from main:    hotfix/<name>
/finish            # merge back per Git Flow rules + tag if release/hotfix
/flow-status       # show current branch type, sync status, and merge targets
```

Releases and hotfixes auto-suggest semantic version bumps and generate CHANGELOG entries from conventional commits.

---

## Configuration

### `CLAUDE.md`
Global instructions always loaded into every conversation. Defines:
- Core rules (never commit secrets, never commit `.env`)
- Language preference (TypeScript over JavaScript)
- TDD workflow (Red → Green → Refactor)
- BLZ for docs lookup
- React version security warnings
- Communication preferences

### `settings.json`
- TypeScript LSP enabled
- `code-simplifier` plugin active
- Prettier auto-format on edit for `.ts`, `.tsx`, `.js`, `.jsx`, `.json`, `.css`, `.md`
- Custom status line via `statusline.sh`

### `claude.json`
- MCP server registrations
- `PreCompact` and `SessionStart` hooks run `bd prime` (BLZ index refresh)

---

## Design Principles

The agents and workflows in this repo encode these values:

- **Functional core, imperative shell** — pure business logic stays separate from IO
- **Type safety first** — `any` is never acceptable without justification
- **Simplicity over cleverness** — three similar lines beats a premature abstraction
- **Security paranoia** — validate at boundaries, think like an attacker
- **Data is sacred** — every migration needs a rollback plan
- **YAGNI** — don't build what isn't needed yet

# Codebase Onboard Skill

Perform a structured onboarding for the current project. Run all steps, then present the results in one consolidated response.

## 1. Read Existing Context

- Read `CLAUDE.md` (local) if it exists — note any commands, conventions, tech stack info
- Read `README.md` if it exists
- Check `.claude/` directory for any local skills or hooks

## 2. Discover Tech Stack

Run these in parallel:
- `cat package.json 2>/dev/null | head -60` — JS/TS dependencies, scripts
- `ls *.toml *.cfg pyproject.toml requirements*.txt 2>/dev/null` — Python project signals
- `git log --oneline -10` — recent commit history
- `git branch -a` — branches
- `ls -la` — top-level structure

From this, identify:
- Framework (React, Next.js, Flask, FastAPI, Express, etc.)
- Language(s) and versions
- Test runner
- How to run dev server / build / test

## 3. Explore Key Directories

Skim the top-level structure and 1 level deep:
- `src/` or `app/` — main code
- `tests/` or `__tests__/` — test location and patterns
- `docs/` — any design docs, ADRs, CLI designs
- `scripts/` — utility scripts

Note any unusual patterns worth flagging.

## 4. Check Git State

```
git status
git stash list
```

Report any uncommitted changes or stashes the user should be aware of.

## 5. Summarize

Output a concise summary with these sections:

**Project:** [name and one-line purpose]

**Stack:** [language, framework, DB, deployment target]

**Key commands:**
- Dev: `[command]`
- Test: `[command]`
- Build/deploy: `[command]`

**Current branch:** [branch] | **Uncommitted changes:** [yes/no + summary]

**Recent work:** [2-3 bullets from git log]

**Things to know:** [any gotchas, active branches, incomplete work, design docs worth reading]

## 6. Suggest Relevant Skills

Based on the stack and project type, end with:

> For this project, [skill 1], [skill 2] and [skill 3] may be useful.

Map stack signals to skills:
- Has `package.json` + TypeScript → mention `commit`, `push`, `pr`
- Has React Native → mention `react-native-best-practices`
- Has PostgreSQL / TimescaleDB → mention `pg:design-postgres-tables`, `pg:setup-timescaledb-hypertables`
- Has `.github/workflows` or Vercel/Railway → mention `push` (it runs tsc before pushing)
- Is a new project → mention `new-project`
- Has browser automation needs → mention `agent-browser`
- Has Claude API imports → mention `claude-api`
- Has git branching activity → mention `commit`, `push`, `pr`, `review-pr`

Only suggest skills that are genuinely relevant — 2-4 max. Do not list all skills.

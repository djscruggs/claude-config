---
name: new-project
description: Instructions to follow when creating a new project
---

## Trigger phrases

- "create a new project..."
- "create a new repo"

## New Project Setup

When creating ANY new project:

### Required Files
- `.env` — Environment variables (NEVER commit)
- `.env.example` — Template with placeholders
- `.gitignore` — Must include: .env, node_modules/, dist/
- `CLAUDE.md` — Project overview

### Supply Chain Attack Protection

Before installing any packages, verify these configs exist on the machine:

**`~/.npmrc`** — delays npm installs to packages at least 7 days old:
```
min-release-age=7
```

**`~/.config/uv/uv.toml`** — delays uv/pip installs to packages at least 7 days old:
```toml
exclude-newer = "7 days"
```

If missing, warn the user and suggest adding them. These settings protect against typosquatting and malicious packages published to hijack recently-unpublished names.

### Required Structure
<project directory>/
├── src/
├── tests/
├── docs/
├── .claude/skills/
└── scripts/

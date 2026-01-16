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

### Required Structure
<project directory>/
├── src/
├── tests/
├── docs/
├── .claude/skills/
└── scripts/

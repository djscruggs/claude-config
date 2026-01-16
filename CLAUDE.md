# Global Instructions for All Projects

## GitHub Account
**ALWAYS** use **djscruggs** for all projects:
- SSH: `git@github.com:djscruggs/<repo>.git`

## NEVER EVER DO

These rules are ABSOLUTE:

### NEVER Publish Sensitive Data
- NEVER publish passwords, API keys, tokens to git/npm/docker
- Before ANY commit: verify no secrets included

### NEVER Commit .env Files
- NEVER commit `.env` to git
- ALWAYS verify `.env` is in `.gitignore`

## Plan Mode
- Make the plan extremely concise. Sacrifice grammer for the sake of concision.
- At the end of each plan, give me a list of unresolved questions to answer, if any.


### Node.js Requirements
Add to entry point:
process.on('unhandledRejection', (reason, promise) => {
  console.error('Unhandled Rejection:', reason);
  process.exit(1);
});

## Docs lookup (use BLZ)

When you need documentation, prefer **BLZ** over web browsing. BLZ searches cached `llms.txt` / `llms-full.txt` sources locally and returns **ranked, line-accurate citations**.

### Setup a source (one-time)

- Add a docs corpus:
  - `blz add <name> <llms.txt|llms-full.txt URL>`
  - Example: `blz add bun https://bun.sh/llms.txt`
- Update a source when needed:
  - `blz update <name>`

### Search

- Search all sources:
  - `blz "<query>"`
- Search a specific source:
  - `blz "<query>" --source <name>`

### Cite deterministically

- When you reference results, include stable spans:
  - `blz get <source>:<start>-<end>`
- If you need fuller surrounding context:
  - add `--context all` to expand to the full section.

Tip: run `blz --help` (and `blz --prompt` for agent-specific guidance).

**Parallel Development (Git Repos Only)**:

- Use git worktrees for working on multiple branches simultaneously
- Commands: `wt-new`, `wt-cd`, `wt-ls`, `wt-rm`

---

## Project-Specific Guidelines

- When starting a React project, check the version and warn if it is unsecure. React 19.0 has a serious security risk. If your application uses React 19 with Server Components, you must update immediately to a patched version.
  For React: Upgrade to versions 19.0.1+, 19.1.2+, or 19.2.1+.
  For Next.js: Users of Next.js 15.x and 16.x (App Router) should upgrade to versions 15.0.5+ or 16.0.7+.

- Also for a React project, installs the React skills into the local .claude
`npx claude-code-templates@latest --skill=web-development/react-best-practices --yes`

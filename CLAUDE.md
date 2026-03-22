# Global Instructions for All Projects

## Vestige Memory System

At the start of every conversation, check Vestige for context:
1. Recall user preferences and instructions
2. Recall relevant project context
3. Operate in proactive memory mode - save important info without being asked

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
- Design for testability using "functional core, imperative shell": keep pure business logic separate from code that does IO.

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

## Language Preferences
- Prefer **TypeScript** over JavaScript
- Always default to TypeScript for code examples, even when the concept is language-agnostic (e.g., algorithms, data structures)

## Project-Specific Guidelines

- When starting a React project, check the version and warn if it is unsecure. React 19.0 has a serious security risk. If your application uses React 19 with Server Components, you must update immediately to a patched version.
  For React: Upgrade to versions 19.0.1+, 19.1.2+, or 19.2.1+.
  For Next.js: Users of Next.js 15.x and 16.x (App Router) should upgrade to versions 15.0.5+ or 16.0.7+.

- Also for a React project, installs the React skills into the local .claude
`npx claude-code-templates@latest --skill=web-development/react-best-practices --yes`

## Communication Preferences
- When I say "let's review X", I mean discuss/analyze X together — not run a code review tool or lint check unless I specifically ask for that.
- When I paste data and say "format this", infer the desired format from context. Don't ask for clarification on obvious formatting requests.
- When my intent is clear from context, state your assumption and proceed rather than asking for clarification.

## Workflow Rules
- After making code changes, always run the relevant type checker (`npx tsc --noEmit` for TypeScript, `mypy` for Python) before reporting the task done. Fix any errors before proceeding.
- Always guard against undefined/null before casting (e.g. `txn['confirmed-round'] ? Number(...) : null`).
- For @tanstack/react-start server functions: use `.inputValidator()` not `.validator()` (removed in v1.139+).

## Red/Green TDD (default approach for new features and bug fixes)
1. **Write failing tests first** — describe the expected behavior before writing any implementation. Run to confirm RED.
2. **Implement the minimum code** to make tests pass. Run to confirm GREEN.
3. **Refactor** if needed, keeping tests green.
4. When to skip TDD: purely cosmetic UI changes, one-off scripts, or when the cost of mocking outweighs the benefit (e.g., complex infra wiring). In those cases, write tests after to document behavior.
5. Prefer testing **pure functions and business logic** first (functional core). Test IO-heavy code (DB, network) via mocks at the boundary.
6. Test files: `src/**/__tests__/*.test.ts` for this project pattern.

## Skills

> **Note:** Some skills in `skills/` are symlinks into `~/.agents/skills/`. If the symlink targets don't exist (e.g. on a new machine), reinstall with:
> - `find-skills`: `npx skills add vercel-labs/skills@find-skills`
> - `gh-fetch`: `npx skills add retlehs/gh-fetch`
> - `thinking-partner`: `npx skills add https://github.com/mattnowdev/thinking-partner --skill thinking-partner`

### /onboard
Run at the start of any session in an unfamiliar or resumed project. Explores structure, stack, git state, and recent work, then suggests relevant skills for that repo.

**Trigger automatically when:**
- User says "let's get started", "what's the state of this project", or opens a project with no prior context in the session
- Resuming after a context reset or long gap

### /commit-push
Combined commit + type-check + push in one step. Replaces running `/commit` then `/push` separately.

**Trigger when:** user says "commit and push", "save and push", or any variant meaning both actions together.

## Environment
- Claude Code config: `~/.claude/settings.json` (not `~/.claude.json`)

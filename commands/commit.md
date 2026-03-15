---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*), Bash(git diff:*), Bash(git branch:*), Bash(git log:*), Bash(npx tsc:*), Bash(pnpm:*), Bash(npm run:*), Bash(yarn:*), Agent
description: Smart commit with triage, review agents, and generated commit message
---

# /commit — Smart Commit Pipeline

## Step 1 — Gather Context

Run these in parallel:

- Current diff: !`git diff HEAD`
- Staged files: !`git diff --cached --name-only`
- All changed files: !`git status --short`
- Current branch: !`git branch --show-current`
- Recent commits: !`git log --oneline -5`

---

## Step 2 — Review Triage

Using the changed file list from Step 1, classify this commit:

### Sensitive path check (any match → force FULL)
Check if any changed file path contains:
- `auth`, `middleware`, `migration`, `payment`, `billing`, `.env`

### Classification rules (evaluated in order):
```
1. Sensitive path hit?           → FULL
2. All files are .md/.css/.json/config only?  → NONE
3. Source files changed, <10 files?           → LIGHT
4. Source files changed, 10+ files?           → FULL
```

Display the triage result:
```
Triage: [NONE | LIGHT | FULL]
Files changed: X
Source files: Y
Reason: [brief explanation]
```

If **NONE**: skip to Step 7.
If **LIGHT** or **FULL**: continue to Step 3.

---

## Step 3 — Quality Gates (if applicable)

Check if any `.ts` or `.tsx` files changed. If so, detect the package manager and run type-check and lint in parallel:

```
Detect (check in order):
1. pnpm-lock.yaml present → use pnpm
2. yarn.lock present      → use yarn
3. package-lock.json      → use npm

Run simultaneously:
- npx tsc --noEmit          (or pnpm/yarn tsc --noEmit)
- <pkg manager> run lint    (if lint script exists in package.json)
```

If either fails: show errors, stop. Say "Fix type/lint errors, then re-run /commit."
If no `.ts`/`.tsx` files changed, or no `package.json` found: skip this step.

---

## Step 5 — Simplify + Review (Parallel)

Dispatch all agents simultaneously using the diff from Step 1.

**Always dispatch:**
- `code-simplicity-reviewer` — prompt: "Review this git diff for unnecessary complexity, redundancy, and YAGNI violations. Report findings with file and line references. Do NOT edit any files — report only."

**Always for LIGHT or FULL:**
- If any `.ts`, `.tsx`, `.js`, or `.jsx` files changed → dispatch `kieran-typescript-reviewer`

**Additional for FULL only:**
- Dispatch `security-sentinel`
- Dispatch `pattern-recognition-specialist`

Pass each agent the diff and the list of changed files.

Wait for all agents to complete.

---

## Step 4 — Synthesis

Collect all agent verdicts. Display a summary:

```
Review Results:
  code-simplicity-reviewer:   [PASS | WARN]
  kieran-typescript-reviewer: [PASS | WARN | FAIL]   (if run)
  security-sentinel:          [PASS | WARN | FAIL]   (if run)
  pattern-recognition:        [PASS | WARN | FAIL]   (if run)
```

Decision:
- `code-simplicity-reviewer` returned Medium or High findings → show findings, ask "Simplify issues found. Fix before committing? (y/n)". If yes: stop, let user fix, re-run `/commit`. If no: continue.
- Any reviewer FAIL → show findings, stop. Say "Fix the above issues, then re-run /commit."
- Any reviewer WARN → show warnings, ask "Proceed anyway? (y/n)"
- All PASS → proceed to Step 7

---

## Step 6 — Generate Commit Message

From the diff and branch name, generate a commit message following conventional commits:

Format: `type(scope): brief description`

Types: `feat`, `fix`, `refactor`, `docs`, `chore`, `style`, `test`

Rules:
- Derive scope from the primary directory or feature area changed
- Keep description under 72 characters
- Use imperative tense ("add", "fix", "update" — not "added", "fixed")
- Add a body paragraph if changes are non-obvious

Display the proposed message and ask:
```
Proposed commit message:
  feat(auth): add JWT refresh token rotation

Accept? (y), Edit? (e), Cancel? (n)
```

If edit: ask the user to provide the message.
If cancel: stop.

---

## Step 7 — Stage and Commit

1. Stage files:
   - Use `git add` with specific file paths (never `git add -A` or `git add .`)
   - Do NOT stage `.env` files under any circumstances

2. Commit:
   ```
   git commit -m "<confirmed message>"
   ```

3. Report:
   ```
   ✓ Committed
   Branch:  <branch>
   SHA:     <short sha>
   Files:   <count> changed
   ```

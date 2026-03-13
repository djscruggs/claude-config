# Commit and Push Skill

Combines commit + push into a single safe workflow. Follow steps in order.

## Step 1: Pre-flight checks

Run in parallel:
- `git status` — see what's changed and what's staged
- `git diff --cached --name-only` — check what's already staged
- `git stash list` — note any stashes

Check for dangerous files. If any of these appear in changed files, STOP immediately and warn the user:
- `.env`, `.env.*`, `*secret*`, `*password*`, `*credentials*`, `*api_key*`

## Step 2: Type check

Detect project type and run:
- TypeScript (`tsconfig.json` exists): `npx tsc --noEmit 2>&1 | head -30`
- Python (`.py` files changed): `python -m py_compile` on changed files

If check fails: stop and report — do not commit broken code.

## Step 3: Stage files

Stage only files related to the current task — never `git add -A` or `git add .`:
- Review `git status` output
- Stage by name: `git add <file1> <file2> ...`
- Never stage `.env` or secret files

## Step 4: Commit

Write a conventional commit message:
- Format: `<type>: <short imperative summary>` (under 72 chars)
- Types: `feat`, `fix`, `refactor`, `test`, `chore`, `docs`
- Focus on the "why", not the "what"

```
git commit -m "$(cat <<'EOF'
<type>: <summary>

<optional body if non-trivial>

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>
EOF
)"
```

## Step 5: Pre-push safety

Check for large files in the commit:
```
git diff HEAD~1 --name-only | xargs -I{} du -sh {} 2>/dev/null | sort -rh | head -10
```
If any file is over 1MB, warn the user before pushing.

Check for artifacts tracked by git:
```
git ls-files | grep -E "(__pycache__|\.pyc|node_modules|\.next|dist/|\.DS_Store)"
```
If found: `git rm --cached <file>`, add to `.gitignore`, amend or create a fix commit.

## Step 6: Push

```
git push -u origin <current-branch>
```

If push is rejected (non-fast-forward): report to user, do NOT force push without explicit permission.

## Step 7: Report

Output:
- Branch name and GitHub URL: `https://github.com/djscruggs/<repo>/tree/<branch>`
- Commit message summary
- Whether a PR exists: `gh pr view 2>/dev/null` (skip if gh not available)

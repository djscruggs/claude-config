# Push Skill

Follow these steps exactly before pushing to remote:

## 1. Pre-push Safety Checks

**Check for large files:**
```
git diff --cached --name-only | xargs -I{} du -sh {} 2>/dev/null | sort -rh | head -20
```
If any staged file is over 1MB, add it to `.gitignore`, unstage it, and warn the user.

**Check for sensitive/dangerous files:**
```
git diff --cached --name-only
```
- NEVER push `.env`, `.env.*`, `*secret*`, `*password*`, `*credentials*`
- If found: unstage immediately, add to `.gitignore`, and stop

**Check for unintended artifacts tracked by git:**
```
git ls-files | grep -E "(__pycache__|\.pyc|node_modules|\.next|dist/|\.DS_Store)"
```
If any match: remove from tracking with `git rm --cached`, add to `.gitignore`, commit the fix first.

## 2. Run Type Checker

Detect project type and run the appropriate check:
- TypeScript project (`tsconfig.json` exists): `npx tsc --noEmit 2>&1 | head -30`
- Python project (`*.py` files): `python -m py_compile` on recently changed files
- If checks fail: stop and report — do not push broken code

## 3. Verify Remote URL

```
git remote get-url origin
```
- If SSH (`git@github.com:...`): proceed — SSH is preferred
- If HTTPS: also fine, proceed
- If push fails due to auth: suggest switching with `git remote set-url origin https://github.com/<org>/<repo>.git`

## 4. Push

```
git push -u origin <current-branch>
```

If push fails:
- Auth error → try HTTPS remote URL
- Rejected (non-fast-forward) → report to user, do NOT force push without explicit permission
- Any other error → report the full error message

## 5. Report

After a successful push, output:
- Branch name
- GitHub URL: `https://github.com/djscruggs/<repo>/tree/<branch>`
- Summary of what was pushed (commit messages)
- Whether a PR already exists for this branch (`gh pr view` if gh is available)

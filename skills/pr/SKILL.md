# PR Skill

Follow these steps exactly to create a pull request for the current branch:

1. **Gather context** in parallel:
   - `git branch --show-current` — current branch name
   - `git log main...HEAD --oneline` — commits to include (use `origin/main` if `main` isn't local)
   - `git diff main...HEAD --stat` — files changed
   - `git status --porcelain` — ensure working tree is clean

2. **If uncommitted changes exist**, stop and tell the user to commit first (suggest `/commit`).

3. **Check if branch is pushed**:
   - `git log @{u}.. --oneline 2>/dev/null` — unpushed commits
   - If unpushed, push first: `git push -u origin HEAD`

4. **Analyze the diff** to write a meaningful PR description:
   - Read key changed files to understand *what* changed and *why*
   - Identify the type of change: feature, fix, refactor, docs, chore
   - Note any breaking changes or migration steps

5. **Create the PR** using `gh pr create`:
   ```
   gh pr create --title "<type>: <concise summary under 70 chars>" --body "$(cat <<'EOF'
   ## What
   - <bullet point summary of changes>

   ## Why
   <1-2 sentences on motivation / problem solved>

   ## Testing
   - [ ] <specific thing to verify>
   - [ ] <another thing to verify>

   🤖 Generated with [Claude Code](https://claude.ai/claude-code)
   Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>
   EOF
   )"
   ```

6. **Report** the PR URL and a one-line summary of what was opened.

If `gh` is not authenticated, tell the user to run `gh auth login` first.

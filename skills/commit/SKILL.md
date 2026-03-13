# Commit Skill

Follow these steps exactly to commit the current changes:

1. **Run tests** relevant to changed files:
   - For TypeScript/React Native: `pnpm type-check` then `pnpm lint`
   - For Python: `python -m py_compile` on changed files
   - If a test suite exists for changed files: run it

2. **If checks pass**, stage changed files by name (never `git add -A` or `git add .`):
   - Review `git status` first
   - Stage only the files related to the current task
   - Never stage `.env` files or files with secrets

3. **Write a conventional commit message**:
   - Format: `<type>: <short imperative summary>` (under 72 chars)
   - Types: `feat`, `fix`, `refactor`, `test`, `chore`, `docs`
   - Focus on the "why", not the "what"
   - Add a body if the change is non-trivial

4. **Create the commit** using a HEREDOC for the message:
   ```
   git commit -m "$(cat <<'EOF'
   <type>: <summary>

   <optional body>

   Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>
   EOF
   )"
   ```

5. **Report** what was committed and confirm `git status` is clean.

If any check fails, stop and report the failure — do not commit broken code.

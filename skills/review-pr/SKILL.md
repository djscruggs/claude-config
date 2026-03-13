# Review PR Skill

Follow these steps exactly to address open comments on a pull request:

1. **Identify the PR** to review:
   - If a PR number or URL was given as an argument, use it
   - Otherwise use the current branch: `gh pr view --json number,url,title,body`

2. **Fetch all review comments**:
   ```
   gh pr view <number> --json reviews,comments,reviewRequests,reviewComments
   ```

3. **Categorize comments** by status:
   - Unresolved / requesting changes
   - Already addressed (resolved threads)
   - Questions needing answers

4. **For each unresolved comment**:
   - Read the file and surrounding context at the line referenced
   - Understand what the reviewer is asking for
   - Make the change if it's clear and appropriate
   - If ambiguous, flag it for the user to decide

5. **After making changes**:
   - Run type checks and linting on modified files
   - Stage and commit fixes using conventional commits: `fix: address PR review feedback`
   - Push the branch

6. **Summarize** what was done:
   - List each comment addressed with a brief description of the fix
   - List any comments skipped and why (ambiguous, disagreed, already done)
   - Remind user to re-request review if all comments are resolved: `gh pr request-reviews` or resolve threads on GitHub

If no PR exists for the current branch, suggest running `/pr` first.

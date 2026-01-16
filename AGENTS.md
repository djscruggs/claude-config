# Testing

When writing and reviewing tests, refer to the principles in the [Testing Philosophy & Review Standards](testing/testing-principles.md).

# Multi-Agent Coordination & Workflow Tools

This document describes the workflow tools and coordination systems available across all projects.

---

## Table of Contents

3. [Git Worktrees](#git-worktrees) - Git Repositories Only
4. [Integration Patterns](#integration-patterns)

---

## Git Worktrees

**Applies to:** Git repositories only
**Not applicable to:** Non-git projects, single-file scripts

### When to Use

Git worktrees are for repositories where you need to work on multiple branches simultaneously.

### Repository Structure

```
~/worktrees/<repo-name>/
├── .bare/              # Git internals (shared)
├── master/             # Master branch worktree
├── feature/my-ui/      # Feature branch worktree
└── hotfix/crash-fix/   # Hotfix branch worktree
```

### Configuration

Environment variables in `~/.zshrc`:

```bash
export WORKTREE_BASE="/Users/djscruggs/worktrees"
export CROSS_REPO_BASE="/Users/djscruggs/cross-repo-tasks"
export CROSS_REPO_ARCHIVE="/Users/djscruggs/cross-repo-tasks/wt-archive"
```

### Essential Commands

```bash
# Navigate to worktree
wt-cd <repo> <branch>

# Create new feature worktree
wt-new <repo> <branch-name>

# Create worktree from existing remote branch
wt-continue <repo> <branch-name>

# List all worktrees
wt-ls <repo>

# Remove worktree (prompts to delete branch)
wt-rm <repo> <branch-name>

# Update master branch
wt-update <repo>

# Rebase current feature onto updated master
wt-rebase
```

### Workflow Examples

**Starting a New Feature:**

```bash
wt-new my-repo feature/add-notifications
cd ~/worktrees/my-repo/feature/add-notifications
npm install  # Install dependencies for this worktree
```

**Working on Multiple Features:**

```bash
# Terminal 1: Bug fix
wt-cd my-repo hotfix/crash-on-ios
npm start

# Terminal 2: Continue feature work
wt-cd my-repo feature/new-ui
# Your uncommitted changes are still here

# Terminal 3: Review a PR
wt-continue my-repo feature/colleague-pr
npm test
```

**Cleaning Up After Merge:**

```bash
wt-rm my-repo feature/completed-feature
# Prompts: "Delete remote branch? (y/n)"
```

### Integration with Git Flow

Worktrees work seamlessly with Git Flow branching:

```bash
# Navigate to master worktree
wt-cd my-repo master

# Create feature using git-flow or slash commands
/feature my-new-feature

# Create a worktree for it
wt-new my-repo feature/my-new-feature
```

### Important Notes

1. **Dependencies**: Each worktree needs its own `npm install` / dependency installation
2. **Build Artifacts**: Isolated per worktree
3. **Dev Servers**: Can run simultaneously on different ports
4. **Shared Git Objects**: All worktrees share the `.bare/` directory for efficiency

### When NOT to Use Worktrees

- Single-file scripts or non-git projects
- Projects where you only work on one branch at a time
- When simple `git checkout` is sufficient

---

## Additional Resources

- **Git Worktree Utils**: https://github.com/huntcsg/git-worktree-utils

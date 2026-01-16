#!/usr/bin/env bash
# Focus reminder - shows while Claude works

# Only trigger for "long" operations
if [[ "$CLAUDE_TOOL" =~ ^(Task|Bash|WebFetch)$ ]]; then
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "⏱️  Claude is working... Stay focused!"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "Quick wins while waiting:"

  # Show ready Beads tasks (if in a Beads repo)
  if [ -d .beads ] || [ -d ../.beads ]; then
    echo "  • bd ready --limit 3"
    bd ready --limit 3 2>/dev/null | head -6 | sed 's/^/    /'
  fi

  echo ""
  echo "  • Review recent changes: git log --oneline -3"
  echo "  • Check other repos for quick tasks"
  echo "  • Set 5-min timer and come back"
  echo ""
  echo "Full list: cat ~/.claude/WHILE_WAITING.md"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
fi

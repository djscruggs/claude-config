#!/bin/bash
# Powerline-style Claude Code statusline (JetBrains Mono Nerd Font required)

input=$(cat)

HAS_JQ=0
command -v jq >/dev/null 2>&1 && HAS_JQ=1

# Powerline separator chars (Nerd Font)
SEP_RIGHT=''   # U+E0B0 filled right arrow
SEP_THIN=''    # U+E0B1 thin right arrow

# ANSI helpers
fg()  { printf '\033[38;5;%sm' "$1"; }
bg()  { printf '\033[48;5;%sm' "$1"; }
bold(){ printf '\033[1m'; }
rst() { printf '\033[0m'; }

# Segment colors (fg, bg)
C_DIR_FG=235;   C_DIR_BG=117    # dark on sky-blue
C_GIT_FG=235;   C_GIT_BG=150    # dark on soft-green
C_MODEL_FG=235; C_MODEL_BG=147  # dark on lavender
C_CTX_FG=235;   C_CTX_BG=158    # dark on mint  (changes when low)
C_COST_FG=235;  C_COST_BG=222   # dark on gold
C_TOK_FG=235;   C_TOK_BG=189    # dark on light-lavender

# ---- Extract values ----
if [ "$HAS_JQ" -eq 1 ]; then
  current_dir=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // "unknown"' 2>/dev/null | sed "s|^$HOME|~|g")
  model_name=$(echo "$input"  | jq -r '.model.display_name // "Claude"' 2>/dev/null)
  cc_version=$(echo "$input"  | jq -r '.version // ""' 2>/dev/null)
  CONTEXT_SIZE=$(echo "$input" | jq -r '.context_window.context_window_size // 200000' 2>/dev/null)
  USAGE=$(echo "$input" | jq '.context_window.current_usage' 2>/dev/null)
  cost_usd=$(echo "$input" | jq -r '.cost.total_cost_usd // empty' 2>/dev/null)
  total_duration_ms=$(echo "$input" | jq -r '.cost.total_duration_ms // empty' 2>/dev/null)
  input_tokens=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0' 2>/dev/null)
  output_tokens=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0' 2>/dev/null)
else
  current_dir=$(echo "$input" | grep -o '"current_dir"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*"\([^"]*\)".*/\1/' | sed "s|^$HOME|~|g")
  [ -z "$current_dir" ] && current_dir="unknown"
  model_name=$(echo "$input" | grep -o '"display_name"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*"\([^"]*\)".*/\1/')
  [ -z "$model_name" ] && model_name="Claude"
  cc_version=$(echo "$input" | grep -o '"version"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"\([^"]*\)".*/\1/')
  CONTEXT_SIZE=200000; USAGE=""; cost_usd=""; total_duration_ms=""; input_tokens=0; output_tokens=0
fi

# Git branch
git_branch=""
git rev-parse --git-dir >/dev/null 2>&1 && \
  git_branch=$(git branch --show-current 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)

# Context usage %
used_pct=0
context_bar=""
context_label="Context"
C_CTX_FG=235; C_CTX_BG=28   # default: dark on green

if [ "$HAS_JQ" -eq 1 ] && [ "$USAGE" != "null" ] && [ -n "$USAGE" ]; then
  CURRENT_TOKENS=$(echo "$USAGE" | jq '(.input_tokens//0)+(.cache_creation_input_tokens//0)+(.cache_read_input_tokens//0)' 2>/dev/null)
  if [ -n "$CURRENT_TOKENS" ] && [ "$CURRENT_TOKENS" -gt 0 ] 2>/dev/null; then
    used_pct=$(( CURRENT_TOKENS * 100 / CONTEXT_SIZE ))
    (( used_pct > 100 )) && used_pct=100
    # Color thresholds on USED %
    if   [ "$used_pct" -gt 70 ]; then C_CTX_BG=160   # red
    elif [ "$used_pct" -gt 50 ]; then C_CTX_BG=136   # yellow/amber
    fi
  fi
fi

# Build 10-char progress bar using block chars
bar_filled=$(( used_pct * 10 / 100 ))
bar_empty=$(( 10 - bar_filled ))
bar_str=""
for ((i=0; i<bar_filled; i++)); do bar_str+="█"; done
for ((i=0; i<bar_empty;  i++)); do bar_str+="░"; done
context_bar="$bar_str ${used_pct}%"

# Cost / tokens
cost_str=""
if [ -n "$cost_usd" ] && [[ "$cost_usd" =~ ^[0-9.]+$ ]]; then
  cost_str="\$$(printf '%.2f' "$cost_usd")"
  if [ -n "$total_duration_ms" ] && [ "$total_duration_ms" -gt 0 ]; then
    cph=$(echo "$cost_usd $total_duration_ms" | awk '{printf "%.2f", $1*3600000/$2}')
    cost_str="$cost_str  \$${cph}/h"
  fi
fi

tok_str=""
if [ -n "$input_tokens" ] && [ -n "$output_tokens" ]; then
  tot=$(( input_tokens + output_tokens ))
  if [ "$tot" -gt 0 ]; then
    tok_str="${tot} tok"
    if [ -n "$total_duration_ms" ] && [ "$total_duration_ms" -gt 0 ]; then
      tpm=$(echo "$tot $total_duration_ms" | awk '{printf "%.0f", $1*60000/$2}')
      tok_str="$tok_str  ${tpm} tpm"
    fi
  fi
fi

# ---- Plain text item (no background) ----
plain() {
  local label="$1" color="$2"
  printf '%s%s%s' "$(fg "$color")" "$label" "$(rst)"
}

# ---- Context segment (background on bar only) ----
ctx_seg() {
  printf '%sContext  %s%s%s%s%s' "$(fg "$C_CTX_BG")" "$(rst)" "$(bg "$C_CTX_BG")" "$(fg "$C_CTX_FG")" " $context_bar " "$(rst)"
}

# ---- Line 1 ----
plain "📂  $(basename "$current_dir")" 117
[ -n "$git_branch" ] && plain "   $git_branch" 150
plain "   ★  $model_name" 147
[ -n "$cc_version" ] && [ "$cc_version" != "null" ] && plain "   v$cc_version" 249
printf '\n'

# ---- Line 2 ----
ctx_seg
[ -n "$cost_str" ] && plain "   $cost_str" 222
[ -n "$tok_str" ]  && plain "   $tok_str"  189
printf '\n'

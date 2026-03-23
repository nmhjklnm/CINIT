#!/usr/bin/env bash
# Claude Code status line script
# Displays: model, context usage, rate limits, cwd, session info, vim mode, agent, worktree

input=$(cat)

# --- Extract fields ---
model=$(echo "$input" | jq -r '.model.display_name // empty')
cwd=$(echo "$input" | jq -r '.cwd // empty')
version=$(echo "$input" | jq -r '.version // empty')
session_name=$(echo "$input" | jq -r '.session_name // empty')
output_style=$(echo "$input" | jq -r '.output_style.name // empty')

# Context window
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
remaining_pct=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')
ctx_size=$(echo "$input" | jq -r '.context_window.context_window_size // empty')
input_tokens=$(echo "$input" | jq -r '.context_window.current_usage.input_tokens // empty')

# Rate limits
five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
week_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
five_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')

# Optional fields
vim_mode=$(echo "$input" | jq -r '.vim.mode // empty')
agent_name=$(echo "$input" | jq -r '.agent.name // empty')
worktree_name=$(echo "$input" | jq -r '.worktree.name // empty')
worktree_branch=$(echo "$input" | jq -r '.worktree.branch // empty')

# --- ANSI color helpers ---
reset='\033[0m'
bold='\033[1m'
dim='\033[2m'
cyan='\033[36m'
yellow='\033[33m'
green='\033[32m'
red='\033[31m'
magenta='\033[35m'
blue='\033[34m'
white='\033[37m'

# --- Build output segments ---
parts=()

# Model
if [ -n "$model" ]; then
  parts+=("$(printf "${cyan}${bold}%s${reset}" "$model")")
fi

# Version
if [ -n "$version" ]; then
  parts+=("$(printf "${dim}v%s${reset}" "$version")")
fi

# Session name (only if set by user via /rename)
if [ -n "$session_name" ]; then
  parts+=("$(printf "${magenta}[%s]${reset}" "$session_name")")
fi

# Output style (only if not default)
if [ -n "$output_style" ] && [ "$output_style" != "default" ]; then
  parts+=("$(printf "${dim}style:%s${reset}" "$output_style")")
fi

# CWD (shorten $HOME to ~)
if [ -n "$cwd" ]; then
  home_dir="$HOME"
  short_cwd="${cwd/#$home_dir/~}"
  parts+=("$(printf "${blue}%s${reset}" "$short_cwd")")
fi

# Context window usage
if [ -n "$used_pct" ] && [ -n "$ctx_size" ]; then
  ctx_int=$(printf "%.0f" "$used_pct")
  if [ "$ctx_int" -ge 80 ]; then
    ctx_color="$red"
  elif [ "$ctx_int" -ge 50 ]; then
    ctx_color="$yellow"
  else
    ctx_color="$green"
  fi
  ctx_k=$(echo "$ctx_size" | awk '{printf "%.0fk", $1/1000}')
  ctx_str="$(printf "${ctx_color}ctx:%.0f%%%s${reset}" "$used_pct" " (${ctx_k})")"
  if [ -n "$input_tokens" ]; then
    tokens_k=$(echo "$input_tokens" | awk '{printf "%.1fk", $1/1000}')
    ctx_str="$(printf "${ctx_color}ctx:%.0f%% %s/%s${reset}" "$used_pct" "${tokens_k}" "${ctx_k}")"
  fi
  parts+=("$ctx_str")
fi

# Rate limits (Claude.ai subscription)
rate_parts=()
if [ -n "$five_pct" ]; then
  five_int=$(printf "%.0f" "$five_pct")
  if [ "$five_int" -ge 80 ]; then
    rate_color="$red"
  elif [ "$five_int" -ge 50 ]; then
    rate_color="$yellow"
  else
    rate_color="$green"
  fi
  rate_str="$(printf "${rate_color}5h:%.0f%%${reset}" "$five_pct")"
  if [ -n "$five_reset" ] && [ "$five_int" -ge 50 ]; then
    reset_min=$(( (five_reset - $(date +%s)) / 60 ))
    if [ "$reset_min" -gt 0 ]; then
      rate_str="$rate_str$(printf "${dim}(${reset_min}m)${reset}")"
    fi
  fi
  rate_parts+=("$rate_str")
fi
if [ -n "$week_pct" ]; then
  week_int=$(printf "%.0f" "$week_pct")
  if [ "$week_int" -ge 80 ]; then
    wrate_color="$red"
  elif [ "$week_int" -ge 50 ]; then
    wrate_color="$yellow"
  else
    wrate_color="$green"
  fi
  rate_parts+=("$(printf "${wrate_color}7d:%.0f%%${reset}" "$week_pct")")
fi
if [ "${#rate_parts[@]}" -gt 0 ]; then
  rate_str="${rate_parts[0]}"
  for i in "${rate_parts[@]:1}"; do rate_str="$rate_str $i"; done
  parts+=("$rate_str")
fi

# Vim mode
if [ -n "$vim_mode" ]; then
  if [ "$vim_mode" = "INSERT" ]; then
    vim_color="$green"
  else
    vim_color="$yellow"
  fi
  parts+=("$(printf "${vim_color}[%s]${reset}" "$vim_mode")")
fi

# Agent
if [ -n "$agent_name" ]; then
  parts+=("$(printf "${magenta}agent:%s${reset}" "$agent_name")")
fi

# Worktree
if [ -n "$worktree_name" ]; then
  wt_str="wt:$worktree_name"
  if [ -n "$worktree_branch" ]; then
    wt_str="$wt_str($worktree_branch)"
  fi
  parts+=("$(printf "${cyan}%s${reset}" "$wt_str")")
fi

# --- Join with separators and print ---
if [ "${#parts[@]}" -eq 0 ]; then
  printf "${dim}claude${reset}\n"
  exit 0
fi

sep="$(printf " ${dim}|${reset} ")"
result="${parts[0]}"
for part in "${parts[@]:1}"; do
  result="$result$sep$part"
done

printf "%b\n" "$result"

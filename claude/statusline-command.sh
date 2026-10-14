#!/bin/sh
# Claude Code status line — single row.
#
# Left: model name, project name, git branch/status, compact weekly (7-day)
# usage percent, separated by mid-grey bullet separators (no powerline-style
# background blocks). Right, right-aligned: the context-window usage bar
# followed by the 5-hour session usage bar, joined by the same bullet:
# "Context: [bar] x% • Session: [bar] x% resets in Xh Ym".
#
# Colors: ACC reuses THEME_ACCENT2 (~/.zsh_colors, everforest #a7c080) for
# the model-name accent, as a subtle nod to the interactive-shell theme. All
# usage bars/percentages use the same green (>=50% remaining) / yellow
# (>=20%) / red (below) headroom scheme.
#
# Known approximations / decisions (see agent summary for details):
#  - project name is basename(workspace.project_dir), falling back to
#    basename(cwd) if that field is absent.
#  - No per-model ("Fable") usage percent: the live stdin payload's
#    `rate_limits` object only ever contains `five_hour` and `seven_day`.
#  - The context bar omits token counts (used/total) to stay visually
#    consistent with the minimal, single-percentage style of the session
#    bar; only `used_percentage` is consumed even though the JSON also
#    exposes `remaining_percentage` and `context_window_size`.
#  - right-alignment assumes a UTF-8 locale (`wc -m` is used to count visible
#    columns) and that nerd-font/box-drawing glyphs render as a single
#    terminal column. Width comes from $COLUMNS, which Claude Code sets to
#    the live terminal size before every run (v2.1.153+); `tput cols` is not
#    used since the statusLine subprocess has no controlling terminal to
#    query. A small safety margin is subtracted once (`margin` below).
#  - Narrow-window degradation, in order: (1) both bars share one block
#    count and shrink together, down to 0, to stay inline with the left
#    segments; (2) if the combined right side still doesn't fit even at
#    0 width, it drops to its own right-aligned second row; (3) if it still
#    doesn't fit there even at 0 width, the context bar is dropped first,
#    leaving just the (further-shrinkable) session bar — never the other
#    way around. There is no vertical bracket alignment between the two
#    bars in this layout (that only mattered when they were on separate
#    permanent rows); each bar is simply sized to whatever the shared or
#    individual fit allows.

input=$(cat)

cwd=$(printf '%s' "$input" | jq -r '.cwd')
five_pct=$(printf '%s' "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_reset=$(printf '%s' "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
week_pct=$(printf '%s' "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
ctx_pct=$(printf '%s' "$input" | jq -r '.context_window.used_percentage // empty')

RESET='\033[0m'
FG_W='\033[97m'
FG_GREEN='\033[32m'
FG_YELLOW='\033[33m'
FG_RED='\033[31m'
FG_DIM='\033[38;5;238m'
SEP_DIM='\033[38;5;245m'
ACC='\033[38;2;167;192;128m'

model_name=$(printf '%s' "$input" | jq -r '.model.display_name // empty')
if [ -z "$model_name" ]; then
  model_name="Claude"
fi

project_dir=$(printf '%s' "$input" | jq -r '.workspace.project_dir // empty')
if [ -z "$project_dir" ]; then
  project_dir="$cwd"
fi
project_name=$(basename "$project_dir")

## Rounds a percentage to the nearest integer, clamped to [0, 100].
round_pct()
{
  awk -v u="$1" 'BEGIN{if(u<0){u=0}; if(u>100){u=100}; printf "%.0f", u}'
}

## Prints the FG_GREEN/FG_YELLOW/FG_RED color for a given "remaining
## headroom" percentage (>=50 green, >=20 yellow, else red).
color_for_remaining()
{
  r="$1"
  if [ "$r" -ge 50 ]; then
    printf '%s' "$FG_GREEN"
  elif [ "$r" -ge 20 ]; then
    printf '%s' "$FG_YELLOW"
  else
    printf '%s' "$FG_RED"
  fi
}

## Renders a "[bar] x%" fragment: $1 = block count, $2 = used percentage,
## $3 = color for the filled blocks/percentage text. The empty portion is
## always FG_DIM regardless of headroom color, for contrast.
render_bar()
{
  w="$1"
  u="$2"
  c="$3"
  f=$((w * u / 100))
  e=$((w - f))

  fs=""
  i=0
  while [ "$i" -lt "$f" ]; do
    fs="${fs}█"
    i=$((i + 1))
  done

  es=""
  i=0
  while [ "$i" -lt "$e" ]; do
    es="${es}░"
    i=$((i + 1))
  done

  printf '%s' "[${c}${fs}${FG_DIM}${es}${RESET}] ${c}${u}%${RESET}"
}

esc=$(printf '\033')
strip_ansi()
{
  printf '%s' "$1" | sed "s/${esc}\[[0-9;]*m//g"
}
vislen()
{
  strip_ansi "$1" | wc -m | tr -d ' '
}

# $COLUMNS is set by Claude Code to the live terminal width before every run
# (v2.1.153+) and is the only reliable width source here ($tput cols has no
# controlling terminal to query from the statusLine subprocess). Computed
# once and reused throughout, including by the narrow-window fallback row.
term_width="${COLUMNS:-80}"
# Measured empirically (pyte-emulated 157-column pty, Claude Code 2.1.258):
# the interface indents the status line row by 2 columns on each side, so
# usable width is COLUMNS - 4 exactly; margin=5 leaves one extra column of
# slack against off-by-one differences. Undershooting this truncates the
# line's tail into "..." instead of wrapping/degrading gracefully.
margin=5
avail=$((term_width - margin))
if [ "$avail" -lt 1 ]; then
  avail=1
fi
max_bar_blocks=20
min_bar_blocks=4
gap=1

# Bullet separator between row-1 left segments: mid-grey (245) rather than
# the very dark 238 used for the bars' unfilled blocks, so it stays legible
# without competing with the actual content.
SEP="${SEP_DIM} \342\200\242 ${RESET}"

# model + project segments, plain colored text (no background blocks).
main="${ACC}${model_name}${RESET}${SEP}${FG_W}${project_name}${RESET}"

# git branch/status segment: green when there are no uncommitted changes to
# tracked files, yellow (with a trailing "*") when there are. Untracked files
# are deliberately ignored (--porcelain -uno): build artifacts and tool
# droppings such as .claude/settings.local.json otherwise pin essentially
# every repo to "dirty", which made the color carry no information.
#
# A trailing divergence group counts commits relative to the branch's
# upstream: "\342\206\221N" for local commits not yet pushed, "\342\206\223N" for upstream
# commits not yet merged in, both together (e.g. "\342\206\2911\342\206\2232") when the branch has
# diverged. The group appears after the "*" when both are shown, is omitted
# when the branch has no upstream or HEAD is detached (nothing to compare
# against), and takes the segment's own color so "no uncommitted changes"
# still reads as an unambiguously green segment.
#
# Note that the behind count only moves after a fetch — nothing here talks to
# the remote, since a status line runs far too often to afford network I/O.
if git -C "$cwd" --no-optional-locks rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  branch=$(git -C "$cwd" --no-optional-locks branch --show-current 2>/dev/null)
  if [ -z "$branch" ]; then
    branch=$(git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
  fi

  # One rev-list call yields both sides as "<behind>\t<ahead>"; it exits
  # non-zero (leaving both empty) when there is no upstream to compare to.
  counts=$(git -C "$cwd" --no-optional-locks rev-list --left-right --count '@{upstream}...HEAD' 2>/dev/null)
  behind=$(printf '%s' "$counts" | cut -f1)
  ahead=$(printf '%s' "$counts" | cut -f2)
  syncstr=""
  if [ -n "$ahead" ] && [ "$ahead" -gt 0 ]; then
    syncstr="${syncstr}\342\206\221${ahead}"
  fi
  if [ -n "$behind" ] && [ "$behind" -gt 0 ]; then
    syncstr="${syncstr}\342\206\223${behind}"
  fi
  if [ -n "$syncstr" ]; then
    syncstr=" ${syncstr}"
  fi

  if [ -n "$(git -C "$cwd" --no-optional-locks status --porcelain -uno 2>/dev/null)" ]; then
    main="${main}${SEP}${FG_YELLOW}\356\202\240 ${branch} *${syncstr}${RESET}"
  else
    main="${main}${SEP}${FG_GREEN}\356\202\240 ${branch}${syncstr}${RESET}"
  fi
fi

# Compact weekly (7-day) usage percent, e.g. "Weekly: 5%", appended after
# whatever came before it (git segment if present, else project).
if [ -n "$week_pct" ]; then
  used_wk=$(round_pct "$week_pct")
  remaining_wk=$((100 - used_wk))
  color_wk=$(color_for_remaining "$remaining_wk")
  main="${main}${SEP}${color_wk}Weekly: ${used_wk}%${RESET}"
fi

# Render the left-hand group to real bytes (ANSI escapes + UTF-8 glyphs
# expanded) so its on-screen width can be measured for right-alignment.
rendered_main=$(printf '%b' "$main")
main_len=$(vislen "$rendered_main")

## Builds the right-side group at a given shared block count: the context
## bar (if present), a bullet separator, then the session bar (if present) —
## whichever of the two actually exist. Returns the raw (unexpanded) text.
build_right()
{
  w="$1"
  seg=""
  if [ -n "$ctx_pct" ]; then
    seg="Context: $(render_bar "$w" "$used_ctx" "$color_ctx")"
  fi
  if [ -n "$five_pct" ]; then
    sess="Session: $(render_bar "$w" "$used_5h" "$color_5h")${resetstr}"
    if [ -n "$seg" ]; then
      seg="${seg}${SEP}${sess}"
    else
      seg="$sess"
    fi
  fi
  printf '%s' "$seg"
}

num_bars=0
if [ -n "$ctx_pct" ]; then
  used_ctx=$(round_pct "$ctx_pct")
  remaining_ctx=$((100 - used_ctx))
  color_ctx=$(color_for_remaining "$remaining_ctx")
  num_bars=$((num_bars + 1))
fi
if [ -n "$five_pct" ]; then
  used_5h=$(round_pct "$five_pct")
  remaining_5h=$((100 - used_5h))
  color_5h=$(color_for_remaining "$remaining_5h")

  resetstr=""
  if [ -n "$five_reset" ]; then
    now=$(date +%s)
    resetint=$(printf '%.0f' "$five_reset")
    diff=$((resetint - now))
    if [ "$diff" -lt 0 ]; then
      diff=0
    fi
    h=$((diff / 3600))
    m=$(((diff % 3600) / 60))
    resetstr=" resets in ${h}h ${m}m"
  fi
  num_bars=$((num_bars + 1))
fi

if [ "$num_bars" -eq 0 ]; then
  printf '%s' "$rendered_main"
else
  # Fixed text shared by both bars at 0 blocks (labels, brackets, %, bullet,
  # reset time) — the block count is the only thing that varies per-bar.
  overhead0=$(vislen "$(printf '%b' "$(build_right 0)")")

  # 1) Try inline, sharing one block count between both bars, shrinking
  # together as needed to fit next to the left segments — but only down to
  # min_bar_blocks; a 0-3 block bar reads as noise, not a bar, so that case
  # is treated the same as "doesn't fit" and falls through to tier 2, where
  # the bars get a full row to themselves.
  budget=$((avail - main_len - gap - overhead0))
  w_inline=-1
  if [ "$budget" -ge 0 ]; then
    w_inline=$((budget / num_bars))
  fi
  if [ "$w_inline" -ge "$min_bar_blocks" ]; then
    w=$w_inline
    if [ "$w" -gt "$max_bar_blocks" ]; then
      w=$max_bar_blocks
    fi
    rendered_right=$(printf '%b' "$(build_right "$w")")
    right_len=$(vislen "$rendered_right")
    pad=$((avail - main_len - right_len))
    if [ "$pad" -lt 1 ]; then
      pad=1
    fi
    padding=$(printf '%*s' "$pad" '')
    printf '%s%s%s' "$rendered_main" "$padding" "$rendered_right"
  else
    # 2) Doesn't fit inline with a legible bar (or doesn't fit at all):
    # drop the whole right-side group onto its own right-aligned second
    # row, where there's a full row's width for a proper-width bar.
    budget2=$((avail - overhead0))
    if [ "$budget2" -ge 0 ]; then
      w=$((budget2 / num_bars))
      if [ "$w" -gt "$max_bar_blocks" ]; then
        w=$max_bar_blocks
      fi
      rendered_right=$(printf '%b' "$(build_right "$w")")
      right_len=$(vislen "$rendered_right")
      pad2=$((avail - right_len))
      if [ "$pad2" -lt 0 ]; then
        pad2=0
      fi
      padding2=$(printf '%*s' "$pad2" '')
      printf '%s\n%s%s' "$rendered_main" "$padding2" "$rendered_right"
    else
      # 3) Still doesn't fit on its own row even at 0 width: drop the
      # context bar first, keeping only the (further-shrinkable) session
      # bar. If there was only ever one bar to begin with, there's nothing
      # left to drop; render it at 0 width and accept a possible overflow
      # on an extremely narrow terminal.
      if [ -n "$ctx_pct" ] && [ -n "$five_pct" ]; then
        overhead_session=$(vislen "$(printf '%b' "Session: $(render_bar 0 "$used_5h" "$color_5h")${resetstr}")")
        w=$((avail - overhead_session))
        if [ "$w" -gt "$max_bar_blocks" ]; then
          w=$max_bar_blocks
        fi
        if [ "$w" -lt 0 ]; then
          w=0
        fi
        rendered_right=$(printf '%b' "Session: $(render_bar "$w" "$used_5h" "$color_5h")${resetstr}")
      else
        rendered_right=$(printf '%b' "$(build_right 0)")
      fi
      right_len=$(vislen "$rendered_right")
      pad2=$((avail - right_len))
      if [ "$pad2" -lt 0 ]; then
        pad2=0
      fi
      padding2=$(printf '%*s' "$pad2" '')
      printf '%s\n%s%s' "$rendered_main" "$padding2" "$rendered_right"
    fi
  fi
fi

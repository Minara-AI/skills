#!/usr/bin/env bash
# Minara version check — run once per session before first user request.
# Outputs: UP_TO_DATE | SNOOZED | UPGRADE cli:X->Y [skill:X->Y]
#
# This script is a pure detector. It does NOT prompt the user interactively.
# The calling agent (see SKILL.md Preamble) is responsible for presenting
# upgrade options and executing upgrades based on this output.
#
# Snooze: write a future Unix timestamp to ~/.minara/.update-snooze
#   e.g. echo "$(( $(date +%s) + 604800 ))" > ~/.minara/.update-snooze  (1 week)
# Cache reset after upgrade: rm -f ~/.minara/.last-update-check
set -euo pipefail

CHECK_FILE="$HOME/.minara/.last-update-check"
SNOOZE_FILE="$HOME/.minara/.update-snooze"
mkdir -p "$HOME/.minara"

# 1. Honor snooze (agent writes this file with a future Unix timestamp)
if [ -f "$SNOOZE_FILE" ]; then
  SNOOZE_UNTIL=$(cat "$SNOOZE_FILE" 2>/dev/null || echo 0)
  [ "$(date +%s)" -lt "$SNOOZE_UNTIL" ] && echo "SNOOZED" && exit 0
  rm -f "$SNOOZE_FILE"
fi

# 2. Honor 24h cache
if [ -f "$CHECK_FILE" ]; then
  STALE=$(find "$CHECK_FILE" -mmin +1440 2>/dev/null || true)
  if [ -z "$STALE" ]; then
    cat "$CHECK_FILE"
    exit 0
  fi
fi

# 3. Semver compare: returns 0 if $1 < $2
_semver_lt() {
  local IFS=. i a=($1) b=($2)
  for ((i=0;i<3;i++)); do
    local av="${a[i]:-0}" bv="${b[i]:-0}"
    av="${av%%[^0-9]*}"; bv="${bv%%[^0-9]*}"
    ((av < bv)) && return 0
    ((av > bv)) && return 1
  done
  return 1
}

# 4. Gather versions
CLI_LOCAL=$(minara --version 2>/dev/null | tr -d 'v[:space:]' || echo "0.0.0")
CLI_REMOTE=$(npm view minara version 2>/dev/null | tr -d '[:space:]' || echo "")

SKILL_DIR="${SKILL_DIR:-$HOME/.openclaw/skills/minara}"
SKILL_LOCAL=$(grep -m1 '^version:' "$SKILL_DIR/SKILL.md" 2>/dev/null | sed 's/^version:[[:space:]]*["'"'"']*\([^"'"'"']*\).*/\1/' || echo "0.0.0")
SKILL_REMOTE=$(curl -fsSL -m 5 "https://api.github.com/repos/Minara-AI/skills/releases/latest" 2>/dev/null | grep -o '"tag_name":[[:space:]]*"[^"]*"' | sed 's/.*"v\{0,1\}\([^"]*\)"/\1/' || echo "")

# 5. Build result (only flag upgrade when local < remote)
RESULT="UP_TO_DATE"
if [ -n "$CLI_REMOTE" ] && _semver_lt "$CLI_LOCAL" "$CLI_REMOTE"; then
  RESULT="UPGRADE cli:$CLI_LOCAL->$CLI_REMOTE"
fi
if [ -n "$SKILL_REMOTE" ] && _semver_lt "$SKILL_LOCAL" "$SKILL_REMOTE"; then
  RESULT="${RESULT/UP_TO_DATE/UPGRADE}"
  RESULT="$RESULT skill:$SKILL_LOCAL->$SKILL_REMOTE"
fi

echo "$RESULT" > "$CHECK_FILE"
echo "$RESULT"

#!/usr/bin/env bash
# Quick validation tests for Minara skills in Claude Code
# Usage: bash scripts/test-skills.sh [--live]
#   --live: run Claude Code integration tests (costs API credits)
#   default: run free structural tests only

set -euo pipefail
cd "$(dirname "$0")/.."

SKILL_DIR="skills/minara"
PASS=0
FAIL=0
SKIP=0
LIVE=false

[[ "${1:-}" == "--live" ]] && LIVE=true

pass() { ((PASS++)); echo "  ✓ $1"; }
fail() { ((FAIL++)); echo "  ✗ $1"; }
skip() { ((SKIP++)); echo "  ○ $1 (skipped)"; }

# ─── 1. Structural tests (free, no API calls) ───

echo "═══ Structural tests ═══"

echo ""
echo "--- Frontmatter validation ---"
for dir in "$SKILL_DIR"/*/; do
  skill=$(basename "$dir")
  [[ "$skill" == ".clawhub" ]] && continue
  file="$dir/SKILL.md"

  if [[ ! -f "$file" ]]; then
    fail "$skill: missing SKILL.md"
    continue
  fi

  # Check name field exists and matches directory
  name=$(grep -m1 '^name:' "$file" | sed 's/^name:[[:space:]]*//')
  if [[ -z "$name" ]]; then
    fail "$skill: missing 'name' in frontmatter"
  elif [[ "$name" != "$skill" ]]; then
    fail "$skill: name mismatch (frontmatter='$name', dir='$skill')"
  else
    pass "$skill: name matches directory"
  fi

  # Check description field exists
  desc=$(grep -m1 '^description:' "$file" | sed 's/^description:[[:space:]]*//')
  if [[ -z "$desc" ]]; then
    fail "$skill: missing 'description' in frontmatter"
  else
    pass "$skill: has description (${#desc} chars)"
  fi
done

echo ""
echo "--- Description uniqueness ---"
dupes=$(find "$SKILL_DIR" -name "SKILL.md" -exec grep -h '^description:' {} \; | sort | uniq -d)
if [[ -z "$dupes" ]]; then
  pass "all descriptions are unique"
else
  fail "duplicate descriptions found: $dupes"
fi

echo ""
echo "--- Symlink check ---"
if [[ -L "$HOME/.claude/skills/minara" ]]; then
  target=$(readlink "$HOME/.claude/skills/minara")
  pass "symlink exists → $target"
else
  fail "no symlink at ~/.claude/skills/minara"
fi

echo ""
echo "--- Version check script syntax ---"
# Extract and syntax-check the bash script from main SKILL.md
script=$(sed -n '/^```bash$/,/^```$/p' "$SKILL_DIR/SKILL.md" | sed '1d;$d')
if [[ -n "$script" ]]; then
  if echo "$script" | bash -n 2>/dev/null; then
    pass "version check script: valid bash syntax"
  else
    fail "version check script: syntax error"
  fi
else
  skip "no bash script found in main SKILL.md"
fi

echo ""
echo "--- CLI availability ---"
if command -v minara &>/dev/null; then
  ver=$(minara --version 2>/dev/null)
  pass "minara CLI installed: v$ver"
else
  fail "minara CLI not found on PATH"
fi

echo ""
echo "--- Cross-reference: intent routing coverage ---"
# Check that every sub-skill's CLI command appears in main SKILL.md intent routing
main_skill="$SKILL_DIR/SKILL.md"

while IFS='=' read -r skill cli; do
  if grep -q "$cli" "$main_skill" 2>/dev/null; then
    pass "$skill → '$cli' found in main SKILL.md"
  else
    fail "$skill → '$cli' NOT in main SKILL.md intent routing"
  fi
done <<'ROUTES'
login=minara login
logout=minara logout
swap=minara swap
deposit=minara deposit
withdraw=minara withdraw
autopilot=minara perps autopilot
search=minara discover search
fear-greed=minara discover fear-greed
btc-metrics=minara discover btc-metrics
account=minara account
assets=minara assets
premium=minara premium
limit-order=minara limit-order
close-order=minara perps close
perps=minara perps
price=minara discover search
ask=minara chat
research=minara chat --quality
ROUTES

# ─── 2. Live integration tests (costs API credits) ───

if $LIVE; then
  echo ""
  echo "═══ Live integration tests (Claude Code -p mode) ═══"
  echo "(using haiku for cost efficiency)"
  echo ""

  MODEL="haiku"
  BUDGET="0.05"

  # Test 1: Skill discovery — does Claude know about /swap?
  echo "--- Test: skill discovery ---"
  result=$(claude -p --model "$MODEL" --max-budget-usd "$BUDGET" \
    "List all available slash commands that start with /swap, /deposit, /perps, /login. Just list the names, one per line. No explanation." 2>/dev/null || echo "ERROR")
  if echo "$result" | grep -qi "swap"; then
    pass "Claude discovers /swap skill"
  else
    fail "Claude does not discover /swap skill"
  fi

  # Test 2: Intent routing — does /price map correctly?
  echo "--- Test: intent routing ---"
  result=$(claude -p --model "$MODEL" --max-budget-usd "$BUDGET" \
    "If I type /price BTC, what minara CLI command would you run? Answer with just the command, nothing else." 2>/dev/null || echo "ERROR")
  if echo "$result" | grep -qi "discover search"; then
    pass "/price routes to 'minara discover search'"
  else
    fail "/price routing: got '$result'"
  fi

  # Test 3: Confirmation flow — does /swap require confirmation?
  echo "--- Test: confirmation flow ---"
  result=$(claude -p --model "$MODEL" --max-budget-usd "$BUDGET" \
    "When executing /swap 1 ETH to USDC, should you auto-confirm or ask the user first? Answer: 'ask' or 'auto'." 2>/dev/null || echo "ERROR")
  if echo "$result" | grep -qi "ask"; then
    pass "/swap requires user confirmation"
  else
    fail "/swap confirmation check: got '$result'"
  fi
else
  echo ""
  echo "═══ Live tests skipped (run with --live to enable) ═══"
fi

# ─── Summary ───

echo ""
echo "═══════════════════════"
echo "  PASS: $PASS"
echo "  FAIL: $FAIL"
echo "  SKIP: $SKIP"
echo "═══════════════════════"

[[ $FAIL -eq 0 ]] && exit 0 || exit 1

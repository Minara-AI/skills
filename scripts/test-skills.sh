#!/usr/bin/env bash
# Validation tests for Minara skills — structural + optional live
# Usage: bash scripts/test-skills.sh [--live]
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

# ─── 1. Structural tests ───

echo "═══ Structural tests ═══"

echo ""
echo "--- Main SKILL.md ---"
if [[ -f "$SKILL_DIR/SKILL.md" ]]; then
  pass "SKILL.md exists"

  name=$(grep -m1 '^name:' "$SKILL_DIR/SKILL.md" | sed 's/^name:[[:space:]]*//')
  if [[ "$name" == "minara" ]]; then
    pass "name: $name"
  else
    fail "name mismatch: got '$name'"
  fi

  desc=$(grep -m1 '^description:' "$SKILL_DIR/SKILL.md" | sed 's/^description:[[:space:]]*//')
  if [[ -n "$desc" ]]; then
    pass "description (${#desc} chars)"
  else
    fail "missing description"
  fi

  meta_line=$(grep -c '^metadata:' "$SKILL_DIR/SKILL.md")
  if [[ "$meta_line" -eq 1 ]]; then
    pass "metadata single-line (OpenClaw compatible)"
  else
    fail "metadata format issue"
  fi
else
  fail "SKILL.md missing"
fi

echo ""
echo "--- Reference files ---"
EXPECTED_REFS="swap.md transfer.md limit-order.md perps-order.md perps-manage.md perps-wallet.md perps-autopilot.md balance.md deposit.md withdraw.md chat.md discover.md auth.md premium.md"
refs_ok=true
for ref in $EXPECTED_REFS; do
  if [[ -f "$SKILL_DIR/references/$ref" ]]; then
    lines=$(wc -l < "$SKILL_DIR/references/$ref")
    pass "$ref ($lines lines)"
  else
    fail "$ref MISSING"
    refs_ok=false
  fi
done

echo ""
echo "--- SKILL.md → references mapping ---"
ref_links=$(grep -c '{baseDir}/references/' "$SKILL_DIR/SKILL.md" 2>/dev/null || echo 0)
if [[ "$ref_links" -ge 14 ]]; then
  pass "SKILL.md has $ref_links reference links (≥14 files)"
else
  fail "SKILL.md only has $ref_links reference links (expected ≥14)"
fi

for ref in $EXPECTED_REFS; do
  if grep -q "references/$ref" "$SKILL_DIR/SKILL.md" 2>/dev/null; then
    pass "SKILL.md links to $ref"
  else
    fail "SKILL.md missing link to $ref"
  fi
done

echo ""
echo "--- Intent trigger coverage in SKILL.md ---"
EXPECTED_TRIGGERS="buy sell swap send transfer pay limit-order long short positions close cancel leverage autopilot ask research discover balance assets deposit withdraw login logout account premium"
found=0
missing=0
for trigger in $EXPECTED_TRIGGERS; do
  if grep -qi "$trigger" "$SKILL_DIR/SKILL.md" 2>/dev/null; then
    found=$((found + 1))
  else
    fail "trigger '$trigger' not in SKILL.md"
    missing=$((missing + 1))
  fi
done
if [[ $missing -eq 0 ]]; then
  pass "all $found intent triggers in SKILL.md"
fi

echo ""
echo "--- Scripts ---"
if [[ -f "$SKILL_DIR/scripts/version-check.sh" ]]; then
  if bash -n "$SKILL_DIR/scripts/version-check.sh" 2>/dev/null; then
    pass "version-check.sh: valid bash"
  else
    fail "version-check.sh: syntax error"
  fi
else
  fail "version-check.sh missing"
fi

echo ""
echo "--- Version consistency ---"
SKILL_VER=$(grep -m1 '^version:' "$SKILL_DIR/SKILL.md" | sed 's/^version:[[:space:]]*["'"'"']*\([^"'"'"']*\).*/\1/')
META_VER=$(grep -o '"version"[[:space:]]*:[[:space:]]*"[^"]*"' "$SKILL_DIR/_meta.json" 2>/dev/null | head -1 | sed 's/.*"\([0-9][^"]*\)".*/\1/')
ORIGIN_VER=$(grep -o '"installedVersion"[[:space:]]*:[[:space:]]*"[^"]*"' "$SKILL_DIR/.clawhub/origin.json" 2>/dev/null | sed 's/.*"\([0-9][^"]*\)".*/\1/')

if [[ -n "$SKILL_VER" && "$SKILL_VER" == "$META_VER" && "$SKILL_VER" == "$ORIGIN_VER" ]]; then
  pass "version consistent: $SKILL_VER"
else
  fail "version mismatch: SKILL=$SKILL_VER _meta=$META_VER origin=$ORIGIN_VER"
fi

echo ""
echo "--- Supporting files ---"
for f in examples.md setup.md; do
  if [[ -f "$SKILL_DIR/$f" ]]; then
    pass "$f exists"
  else
    fail "$f missing"
  fi
done

echo ""
echo "--- Symlink ---"
if [[ -L "$HOME/.claude/skills/minara" ]]; then
  pass "symlink → $(readlink "$HOME/.claude/skills/minara")"
else
  skip "no symlink at ~/.claude/skills/minara"
fi

echo ""
echo "--- CLI ---"
if command -v minara &>/dev/null; then
  pass "minara CLI: v$(minara --version 2>/dev/null)"
else
  fail "minara CLI not found"
fi

echo ""
echo "--- CLI commands in SKILL.md ---"
while IFS='=' read -r label cli; do
  if grep -q "$cli" "$SKILL_DIR/SKILL.md" 2>/dev/null; then
    pass "$label → '$cli'"
  else
    fail "$label → '$cli' NOT in SKILL.md"
  fi
done <<'ROUTES'
login=login --device
logout=logout
swap-buy=swap -s buy
swap-sell=swap -s sell
transfer=transfer -t
withdraw=withdraw
deposit=deposit
autopilot=perps autopilot
discover-search=discover search
discover-trending=discover trending
account=account
assets=assets spot
premium=premium
limit-order=limit-order
perps-order=perps order
perps-close=perps close
perps-cancel=perps cancel
balance=balance
ask=ask "
research=research "
ROUTES

echo ""
echo "--- New CLI features coverage ---"
if grep -q '\-S.*--side' "$SKILL_DIR/references/perps-order.md" 2>/dev/null; then
  pass "perps order: non-interactive flags (-S/--side)"
fi
if grep -q '\-\-tpsl' "$SKILL_DIR/references/perps-order.md" 2>/dev/null; then
  pass "perps order: --tpsl flag"
fi
if grep -q 'minara ask' "$SKILL_DIR/references/chat.md" 2>/dev/null; then
  pass "chat: top-level 'ask' command"
fi
if grep -q 'minara research' "$SKILL_DIR/references/chat.md" 2>/dev/null; then
  pass "chat: top-level 'research' command"
fi
if grep -q '\-\-type' "$SKILL_DIR/references/discover.md" 2>/dev/null; then
  pass "discover: --type flag for non-interactive"
fi
if grep -q '\-\-show-all' "$SKILL_DIR/references/auth.md" 2>/dev/null; then
  pass "account: --show-all flag"
fi
if grep -q 'send.*=.*transfer\|Alias.*send' "$SKILL_DIR/references/transfer.md" 2>/dev/null; then
  pass "transfer: 'send' alias"
fi

# ─── 2. Live tests ───

if $LIVE; then
  echo ""
  echo "═══ Live integration tests ═══"
  MODEL="haiku"
  BUDGET="0.05"

  result=$(claude -p --model "$MODEL" --max-budget-usd "$BUDGET" \
    "List minara slash commands for: swap, deposit, perps. Names only." 2>/dev/null || echo "ERROR")
  if echo "$result" | grep -qi "swap"; then
    pass "Claude discovers /swap"
  else
    fail "Claude: /swap not found"
  fi
else
  echo ""
  echo "═══ Live tests skipped (--live to enable) ═══"
fi

# ─── Summary ───

echo ""
echo "═══════════════════════"
echo "  PASS: $PASS"
echo "  FAIL: $FAIL"
echo "  SKIP: $SKIP"
echo "═══════════════════════"

[[ $FAIL -eq 0 ]] && exit 0 || exit 1

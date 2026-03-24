#!/usr/bin/env bash
# One-click install & update: minara-cli + minara skill for OpenClaw
# Designed to be executed by the OpenClaw agent (OpenClaw is already running).
# Usage: curl -fsSL <SCRIPT_URL> | bash

set -euo pipefail

MINARA_SKILL_REPO="${MINARA_SKILL_REPO:-https://github.com/Minara-AI/openclaw-skill.git}"
CLAWHUB_SKILL_URL="${CLAWHUB_SKILL_URL:-https://clawhub.ai/lowesyang/minara}"
OPENCLAW_DEFAULT_CONFIG_PATH="$HOME/.openclaw/openclaw.json"
CONFIG_PATH="${OPENCLAW_CONFIG_PATH:-$OPENCLAW_DEFAULT_CONFIG_PATH}"
SKILLS_DIR="${OPENCLAW_SKILLS_DIR:-$HOME/.openclaw/skills}"
WORKSPACE_DIR="${OPENCLAW_WORKSPACE:-$HOME/.openclaw/workspace}"

TMP_DIR="$(mktemp -d)"
_cleanup() {
  if [[ -n "$TMP_DIR" && -d "$TMP_DIR" ]]; then
    rm -rf "$TMP_DIR"
  fi
}
trap _cleanup EXIT

# ---------------------------------------------------------------------------
# Helper: compare semver strings (returns 0 if $1 < $2)
# ---------------------------------------------------------------------------
_semver_lt() {
  local IFS=.
  local i a=($1) b=($2)
  for ((i = 0; i < 3; i++)); do
    local av="${a[i]:-0}" bv="${b[i]:-0}"
    av="${av%%[^0-9]*}"; bv="${bv%%[^0-9]*}"
    ((av < bv)) && return 0
    ((av > bv)) && return 1
  done
  return 1
}

# ---------------------------------------------------------------------------
# Helper: fetch latest minara CLI version from npm registry
# ---------------------------------------------------------------------------
_npm_latest_version() {
  npm view minara version 2>/dev/null || echo ""
}

# ---------------------------------------------------------------------------
# Helper: download skill from ClawHub or GitHub into $TMP_DIR/minara-skill
# Returns 0 on success (files ready in $TMP_DIR/minara-skill)
# ---------------------------------------------------------------------------
_download_skill_clawhub() {
  if curl -fsSL "$CLAWHUB_SKILL_URL/archive/main.tar.gz" -o "$TMP_DIR/clawhub-minara.tar.gz" 2>/dev/null; then
    mkdir -p "$TMP_DIR/clawhub-extract"
    if tar -xzf "$TMP_DIR/clawhub-minara.tar.gz" -C "$TMP_DIR/clawhub-extract" --strip-components=1 2>/dev/null; then
      local skill_src
      skill_src=$(find "$TMP_DIR/clawhub-extract" -name "SKILL.md" -path "*/minara/*" -print -quit 2>/dev/null)
      if [[ -n "$skill_src" ]]; then
        cp -r "$(dirname "$skill_src")" "$TMP_DIR/minara-skill"
        return 0
      fi
    fi
  fi
  return 1
}

_download_skill_github() {
  git clone --depth 1 "$MINARA_SKILL_REPO" "$TMP_DIR/minara-repo" 2>/dev/null || return 1
  if [[ -d "$TMP_DIR/minara-repo/skills/minara" ]]; then
    cp -r "$TMP_DIR/minara-repo/skills/minara" "$TMP_DIR/minara-skill"
    return 0
  fi
  return 1
}

_download_skill() {
  rm -rf "$TMP_DIR/minara-skill"
  if _download_skill_clawhub; then
    echo "ClawHub"
    return 0
  fi
  if _download_skill_github; then
    echo "GitHub"
    return 0
  fi
  if command -v clawhub &>/dev/null; then
    if clawhub install lowesyang/minara --dir "$TMP_DIR/clawhub-cli-out" 2>/dev/null; then
      if [[ -d "$TMP_DIR/clawhub-cli-out/minara" ]]; then
        cp -r "$TMP_DIR/clawhub-cli-out/minara" "$TMP_DIR/minara-skill"
        echo "clawhub CLI"
        return 0
      fi
    fi
  fi
  return 1
}

# ---------------------------------------------------------------------------
# Helper: extract version from SKILL.md frontmatter (version: "X.Y.Z")
# ---------------------------------------------------------------------------
_skill_version() {
  local skill_dir="$1"
  if [[ -f "$skill_dir/SKILL.md" ]]; then
    grep -m1 '^version:' "$skill_dir/SKILL.md" 2>/dev/null | sed 's/^version:[[:space:]]*["'"'"']\{0,1\}\([^"'"'"']*\)["'"'"']\{0,1\}/\1/' || echo "0.0.0"
  else
    echo "0.0.0"
  fi
}

# ---------------------------------------------------------------------------
# Config helpers
# ---------------------------------------------------------------------------
_ensure_minara_config() {
  local config_path="$1"
  node -e '
const fs = require("fs");
const path = require("path");
const configPath = process.argv[1];
let config = {};
if (fs.existsSync(configPath)) {
  try { config = JSON.parse(fs.readFileSync(configPath, "utf8")); } catch (_) { config = {}; }
}
if (!config || typeof config !== "object" || Array.isArray(config)) config = {};
if (!config.skills || typeof config.skills !== "object" || Array.isArray(config.skills)) config.skills = {};
if (!config.skills.entries || typeof config.skills.entries !== "object" || Array.isArray(config.skills.entries)) config.skills.entries = {};
if (!config.skills.entries.minara || typeof config.skills.entries.minara !== "object" || Array.isArray(config.skills.entries.minara)) config.skills.entries.minara = {};
config.skills.entries.minara.enabled = true;
fs.mkdirSync(path.dirname(configPath), { recursive: true });
fs.writeFileSync(configPath, JSON.stringify(config, null, 2));
console.log("    Enabled minara in", configPath);
' "$config_path"
}

_resolve_config_path() {
  local config_path="$1"
  if [[ -z "$config_path" ]]; then
    echo "$OPENCLAW_DEFAULT_CONFIG_PATH"
    return
  fi
  if [[ "$config_path" == "~" ]]; then
    config_path="$HOME"
  elif [[ "$config_path" == ~/* ]]; then
    config_path="$HOME/${config_path#~/}"
  fi
  if [[ -d "$config_path" ]]; then
    echo "    Warning: OPENCLAW_CONFIG_PATH points to a directory, fallback to $OPENCLAW_DEFAULT_CONFIG_PATH" >&2
    echo "$OPENCLAW_DEFAULT_CONFIG_PATH"
    return
  fi
  echo "$config_path"
}

# ---------------------------------------------------------------------------
# Extract AGENTS.md block from setup.md (between first ``` pair under "## 1.")
# ---------------------------------------------------------------------------
_extract_agents_block() {
  local setup_file="$SKILLS_DIR/minara/setup.md"
  if [[ ! -f "$setup_file" ]]; then
    echo ""
    return
  fi
  awk '/^## 1\. AGENTS/,/^## 2\./{if(/^```$/){n++;next}; if(n==1) print}' "$setup_file"
}

# ---------------------------------------------------------------------------
# Extract MEMORY.md block from setup.md (between first ``` pair under "## 2.")
# ---------------------------------------------------------------------------
_extract_memory_block() {
  local setup_file="$SKILLS_DIR/minara/setup.md"
  if [[ ! -f "$setup_file" ]]; then
    echo ""
    return
  fi
  awk '/^## 2\. MEMORY/,0{if(/^```$/){n++;next}; if(n==1) print}' "$setup_file"
}

# ---------------------------------------------------------------------------
# Inject or update AGENTS.md
# ---------------------------------------------------------------------------
_inject_agents_prompt() {
  local agents_file="$WORKSPACE_DIR/AGENTS.md"
  mkdir -p "$WORKSPACE_DIR"

  local block
  block="$(_extract_agents_block)"
  if [[ -z "$block" ]]; then
    echo "    Warning: could not read setup.md"
    return 1
  fi

  if [[ -f "$agents_file" ]] && grep -q "## Minara" "$agents_file" 2>/dev/null; then
    local start_line next_section total_lines end_line
    start_line=$(grep -n "## Minara" "$agents_file" | head -1 | cut -d: -f1)
    total_lines=$(wc -l < "$agents_file" | tr -d ' ')
    next_section=$(tail -n +"$((start_line + 1))" "$agents_file" | grep -n "^## " | head -1 | cut -d: -f1 || true)

    if [[ -n "$next_section" ]]; then
      end_line=$((start_line + next_section - 1))
    else
      end_line=$total_lines
    fi

    local tmp_agents="$TMP_DIR/agents_new.md"
    if [[ "$start_line" -gt 1 ]]; then
      head -n "$((start_line - 1))" "$agents_file" > "$tmp_agents"
    else
      : > "$tmp_agents"
    fi
    printf '%s\n' "$block" >> "$tmp_agents"
    if [[ "$end_line" -lt "$total_lines" ]]; then
      tail -n +"$((end_line + 1))" "$agents_file" >> "$tmp_agents"
    fi
    cp "$tmp_agents" "$agents_file"
    echo "    Minara config updated"
    return 0
  fi

  if [[ -f "$agents_file" ]]; then
    printf '\n\n%s\n' "$block" >> "$agents_file"
  else
    printf '%s\n' "$block" > "$agents_file"
  fi
  echo "    Minara config applied"
}

# ===== MAIN =====

echo "==> Minara setup for OpenClaw"
echo ""

if ! command -v node &>/dev/null || ! command -v npm &>/dev/null; then
  echo "Error: node and npm are required but not found on PATH." >&2
  exit 1
fi

# ---------------------------------------------------------------------------
# Step 1: Install or update Minara CLI
# ---------------------------------------------------------------------------
echo "==> [1/6] Minara CLI..."
if command -v minara &>/dev/null; then
  CURRENT_CLI_VER=$(minara --version 2>/dev/null || echo "0.0.0")
  CURRENT_CLI_VER="${CURRENT_CLI_VER#v}"
  LATEST_CLI_VER=$(_npm_latest_version)
  LATEST_CLI_VER="${LATEST_CLI_VER#v}"

  if [[ -n "$LATEST_CLI_VER" ]] && _semver_lt "$CURRENT_CLI_VER" "$LATEST_CLI_VER"; then
    echo "    Updating CLI: $CURRENT_CLI_VER → $LATEST_CLI_VER"
    npm install -g minara@latest
    echo "    Updated to $(minara --version 2>/dev/null || echo "$LATEST_CLI_VER")"
  else
    echo "    Already up to date: $CURRENT_CLI_VER"
  fi
else
  echo "    Installing..."
  npm install -g minara@latest
  echo "    Installed: $(minara --version 2>/dev/null || echo 'done')"
fi

# ---------------------------------------------------------------------------
# Step 2: Install or update Minara skill
# ---------------------------------------------------------------------------
echo ""
echo "==> [2/6] Minara skill..."
mkdir -p "$SKILLS_DIR"

SKILL_ACTION="none"

if [[ -d "$SKILLS_DIR/minara" && -f "$SKILLS_DIR/minara/SKILL.md" ]]; then
  LOCAL_SKILL_VER=$(_skill_version "$SKILLS_DIR/minara")
  LOCAL_SKILL_VER="${LOCAL_SKILL_VER#v}"
  echo "    Existing skill found (v$LOCAL_SKILL_VER)"

  DOWNLOAD_SRC=$(_download_skill) || true
  if [[ -d "$TMP_DIR/minara-skill" ]]; then
    REMOTE_SKILL_VER=$(_skill_version "$TMP_DIR/minara-skill")
    REMOTE_SKILL_VER="${REMOTE_SKILL_VER#v}"
    if _semver_lt "$LOCAL_SKILL_VER" "$REMOTE_SKILL_VER"; then
      cp -r "$TMP_DIR/minara-skill/." "$SKILLS_DIR/minara/"
      echo "    Updated skill: v$LOCAL_SKILL_VER → v$REMOTE_SKILL_VER ($DOWNLOAD_SRC)"
      SKILL_ACTION="updated"
    else
      echo "    Skill already up to date"
      SKILL_ACTION="current"
    fi
  else
    echo "    Could not check for updates (download failed), keeping existing"
    SKILL_ACTION="current"
  fi
else
  echo "    No existing skill found, installing..."
  DOWNLOAD_SRC=$(_download_skill) || {
    echo "Error: Failed to install Minara skill from all sources" >&2
    exit 1
  }
  if [[ -d "$TMP_DIR/minara-skill" ]]; then
    cp -r "$TMP_DIR/minara-skill" "$SKILLS_DIR/minara"
    echo "    Installed from $DOWNLOAD_SRC"
    SKILL_ACTION="installed"
  else
    echo "Error: Failed to install Minara skill from all sources" >&2
    exit 1
  fi
fi

# ---------------------------------------------------------------------------
# Step 3: Enable minara in openclaw.json
# ---------------------------------------------------------------------------
echo ""
echo "==> [3/6] OpenClaw config..."
CONFIG_PATH="$(_resolve_config_path "$CONFIG_PATH")"
_ensure_minara_config "$CONFIG_PATH"

# ---------------------------------------------------------------------------
# Step 4: Workspace integration (AGENTS.md + MEMORY.md)
# ---------------------------------------------------------------------------
echo ""
echo "==> [4/6] Workspace integration..."
_inject_agents_prompt

MEMORY_FILE="$WORKSPACE_DIR/MEMORY.md"
if [[ ! -f "$MEMORY_FILE" ]] || ! grep -q "## Finance & Trading" "$MEMORY_FILE" 2>/dev/null; then
  local_mem_block="$(_extract_memory_block)"
  if [[ -n "$local_mem_block" ]]; then
    mkdir -p "$WORKSPACE_DIR"
    if [[ -f "$MEMORY_FILE" ]]; then
      printf '\n\n%s\n' "$local_mem_block" >> "$MEMORY_FILE"
    else
      printf '%s\n' "$local_mem_block" > "$MEMORY_FILE"
    fi
    echo "    User preferences saved"
  fi
fi

# ---------------------------------------------------------------------------
# Step 5: Login (skip if already logged in)
# ---------------------------------------------------------------------------
echo ""
echo "==> [5/6] Minara login..."

ALREADY_LOGGED_IN=false
if command -v minara &>/dev/null; then
  if minara whoami &>/dev/null 2>&1; then
    ALREADY_LOGGED_IN=true
    WHOAMI=$(minara whoami 2>/dev/null || echo "")
    echo "    Already logged in${WHOAMI:+ as $WHOAMI}"
  fi
fi

if [[ "$ALREADY_LOGGED_IN" == false ]]; then
  echo "    Starting device code login..."
  echo ""

  LOGIN_LOG="$TMP_DIR/minara-login.log"
  minara login --device < /dev/null > "$LOGIN_LOG" 2>&1 &
  LOGIN_PID=$!

  PRINTED_URL=false
  while kill -0 "$LOGIN_PID" 2>/dev/null; do
    if [[ -f "$LOGIN_LOG" ]] && [[ "$PRINTED_URL" == false ]]; then
      LOGIN_URL=$(grep -oE 'https?://[^ ]+' "$LOGIN_LOG" | head -1 || true)
      if [[ -n "$LOGIN_URL" ]]; then
        echo "============================================"
        echo "  Open this URL to complete login:"
        echo "  $LOGIN_URL"
        echo ""
        grep -i 'code' "$LOGIN_LOG" | head -1 | while read -r line; do echo "  $line"; done || true
        echo "============================================"
        echo ""
        echo "  Waiting for browser verification..."
        PRINTED_URL=true
      fi
    fi
    sleep 1
  done

  wait "$LOGIN_PID" 2>/dev/null
  LOGIN_EXIT=$?

  if [[ -f "$LOGIN_LOG" ]]; then
    cat "$LOGIN_LOG"
  fi

  if [[ "$LOGIN_EXIT" -ne 0 ]]; then
    echo ""
    echo "    Login failed or was cancelled. Run 'minara login' to retry."
  fi
fi

# ---------------------------------------------------------------------------
# Step 6: Claude Code slash command symlinks
# ---------------------------------------------------------------------------
echo ""
echo "==> [6/6] Claude Code shortcuts..."

CLAUDE_SKILLS_DIR="$HOME/.claude/skills"
MINARA_COMMANDS="buy sell fi-invest fi-exit send pay swap balance assets long short positions trending close-order perps-close-order fi-ask fi-research deposit receive autopilot fi-search price limit-order perps-limit-order minara-account minara-premium minara-login minara-logout minara-setup"

if [[ -d "$CLAUDE_SKILLS_DIR" ]]; then
  # Symlink main skill
  if [[ ! -L "$CLAUDE_SKILLS_DIR/minara" ]] || [[ "$(readlink "$CLAUDE_SKILLS_DIR/minara")" != "$SKILLS_DIR/minara" ]]; then
    ln -sf "$SKILLS_DIR/minara" "$CLAUDE_SKILLS_DIR/minara" 2>/dev/null || true
  fi

  # Symlink slash commands
  LINKED=0
  for cmd in $MINARA_COMMANDS; do
    if [[ -d "$SKILLS_DIR/minara/$cmd" ]]; then
      ln -sf "$SKILLS_DIR/minara/$cmd" "$CLAUDE_SKILLS_DIR/$cmd" 2>/dev/null && LINKED=$((LINKED + 1)) || true
    fi
  done

  if [[ "$LINKED" -gt 0 ]]; then
    echo "    Linked $LINKED slash commands for Claude Code"
  else
    echo "    Slash commands already linked"
  fi
else
  echo "    Claude Code not detected (no ~/.claude/skills/), skipping"
fi

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
echo ""
echo "============================================"
if [[ "$SKILL_ACTION" == "updated" ]]; then
  echo "  Minara updated successfully!"
elif [[ "$SKILL_ACTION" == "installed" ]]; then
  echo "  Minara installed successfully!"
else
  echo "  Minara is up to date!"
fi
echo "============================================"
echo ""
command -v minara &>/dev/null && echo "  CLI version: $(minara --version 2>/dev/null || echo 'ok')"
echo "  Skill version: v$(_skill_version "$SKILLS_DIR/minara")"
if [[ "$ALREADY_LOGGED_IN" == true ]] || [[ "${LOGIN_EXIT:-1}" -eq 0 ]]; then
  echo "  Logged in: yes"
fi
echo ""
echo "  You can now use Minara for crypto trading, market data,"
echo "  perpetual futures, and more. Try asking:"
echo ""
echo '  - "What are the top DeFi projects on Solana right now?"'
echo '  - "Show my portfolio"'
echo '  - "Buy 100 USDC worth of ETH"'
echo '  - "BTC just dropped 5% — should I buy the dip or wait?"'
echo ""
echo "  Quick slash commands (Claude Code):"
echo ""
echo "  /balance  /buy ETH 100  /sell SOL 10  /send 100 USDC to 0x..."
echo "  /long BTC 0.1  /short ETH 2  /positions  /close all"
echo "  /trending tokens  /fi-ask What is BTC price?"
echo ""

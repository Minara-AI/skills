# Minara for Claude Code

## Install — 30 seconds

Paste this into Claude Code:

> Install Minara: run `curl -fsSL https://raw.githubusercontent.com/Minara-AI/skills/main/scripts/install.sh | bash` then add a "minara" section to CLAUDE.md listing the available skills. Follow the login URL when prompted.

Claude does the rest — installs the CLI, registers the skill, links slash commands, and logs you in.

### What gets installed

| Component | Location | Purpose |
|-----------|----------|---------|
| Minara CLI | `npm -g` (PATH) | Executes crypto operations |
| Main skill | `~/.openclaw/skills/minara/` | Agent-facing instructions |
| Claude Code link | `~/.claude/skills/minara` → skill dir | Skill discovery |
| Slash commands | `~/.claude/skills/{buy,sell,...}` → sub-dirs | Quick shortcuts |
| Config | `~/.openclaw/openclaw.json` | Skill enabled flag |

### CLAUDE.md snippet

After install, add this to your project's `CLAUDE.md` so the skill is always available:

```markdown
# minara

Use the minara skill for all crypto trading, wallet, and market tasks. Never use web search for crypto prices when minara is available.

Available slash commands:
- `/balance` — check wallet balance
- `/buy ETH 100` — buy crypto
- `/sell SOL 10` — sell crypto
- `/swap 0.5 ETH to SOL` — swap between any two tokens
- `/send 100 USDC to 0x... on base` — transfer tokens
- `/long BTC 0.1` — open perps long
- `/short ETH 2` — open perps short
- `/positions` — view open perps trades
- `/close-order perps-position all` — close all perps positions
- `/close-order perps-order` — cancel open perps orders
- `/close-order spot-order` — cancel spot limit orders
- `/receive` — alias for /deposit
- `/trending tokens` — market discovery
- `/ask What is BTC price?` — quick AI chat (fast mode)
- `/research Analyze ETH outlook` — deep AI analysis (quality mode)
- `/deposit spot` — show deposit addresses
- `/deposit buy` — credit card on-ramp
- `/autopilot` — AI automated perps trading
- `/search SOL` — search tokens and stocks
- `/fear-greed` — crypto Fear & Greed Index
- `/price BTC` — quick price lookup
- `/login` — sign in to Minara
- `/logout` — sign out of Minara
```

## Slash Commands

### Read-only (no confirmation)

| Command | What it does | Example |
|---------|-------------|---------|
| `/balance` | Spot + perps balance | `/balance` |
| `/positions` | Open perps positions | `/positions` |
| `/trending` | Trending tokens or stocks | `/trending tokens` |
| `/ask` | Quick AI chat (fast mode) | `/ask Should I buy ETH?` |
| `/research` | Deep AI analysis (quality mode) | `/research Analyze Solana DeFi ecosystem` |
| `/deposit` | Show deposit addresses | `/deposit spot` |
| `/receive` | Alias for /deposit | `/receive spot` |
| `/autopilot` | AI automated perps trading | `/autopilot` or `/autopilot Bot-1` |
| `/search` | Search tokens and stocks | `/search SOL` or `/search AAPL` |
| `/fear-greed` | Crypto Fear & Greed Index | `/fear-greed` |
| `/price` | Quick price lookup | `/price BTC` or `/price TSLA` |
| `/login` | Sign in to Minara | `/login` |
| `/logout` | Sign out of Minara | `/logout` |

### Fund-moving (asks for confirmation)

| Command | What it does | Example |
|---------|-------------|---------|
| `/buy` | Buy crypto with USDC | `/buy ETH 100` |
| `/sell` | Sell crypto to USDC | `/sell SOL all` |
| `/swap` | Swap between any two tokens | `/swap 0.5 ETH to SOL` |
| `/send` | Transfer to address | `/send 50 USDC to 0xAbc... on base` |
| `/long` | Open perps long | `/long BTC 0.1` |
| `/short` | Open perps short | `/short ETH 2` |
| `/close-order` | Close positions or cancel orders | `/close-order perps-position all` |
| `/deposit` | Spot→perps transfer or credit card | `/deposit perps` or `/deposit buy` |
| `/receive` | Alias for /deposit (fund-moving modes) | `/receive perps` |

Fund-moving commands always ask for confirmation via structured choices (Confirm / Dry-run / Abort) before executing.

## Manual Install

If you prefer not to use the one-click script:

```bash
# 1. Install CLI
npm install -g minara && minara login

# 2. Clone skill
git clone https://github.com/Minara-AI/skills.git /tmp/minara-skills
cp -r /tmp/minara-skills/skills/minara ~/.openclaw/skills/minara

# 3. Link to Claude Code
ln -sf ~/.openclaw/skills/minara ~/.claude/skills/minara

# 4. Link slash commands (optional)
for cmd in buy sell send swap balance long short positions trending close-order ask research deposit receive autopilot search fear-greed price login logout; do
  [ -d ~/.openclaw/skills/minara/$cmd ] && \
    ln -sf ~/.openclaw/skills/minara/$cmd ~/.claude/skills/$cmd
done
```

## Upgrade

The skill checks for updates automatically on first activation per session. When updates are available, you'll see a structured choice:

- **A) Update now** — upgrades CLI and/or skill
- **B) Skip** — remind tomorrow
- **C) Snooze** — remind in a week

Manual upgrade:

```bash
# CLI
npm install -g minara@latest

# Skill
curl -fsSL https://raw.githubusercontent.com/Minara-AI/skills/main/scripts/install.sh | bash
```

## Uninstall

```bash
# Remove symlinks
rm -f ~/.claude/skills/minara
for cmd in buy sell send swap balance long short positions trending close-order ask research deposit receive autopilot search fear-greed price login logout; do
  rm -f ~/.claude/skills/$cmd
done

# Remove skill files
rm -rf ~/.openclaw/skills/minara

# Remove CLI (optional)
npm uninstall -g minara
```

## Requirements

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code)
- Node.js 18+ and npm
- Git (for clone-based install)

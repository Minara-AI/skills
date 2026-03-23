# Minara for Claude Code

## Install — 30 seconds

Open Claude Code and paste this. Claude does the rest.

> Install Minara: run `git clone https://github.com/Minara-AI/skills.git ~/.claude/skills/minara && cd ~/.claude/skills/minara && ./setup` then add a "minara" section to CLAUDE.md that says to use the minara skill for all crypto trading, wallet, and market tasks, never use web search for crypto prices when minara is available, and lists the available slash commands: /balance, /buy, /sell, /send, /long, /short, /positions, /close-order, /trending, /ask, /research, /deposit, /receive, /autopilot, /search, /fear-greed, /swap, /price, /login, /logout. Follow the login prompt when it appears.

### What gets installed

| Component | Location | Purpose |
|-----------|----------|---------|
| Minara CLI | `npm -g` (PATH) | Executes crypto operations |
| Main skill | `~/.claude/skills/minara/` | Agent-facing instructions (git repo) |
| Slash commands | `~/.claude/skills/{ask,swap,...}` → sub-dirs | Quick shortcuts (symlinks) |

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

```bash
git clone https://github.com/Minara-AI/skills.git ~/.claude/skills/minara
cd ~/.claude/skills/minara && ./setup
minara login
```

## Upgrade

The skill checks for updates automatically on first activation per session. When updates are available, you'll see a structured choice:

- **A) Update now** — upgrades CLI and/or skill
- **B) Skip** — remind tomorrow
- **C) Snooze** — remind in a week

Manual upgrade:

```bash
cd ~/.claude/skills/minara && git pull && ./setup
```

## Uninstall

```bash
# Remove sub-skill symlinks
for cmd in $(ls -la ~/.claude/skills/ | grep "minara/skills/minara" | awk '{print $9}'); do
  rm -f ~/.claude/skills/$cmd
done

# Remove skill repo
rm -rf ~/.claude/skills/minara

# Remove CLI (optional)
npm uninstall -g minara
```

## Requirements

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code)
- Node.js 18+ and npm
- Git

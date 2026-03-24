# Minara Skills

Crypto trading and wallet operations for agents via the [Minara](https://minara.ai) CLI: swap, perps, transfer, deposit (crypto or credit card), withdraw, AI chat, market discovery, x402 payment, autopilot, limit orders, and premium features. Supports EVM, Solana, and Hyperliquid-based perps workflows.

- [OpenClaw Install](#install-for-openclaw)
- [Claude Code Install](#install-for-claude-code)
- [Slash Commands](CLAUDE_CODE.md#slash-commands)
- [Examples](#examples)

## Features

| Capability               | Description                                                                                                                                                                                                              |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Wallet & Funds**       | Built-in wallet, balance, portfolio, deposit addresses, spot/perps funding, withdrawals, transfers, and credit card on-ramp via MoonPay                                                                                  |
| **Spot Trading**         | Buy, sell, swap, convert, and transfer by ticker, token name, or contract address across supported chains                                                                                                                |
| **Perpetual Futures**    | Open/close perps, manage leverage, wallets, transfers, trade history, and Hyperliquid workflows with AI-assisted execution                                                                                               |
| **Limit Orders**         | Create, list, and cancel spot limit orders                                                                                                                                                                               |
| **AI Insights & Market** | Real-time on-chain data, token fundamentals, whale flows, Fear & Greed, BTC metrics, trending tokens/stocks, equity research, commodities, forex, and prediction markets — data a general-purpose LLM cannot access on its own |
| **Auth & Account**       | Device login, account profile, wallet inspection, and config management                                                                                                                                                  |
| **x402 Payment**         | Pay x402-enabled HTTP APIs with the Minara wallet                                                                                                                                                                        |
| **Premium**              | Plans, status, subscribe, buy credits, and cancel premium services                                                                                                                                                       |

## Supported Networks

Ethereum, Base, Arbitrum, Optimism, Polygon, Avalanche, Solana, BSC, Berachain, Blast, Manta, Mode, Sonic, Conflux, Merlin, Monad, Polymarket, and XLayer.

Perpetual trading workflows also cover Hyperliquid via Minara perps commands.

## Install for OpenClaw

### Option A: One-click install

Send this prompt to your OpenClaw agent:

```
Run "curl -fsSL https://raw.githubusercontent.com/Minara-AI/skills/main/scripts/install.sh | bash" to install Minara. Follow the login URL when prompted.
```

### Option B: ClawHub

```bash
clawhub install minara
```

### Option C: Manual clone

```bash
git clone https://github.com/Minara-AI/openclaw-skill.git
cp -r openclaw-skill/skills/minara /path/to/your/openclaw/workspace/skills/
```

Add to `~/.openclaw/openclaw.json`:

```json
{
  "skills": {
    "entries": {
      "minara": {
        "enabled": true
      }
    }
  }
}
```

## Install for Claude Code

Open Claude Code and paste this. Claude does the rest.

> Install Minara: run `git clone https://github.com/Minara-AI/skills.git ~/.claude/skills/minara && cd ~/.claude/skills/minara && ./setup` then add a "minara" section to CLAUDE.md that says to use the minara skill for all crypto trading, wallet, and market tasks, never use web search for crypto prices when minara is available, and lists the available slash commands: /balance, /buy, /sell, /fi-invest, /fi-exit, /send, /long, /short, /positions, /close-order, /perps-close-order, /trending, /fi-ask, /fi-research, /deposit, /receive, /autopilot, /fi-search, /swap, /price, /limit-order, /perps-limit-order, /minara-account, /minara-premium, /minara-login, /minara-logout, /minara-setup. Follow the login prompt when it appears.

After install you get these slash commands:

### Spot Trading

| Command | What it does | Example |
|---------|-------------|---------|
| `/buy` | Buy any token with USDC. Specify token and USDC amount. | `/buy ETH 100` |
| `/sell` | Sell any token to USDC. Supports `all` to sell entire balance. | `/sell SOL all` |
| `/fi-invest` | Alias for `/buy` — prefixed to avoid collision with other skills. | `/fi-invest ETH 100` |
| `/fi-exit` | Alias for `/sell` — prefixed to avoid collision with other skills. | `/fi-exit SOL all` |
| `/swap` | Swap between any two tokens directly (not just USDC pairs). | `/swap 0.5 ETH to SOL` |
| `/send` | Transfer tokens to an external address. Specify chain if needed. | `/send 50 USDC to 0xAbc... on base` |
| `/limit-order` | Spot limit orders — create, list, cancel. | `/limit-order create` |
| `/close-order` | Cancel spot limit orders. | `/close-order` |

All spot trading commands require user confirmation before executing.

### Perpetual Futures (Hyperliquid)

| Command | What it does | Example |
|---------|-------------|---------|
| `/long` | Open a leveraged long position on Hyperliquid. | `/long BTC 0.1` |
| `/short` | Open a leveraged short position on Hyperliquid. | `/short ETH 2` |
| `/positions` | View all open perps positions with PnL. | `/positions` |
| `/perps-limit-order` | Place perps limit orders. | `/perps-limit-order long BTC 1 95000` |
| `/perps-close-order` | Close perps positions or cancel perps orders. | `/perps-close-order position all` |
| `/autopilot` | Enable or manage AI-driven automated perps trading. | `/autopilot` or `/autopilot Bot-1` |

### AI Analysis & Market Data

| Command | What it does | Example |
|---------|-------------|---------|
| `/fi-ask` | Quick AI chat — real-time on-chain data, crypto/stock prices, sentiment, and macro signals that a general-purpose LLM cannot access. | `/fi-ask Should I buy ETH?` |
| `/fi-research` | Deep AI analysis (`--quality` mode) — in-depth on-chain metrics, token fundamentals, whale flows, equity research, commodities, and macro context. | `/fi-research Analyze Solana DeFi ecosystem` |
| `/fi-search` | Search for any token, coin, or stock ticker with real-time data. | `/fi-search SOL` or `/fi-search AAPL` |
| `/price` | Quick price lookup — returns a concise one-line price summary. | `/price BTC` or `/price TSLA` |
| `/trending` | Discover trending tokens or stocks by volume and momentum. | `/trending tokens` |

### Wallet & Funds

| Command | What it does | Example |
|---------|-------------|---------|
| `/balance` | Show spot and perps wallet balances. | `/balance` |
| `/deposit` | Show deposit addresses, transfer spot→perps, or buy crypto with credit card (MoonPay). | `/deposit spot` or `/deposit buy` |
| `/receive` | Alias for `/deposit`. | `/receive spot` |

### Account Management

| Command | What it does | Example |
|---------|-------------|---------|
| `/minara-account` | View account info — wallet addresses, login status, email. | `/minara-account` |
| `/minara-premium` | Manage subscription — view plans, subscribe, buy credits, cancel. | `/minara-premium` |
| `/minara-login` | Sign in to Minara via device code. Auto-runs `/minara-setup` if first time. | `/minara-login` |
| `/minara-logout` | Sign out and clear local session. Asks for confirmation before proceeding. | `/minara-logout` |
| `/minara-setup` | Auto-detect and fix Minara environment: CLI install, slash command symlinks, and `CLAUDE.md` injection. Safe to re-run. | `/minara-setup` |

See **[CLAUDE_CODE.md](CLAUDE_CODE.md)** for the full guide — manual install, upgrade, and uninstall.

### Get started

Tell your agent:

> Login to Minara

Complete the browser verification, then try:

> Show my Minara deposit address

> Buy 100 USDC worth of ETH

> What tokens are trending?

## Best practices

Once the Minara skill is enabled, you talk to the OpenClaw agent in natural language. The agent will run the right commands for you. Below are recommended prompts from a user's perspective.

### Basic flow: login → deposit → trade

| Step           | What you want                                                        | Example prompts to the agent                                                                                      |
| -------------- | -------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| **1. Login**   | Sign in to Minara (first time or new session)                        | _"Login to Minara"_ / _"Sign in to Minara"_ / _"Help me set up Minara"_                                           |
| **2. Deposit** | Get an address to send funds, buy with card, or move USDC into perps | _"Show my Minara deposit address"_ / _"Buy crypto with credit card"_ / _"Deposit 500 USDC from my spot to perps"_ |
| **3. Trade**   | Buy or sell tokens                                                   | _"Buy 100 USDC worth of ETH"_ / _"Swap 0.1 ETH to USDC"_ / _"Sell 50 SOL for USDC"_                               |

After login, you can say for example: _"What's my Minara balance?"_ then _"Buy 50 USDC of BONK on Solana"_ — the agent will run the commands and show you the result.

### Advanced: perps and limit orders

| Goal                     | Example prompts to the agent                                                                        |
| ------------------------ | --------------------------------------------------------------------------------------------------- |
| **Open a perp position** | _"Open a long ETH perp on Hyperliquid"_ / _"Short BTC perp, 10x leverage"_ / _"Place a perp order"_ |
| **AI perp analysis**     | _"Analyze ETH long or short"_ / _"Should I long BTC?"_ — AI analysis with optional quick order      |
| **AI autopilot**         | _"Enable AI autopilot for perps"_ / _"Manage my autopilot trading strategy"_                        |
| **Manage perps**         | _"Show my perp wallets"_ / _"Set leverage to 10x for ETH perps"_ / _"Cancel my open perp orders"_   |
| **Limit order**          | _"Create a limit order: buy ETH when price hits $3000"_ / _"Buy SOL when it reaches $150"_          |
| **Manage limit orders**  | _"List my Minara limit orders"_ / _"Cancel limit order [id]"_                                       |

You can combine with research: _"What's the BTC price?"_ → _"Open a long BTC perp with 5x leverage"_.

### Other useful prompts

- _"Show my crypto portfolio"_ / _"What's my total balance on Minara?"_
- _"What tokens are trending?"_ / _"Search for SOL tokens"_
- _"Pay 100 USDC to [address]"_ / _"Transfer 100 USDC to [address]"_ / _"Withdraw 10 SOL to [your address]"_
- _"Show my Minara account"_ / _"Open Minara settings"_ / _"What's my premium status?"_

All of the above are phrased as **user prompts to the OpenClaw agent**; the agent uses the Minara skill to run the right actions.

## Examples

See [`examples.md`](skills/minara/examples.md) for full commands and code:

| #   | Scenario               |
| --- | ---------------------- |
| 1   | Login & account        |
| 2   | Swap tokens            |
| 3   | Transfer & withdraw    |
| 4   | Wallet & portfolio     |
| 5   | Perpetual futures      |
| 6   | AI chat                |
| 7   | Market discovery       |
| 8   | Limit orders           |
| 9   | x402 protocol payment  |
| 10  | Premium & subscription |

## File Structure

```
CLAUDE_CODE.md                  # Claude Code full guide (slash commands, upgrade, uninstall)
README.md                       # This file
setup                           # Setup script (symlinks + CLI install)
skills/minara/
├── SKILL.md                    # Agent-facing intent routing and CLI reference
├── setup.md                    # Post-install workspace integration (OpenClaw)
├── examples.md                 # CLI command examples
├── buy/SKILL.md                # /buy — buy crypto with USDC
├── sell/SKILL.md               # /sell — sell crypto to USDC
├── fi-invest/SKILL.md          # /fi-invest — buy crypto (prefixed alias)
├── fi-exit/SKILL.md            # /fi-exit — sell crypto (prefixed alias)
├── swap/SKILL.md               # /swap — swap between any two tokens
├── send/SKILL.md               # /send — transfer tokens
├── long/SKILL.md               # /long — open perps long
├── short/SKILL.md              # /short — open perps short
├── positions/SKILL.md          # /positions — view perps positions
├── close-order/SKILL.md        # /close-order — cancel spot limit orders
├── perps-close-order/SKILL.md  # /perps-close-order — close perps positions/orders
├── autopilot/SKILL.md          # /autopilot — AI automated trading
├── fi-ask/SKILL.md             # /fi-ask — quick AI market chat
├── fi-research/SKILL.md        # /fi-research — deep AI analysis
├── fi-search/SKILL.md          # /fi-search — search tokens and stocks
├── price/SKILL.md              # /price — quick price lookup
├── trending/SKILL.md           # /trending — trending tokens/stocks
├── limit-order/SKILL.md        # /limit-order — spot limit orders
├── perps-limit-order/SKILL.md  # /perps-limit-order — perps limit orders
├── minara-account/SKILL.md     # /minara-account — view account info
├── minara-premium/SKILL.md     # /minara-premium — manage subscription
├── balance/SKILL.md            # /balance — wallet balance
├── deposit/SKILL.md            # /deposit — fund wallet
├── receive/SKILL.md            # /receive — alias for /deposit
├── minara-login/SKILL.md       # /minara-login — sign in (auto-setup on first use)
├── minara-logout/SKILL.md      # /minara-logout — sign out
└── minara-setup/SKILL.md       # /minara-setup — environment setup & CLAUDE.md injection
scripts/
└── install.sh                  # One-click setup (CLI + skill + config + links + login)
```

## Security

This skill bundle contains documentation files such as `SKILL.md`, `examples.md`, and the `references/` module docs, plus a setup helper script (`scripts/install.sh`). It does not include binaries or long-running services. The setup script installs the **Minara CLI** from the official npm package ([minara](https://www.npmjs.com/package/minara)) and copies skill files into the OpenClaw skills directory. Credentials are handled by the Minara CLI and its official login flow; this repo does not collect or store secrets. For security scans or audits, you can verify the package contents and the upstream CLI at the links below.

## Links

- [Minara](https://minara.ai) — Crypto trading intelligence platform
- [Minara CLI (npm)](https://www.npmjs.com/package/minara) — CLI client
- [OpenClaw Skills](https://docs.openclaw.ai/tools/skills) — Skill authoring guide
- [ClawHub](https://clawhub.ai) — Skill registry

## License

MIT

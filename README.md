# Minara Skills

Turn your AI agent into a personal AI CFO. [Minara](https://minara.ai) skills give your agent the ability to analyze and trade crypto, US stocks, commodities, forex, and more. Execute on-chain transactions, manage wallets, and get real-time market intelligence across EVM, Solana, and Hyperliquid.

## Features

- **Spot Trading** -- Buy, sell, swap, convert, and transfer by ticker, token name, or contract address across supported chains.
- **Perpetual Futures** -- Open/close positions, leverage, multi-wallet management, trade history, and AI autopilot on Hyperliquid.
- **Limit Orders** -- Create, list, and cancel spot and perps limit orders.
- **Wallet & Funds** -- Built-in wallet, balance, portfolio, deposit addresses, spot/perps funding, withdrawals, transfers, and credit card on-ramp via MoonPay.
- **AI Insights & Market** -- Real-time on-chain data, token fundamentals, whale flows, trending tokens/stocks, equity research, commodities, and forex.
- **x402 Payment** -- Pay x402-enabled HTTP APIs directly from the Minara wallet.
- **Premium** -- Plans, credits, and subscription management.

## Supported Networks

Ethereum, Base, Arbitrum, Optimism, Polygon, Avalanche, Solana, BSC, Berachain, Blast, Manta, Mode, Sonic, Conflux, Merlin, Monad, Polymarket, XLayer, and Hyperliquid (perps).

## Installation

### Claude Code

Open Claude Code and paste this prompt:

> Install Minara: run `git clone https://github.com/Minara-AI/skills.git ~/.claude/skills/minara && cd ~/.claude/skills/minara && ./setup` then add a "minara" section to CLAUDE.md that says to use the minara skill for all crypto trading, wallet, and market tasks, never use web search for crypto prices when minara is available, and lists the available slash commands: /balance, /assets, /buy, /sell, /fi-invest, /fi-exit, /send, /pay, /long, /short, /positions, /close-order, /perps-close-order, /trending, /fi-ask, /fi-research, /deposit, /receive, /autopilot, /fi-search, /swap, /price, /limit-order, /perps-limit-order, /minara-account, /minara-premium, /minara-login, /minara-logout, /minara-setup. Follow the login prompt when it appears.

### OpenClaw

**One-click:** Send this to your agent:

```
Run "curl -fsSL https://raw.githubusercontent.com/Minara-AI/skills/main/scripts/install.sh | bash" to install Minara. Follow the login URL when prompted.
```

**ClawHub:**

```bash
clawhub install minara
```

**Manual:**

```bash
git clone https://github.com/Minara-AI/openclaw-skill.git
cp -r openclaw-skill/skills/minara /path/to/your/openclaw/workspace/skills/
```

## Slash Commands

### Spot Trading

| Command | What it does | Example |
|---------|-------------|---------|
| `/buy` | Buy any token with USDC | `/buy ETH 100` |
| `/sell` | Sell any token to USDC, supports `all` for entire balance | `/sell SOL all` |
| `/swap` | Swap between any two tokens | `/swap 0.5 ETH to SOL` |
| `/send` | Transfer tokens to an external address | `/send 50 USDC to 0xAbc... on base` |
| `/pay` | Pay with USDC, just provide address and amount | `/pay 100 0xAbc...` |
| `/limit-order` | Create, list, cancel spot limit orders | `/limit-order create` |
| `/close-order` | Cancel spot limit orders | `/close-order` |
| `/fi-invest` | Same as `/buy`, prefixed to avoid collision | `/fi-invest ETH 100` |
| `/fi-exit` | Same as `/sell`, prefixed to avoid collision | `/fi-exit SOL all` |

All spot trading commands require user confirmation before executing.

### Perpetual Futures

| Command | What it does | Example |
|---------|-------------|---------|
| `/long` | Open a leveraged long position | `/long BTC 0.1` |
| `/short` | Open a leveraged short position | `/short ETH 2` |
| `/positions` | View open perps positions with PnL | `/positions` |
| `/perps-limit-order` | Place perps limit orders | `/perps-limit-order long BTC 1 95000` |
| `/perps-close-order` | Close perps positions or cancel perps orders | `/perps-close-order position all` |
| `/autopilot` | Enable or manage AI automated perps trading | `/autopilot` or `/autopilot Bot-1` |

### AI Analysis & Market Data

| Command | What it does | Example |
|---------|-------------|---------|
| `/fi-ask` | Quick AI chat with real-time on-chain data, prices, sentiment | `/fi-ask Should I buy ETH?` |
| `/fi-research` | In-depth AI analysis with on-chain metrics and fundamentals | `/fi-research Analyze Solana DeFi ecosystem` |
| `/fi-search` | Search for any token, coin, or stock ticker | `/fi-search SOL` or `/fi-search AAPL` |
| `/price` | Quick price lookup | `/price BTC` or `/price TSLA` |
| `/trending` | Trending tokens or stocks by volume and momentum | `/trending tokens` |

### Wallet & Funds

| Command | What it does | Example |
|---------|-------------|---------|
| `/balance` | Show spot and perps wallet balances | `/balance` |
| `/assets` | View spot token holdings across chains | `/assets` |
| `/deposit` | Show deposit addresses, spot to perps transfer, or credit card buy | `/deposit spot` or `/deposit buy` |
| `/receive` | Same as `/deposit` | `/receive spot` |

### Account

| Command | What it does | Example |
|---------|-------------|---------|
| `/minara-account` | View wallet addresses, login status, email | `/minara-account` |
| `/minara-premium` | View plans, subscribe, buy credits, cancel | `/minara-premium` |
| `/minara-login` | Sign in via device code | `/minara-login` |
| `/minara-logout` | Sign out and clear local session | `/minara-logout` |
| `/minara-setup` | Auto-detect and fix Minara environment | `/minara-setup` |

See [CLAUDE_CODE.md](CLAUDE_CODE.md) for manual install, upgrade, and uninstall.

## Quick Start

```
> Login to Minara
> Show my Minara deposit address
> Buy 100 USDC worth of ETH
> What tokens are trending?
```

## Usage

Talk to the agent in natural language. It runs the right commands for you.

### Basic flow

| Step | Example prompts |
|------|----------------|
| **Login** | _"Login to Minara"_ |
| **Deposit** | _"Show my deposit address"_ / _"Buy crypto with credit card"_ / _"Deposit 500 USDC to perps"_ |
| **Trade** | _"Buy 100 USDC worth of ETH"_ / _"Swap 0.1 ETH to USDC"_ / _"Sell all SOL"_ |

### Perps and limit orders

| Goal | Example prompts |
|------|----------------|
| **Open position** | _"Long ETH perp"_ / _"Short BTC, 10x leverage"_ |
| **AI analysis** | _"Analyze ETH long or short"_ / _"Should I long BTC?"_ |
| **Autopilot** | _"Enable AI autopilot for perps"_ |
| **Limit order** | _"Buy ETH when price hits $3000"_ / _"Buy SOL at $150"_ |
| **Manage orders** | _"List my limit orders"_ / _"Cancel limit order [id]"_ |

### More examples

- _"Show my crypto portfolio"_ / _"What's my balance?"_
- _"What tokens are trending?"_ / _"Search for SOL tokens"_
- _"Pay 100 USDC to [address]"_ / _"Withdraw 10 SOL to [address]"_

See [examples.md](skills/minara/examples.md) for full CLI examples.

## Security

This repo contains documentation files and a setup script. No binaries or long-running services. The setup script installs the [Minara CLI](https://www.npmjs.com/package/minara) from npm and copies skill files into the skills directory. Credentials are handled by the CLI's official login flow; this repo does not collect or store secrets.

## Links

- [Minara](https://minara.ai)
- [Minara CLI (npm)](https://www.npmjs.com/package/minara)
- [OpenClaw Skills](https://docs.openclaw.ai/tools/skills)
- [ClawHub](https://clawhub.ai)

## License

MIT

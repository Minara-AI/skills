# Minara Skills

Crypto trading and wallet operations for agents via the [Minara](https://minara.ai) CLI. Swap, perps, transfer, deposit (crypto or credit card), withdraw, AI chat, market discovery, x402 payment, autopilot, limit orders, and premium. Supports EVM, Solana, and Hyperliquid perps.

- [OpenClaw Install](#install-for-openclaw)
- [Claude Code Install](#install-for-claude-code)
- [Slash Commands](CLAUDE_CODE.md#slash-commands)
- [Examples](#examples)

## Features


| Capability               | Description                                                                                                                          |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------ |
| **Wallet & Funds**       | Built-in wallet, balance, portfolio, deposit addresses, spot/perps funding, withdrawals, transfers, credit card on-ramp via MoonPay   |
| **Spot Trading**         | Buy, sell, swap, convert, transfer by ticker, token name, or contract address across supported chains                                 |
| **Perpetual Futures**    | Open/close perps, leverage, wallets, transfers, trade history, Hyperliquid workflows with AI-assisted execution                       |
| **Limit Orders**         | Create, list, cancel spot and perps limit orders                                                                                      |
| **AI Insights & Market** | Real-time on-chain data, token fundamentals, whale flows, trending tokens/stocks, equity research, commodities, forex                 |
| **Auth & Account**       | Device login, account profile, wallet inspection, config management                                                                   |
| **x402 Payment**         | Pay x402-enabled HTTP APIs with the Minara wallet                                                                                     |
| **Premium**              | Plans, status, subscribe, buy credits, cancel                                                                                         |


## Supported Networks

Ethereum, Base, Arbitrum, Optimism, Polygon, Avalanche, Solana, BSC, Berachain, Blast, Manta, Mode, Sonic, Conflux, Merlin, Monad, Polymarket, and XLayer.

Perpetual trading also covers Hyperliquid via Minara perps commands.

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

> Install Minara: run `git clone https://github.com/Minara-AI/skills.git ~/.claude/skills/minara && cd ~/.claude/skills/minara && ./setup` then add a "minara" section to CLAUDE.md that says to use the minara skill for all crypto trading, wallet, and market tasks, never use web search for crypto prices when minara is available, and lists the available slash commands: /balance, /assets, /buy, /sell, /fi-invest, /fi-exit, /send, /pay, /long, /short, /positions, /close-order, /perps-close-order, /trending, /fi-ask, /fi-research, /deposit, /receive, /autopilot, /fi-search, /swap, /price, /limit-order, /perps-limit-order, /minara-account, /minara-premium, /minara-login, /minara-logout, /minara-setup. Follow the login prompt when it appears.

After install you get these slash commands:

### Spot Trading


| Command        | What it does                                              | Example                             |
| -------------- | --------------------------------------------------------- | ----------------------------------- |
| `/buy`         | Buy any token with USDC                                   | `/buy ETH 100`                      |
| `/sell`        | Sell any token to USDC, supports `all` for entire balance | `/sell SOL all`                     |
| `/fi-invest`   | Same as `/buy`, prefixed to avoid collision                | `/fi-invest ETH 100`                |
| `/fi-exit`     | Same as `/sell`, prefixed to avoid collision               | `/fi-exit SOL all`                  |
| `/swap`        | Swap between any two tokens directly                      | `/swap 0.5 ETH to SOL`              |
| `/send`        | Transfer tokens to an external address                    | `/send 50 USDC to 0xAbc... on base` |
| `/pay`         | Pay with USDC, just provide address and amount            | `/pay 100 0xAbc...`                 |
| `/limit-order` | Create, list, cancel spot limit orders                    | `/limit-order create`               |
| `/close-order` | Cancel spot limit orders                                  | `/close-order`                      |


All spot trading commands require user confirmation before executing.

### Perpetual Futures


| Command              | What it does                                  | Example                               |
| -------------------- | --------------------------------------------- | ------------------------------------- |
| `/long`              | Open a leveraged long position                | `/long BTC 0.1`                       |
| `/short`             | Open a leveraged short position               | `/short ETH 2`                        |
| `/positions`         | View all open perps positions with PnL        | `/positions`                          |
| `/perps-limit-order` | Place perps limit orders                      | `/perps-limit-order long BTC 1 95000` |
| `/perps-close-order` | Close perps positions or cancel perps orders  | `/perps-close-order position all`     |
| `/autopilot`         | Enable or manage AI automated perps trading   | `/autopilot` or `/autopilot Bot-1`    |


### AI Analysis & Market Data


| Command        | What it does                                                                              | Example                                      |
| -------------- | ----------------------------------------------------------------------------------------- | -------------------------------------------- |
| `/fi-ask`      | Quick AI chat with real-time on-chain data, crypto/stock prices, sentiment, macro signals | `/fi-ask Should I buy ETH?`                  |
| `/fi-research` | In-depth AI analysis: on-chain metrics, token fundamentals, whale flows, equity research  | `/fi-research Analyze Solana DeFi ecosystem` |
| `/fi-search`   | Search for any token, coin, or stock ticker                                               | `/fi-search SOL` or `/fi-search AAPL`        |
| `/price`       | Quick price lookup                                                                        | `/price BTC` or `/price TSLA`                |
| `/trending`    | Trending tokens or stocks by volume and momentum                                          | `/trending tokens`                           |


### Wallet & Funds


| Command    | What it does                                                     | Example                           |
| ---------- | ---------------------------------------------------------------- | --------------------------------- |
| `/balance` | Show spot and perps wallet balances                              | `/balance`                        |
| `/assets`  | View spot token holdings across chains                           | `/assets`                         |
| `/deposit` | Show deposit addresses, spot→perps transfer, or credit card buy  | `/deposit spot` or `/deposit buy` |
| `/receive` | Same as `/deposit`                                               | `/receive spot`                   |


### Account Management


| Command           | What it does                                                          | Example           |
| ----------------- | --------------------------------------------------------------------- | ----------------- |
| `/minara-account` | View account info: wallet addresses, login status, email              | `/minara-account` |
| `/minara-premium` | Manage subscription: view plans, subscribe, buy credits, cancel       | `/minara-premium` |
| `/minara-login`   | Sign in to Minara via device code, auto-runs setup if first time      | `/minara-login`   |
| `/minara-logout`  | Sign out and clear local session                                      | `/minara-logout`  |
| `/minara-setup`   | Auto-detect and fix Minara environment: CLI, symlinks, CLAUDE.md      | `/minara-setup`   |


See **[CLAUDE_CODE.md](CLAUDE_CODE.md)** for manual install, upgrade, and uninstall.

### Get started

Tell your agent:

> Login to Minara

Complete the browser verification, then try:

> Show my Minara deposit address

> Buy 100 USDC worth of ETH

> What tokens are trending?

## Best practices

Once the Minara skill is enabled, you talk to the agent in natural language. The agent will run the right commands for you. Below are recommended prompts.

### Basic flow: login → deposit → trade


| Step           | What you want                                                  | Example prompts                                                                                           |
| -------------- | -------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------- |
| **1. Login**   | Sign in to Minara (first time or new session)                  | *"Login to Minara"* / *"Sign in to Minara"* / *"Help me set up Minara"*                                   |
| **2. Deposit** | Get an address to send funds, buy with card, or fund perps     | *"Show my Minara deposit address"* / *"Buy crypto with credit card"* / *"Deposit 500 USDC to perps"*      |
| **3. Trade**   | Buy or sell tokens                                             | *"Buy 100 USDC worth of ETH"* / *"Swap 0.1 ETH to USDC"* / *"Sell 50 SOL for USDC"*                      |


After login, you can say *"What's my Minara balance?"* then *"Buy 50 USDC of BONK on Solana"*.

### Advanced: perps and limit orders


| Goal                     | Example prompts                                                                             |
| ------------------------ | ------------------------------------------------------------------------------------------- |
| **Open a perp position** | *"Open a long ETH perp"* / *"Short BTC perp, 10x leverage"* / *"Place a perp order"*        |
| **AI perp analysis**     | *"Analyze ETH long or short"* / *"Should I long BTC?"*                                      |
| **AI autopilot**         | *"Enable AI autopilot for perps"* / *"Manage my autopilot trading strategy"*                 |
| **Manage perps**         | *"Show my perp wallets"* / *"Set leverage to 10x for ETH perps"* / *"Cancel my perp orders"* |
| **Limit order**          | *"Create a limit order: buy ETH when price hits $3000"* / *"Buy SOL when it reaches $150"*   |
| **Manage limit orders**  | *"List my Minara limit orders"* / *"Cancel limit order [id]"*                                |


You can combine with research: *"What's the BTC price?"* then *"Open a long BTC perp with 5x leverage"*.

### Other useful prompts

- *"Show my crypto portfolio"* / *"What's my total balance on Minara?"*
- *"What tokens are trending?"* / *"Search for SOL tokens"*
- *"Pay 100 USDC to [address]"* / *"Transfer 100 USDC to [address]"* / *"Withdraw 10 SOL to [your address]"*
- *"Show my Minara account"* / *"What's my premium status?"*

## Examples

See [examples.md](skills/minara/examples.md) for full commands and code:


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
├── buy/SKILL.md                # /buy
├── sell/SKILL.md               # /sell
├── fi-invest/SKILL.md          # /fi-invest (alias for /buy)
├── fi-exit/SKILL.md            # /fi-exit (alias for /sell)
├── swap/SKILL.md               # /swap
├── send/SKILL.md               # /send
├── pay/SKILL.md                # /pay
├── long/SKILL.md               # /long
├── short/SKILL.md              # /short
├── positions/SKILL.md          # /positions
├── close-order/SKILL.md        # /close-order
├── perps-close-order/SKILL.md  # /perps-close-order
├── autopilot/SKILL.md          # /autopilot
├── fi-ask/SKILL.md             # /fi-ask
├── fi-research/SKILL.md        # /fi-research
├── fi-search/SKILL.md          # /fi-search
├── price/SKILL.md              # /price
├── trending/SKILL.md           # /trending
├── limit-order/SKILL.md        # /limit-order
├── perps-limit-order/SKILL.md  # /perps-limit-order
├── minara-account/SKILL.md     # /minara-account
├── minara-premium/SKILL.md     # /minara-premium
├── balance/SKILL.md            # /balance
├── assets/SKILL.md             # /assets
├── deposit/SKILL.md            # /deposit
├── receive/SKILL.md            # /receive (alias for /deposit)
├── minara-login/SKILL.md       # /minara-login
├── minara-logout/SKILL.md      # /minara-logout
└── minara-setup/SKILL.md       # /minara-setup
scripts/
└── install.sh                  # One-click setup (CLI + skill + config + links + login)
```

## Security

This skill bundle contains documentation files (`SKILL.md`, `examples.md`) plus a setup helper script (`scripts/install.sh`). It does not include binaries or long-running services. The setup script installs the **Minara CLI** from the official npm package ([minara](https://www.npmjs.com/package/minara)) and copies skill files into the skills directory. Credentials are handled by the Minara CLI and its official login flow; this repo does not collect or store secrets.

## Links

- [Minara](https://minara.ai)
- [Minara CLI (npm)](https://www.npmjs.com/package/minara)
- [OpenClaw Skills](https://docs.openclaw.ai/tools/skills)
- [ClawHub](https://clawhub.ai)

## License

MIT

# Minara Skills v2.6

Crypto trading and wallet operations for agents via the [Minara](https://minara.ai) CLI: swap, perps, transfer, deposit (crypto or credit card), withdraw, AI chat, market discovery, x402 payment, autopilot, limit orders, and premium features. Supports EVM, Solana, and Hyperliquid-based perps workflows.

## Features

| Capability                 | Description                                                                                                                                            |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Wallet & Funds**         | Built-in wallet, balance, portfolio, deposit addresses, spot/perps funding, withdrawals, transfers, and credit card on-ramp via MoonPay              |
| **Spot Trading**           | Buy, sell, swap, convert, and transfer by ticker, token name, or contract address across supported chains                                              |
| **Perpetual Futures**      | Open/close perps, manage leverage, wallets, transfers, trade history, and Hyperliquid workflows with AI-assisted execution                             |
| **Limit Orders**           | Create, list, and cancel spot limit orders                                                                                                             |
| **AI Insights & Market**   | AI chat for price and market outlook, trending tokens/stocks, token search, Fear & Greed, BTC metrics, and broader research                          |
| **Auth & Account**         | Device login, account profile, wallet inspection, and config management                                                                                |
| **x402 Payment**           | Pay x402-enabled HTTP APIs with the Minara wallet                                                                                                      |
| **Premium**                | Plans, status, subscribe, buy credits, and cancel premium services                                                                                     |

## Supported Networks

Ethereum, Base, Arbitrum, Optimism, Polygon, Avalanche, Solana, BSC, Berachain, Blast, Manta, Mode, Sonic, Conflux, Merlin, Monad, Polymarket, and XLayer.

Perpetual trading workflows also cover Hyperliquid via Minara perps commands.

## Quick Start

### One-click install (Recommended)

Send this prompt to your agent:

```
Run "curl -fsSL https://raw.githubusercontent.com/Minara-AI/skills/main/scripts/install.sh | bash" to install Minara. Follow the login URL when prompted.
```

### Install as OpenClaw skill only

```bash
clawhub install minara
```

Or clone manually:

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

### Use with OpenClaw cloud bots

[KimiClaw](https://www.kimi.com/bot), [MaxClaw](https://agent.minimax.io/), and [Manus](https://manus.im) are cloud-hosted AI agents with ClawHub / Agent Skills support. Tell your cloud agent:

> Install the minara skill from https://clawhub.com/skills/minara

Or search and install from the skill library UI. The skill is available on [ClawHub](https://clawhub.ai) as `minara`. Once installed, the agent can run all Minara commands — no local CLI setup needed on cloud bots.

| Cloud bot    | Platform                                      | How to install skill                                                            |
| ------------ | --------------------------------------------- | ------------------------------------------------------------------------------- |
| **KimiClaw** | [kimi.com/bot](https://www.kimi.com/bot)      | Skill Library → search "minara" → install, or ask the agent                     |
| **MaxClaw**  | [agent.minimax.io](https://agent.minimax.io/) | Ask the agent to install minara from ClawHub                                    |
| **Manus**    | [manus.im](https://manus.im)                  | Skills tab → + Add → Import from GitHub → `https://github.com/Minara-AI/skills` |

### Use with other AI clients

The Minara skill also works with any AI client that supports custom instructions or tool use. Install the CLI first:

```bash
npm install -g minara && minara login
```

Then add the skill to your AI client:

| Client             | How to add                                                                                 |
| ------------------ | ------------------------------------------------------------------------------------------ |
| **Claude Desktop** | Settings → Projects → create a project → add `skills/minara/SKILL.md` as project knowledge |
| **Claude Code**    | Copy `SKILL.md` to your project's `.claude/` directory or add it via `/add-file`           |
| **Cursor**         | Copy `SKILL.md` to `.cursor/rules/minara.md` in your workspace                             |
| **ChatGPT**        | Create a GPT → paste the contents of `SKILL.md` into the Instructions field                |
| **Windsurf**       | Copy `SKILL.md` to `.windsurfrules/minara.md` in your workspace                            |

The agent reads the skill instructions and can then run Minara CLI commands on your behalf when you ask about crypto trading, wallet operations, account actions, premium operations, or market analysis.

### Get started

Tell the OpenClaw agent:

> Login to Minara

Complete the browser verification, then:

> Show my Minara deposit address

> Buy 100 USDC worth of ETH

> What tokens are trending?

> Show my premium status

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
skills/minara/
├── SKILL.md          # Agent-facing intent routing and CLI reference
├── setup.md          # Post-install workspace integration (AGENTS.md + MEMORY.md)
├── examples.md       # CLI command examples for each scenario
└── references/       # Detailed module references (wallet, spot, perps, AI, auth, premium)
scripts/
└── install.sh        # One-click setup script (minara-cli + skill + config + login)
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

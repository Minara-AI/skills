# Minara Skills

The ultimate and all-in-one digital finance solution designed for agents: built-in crypto wallet, assets management, transfers, trading crypto & stock, and institution-grade real-time market insights. Powered by [Minara](https://minara.ai).

## Features

| Capability                 | Description                                                                                                           |
| -------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| **Built-in Wallet**        | No seed phrase, no private key — sign up with email and get a ready-to-use wallet; unified balance with real-time PnL; credit card on-ramp via MoonPay |
| **Spot Trading**           | Swaps by ticker, name, or contract address; transfers and withdrawals across chains; sell-all support                 |
| **Perpetual Futures**      | Orders, positions, leverage, TP/SL on Hyperliquid; AI autopilot strategy; AI analysis with quick order                |
| **Limit Orders**           | Price-triggered limit orders with expiry                                                                              |
| **AI Insights & Research** | Crypto & stock analysis and on-chain research; trending tokens & stocks, Fear & Greed, BTC metrics                    |
| **Chain Abstraction**      | One flow across EVM and Solana — chain auto-detected from token, no manual selection                                  |
| **Gasless**                | Gasless transactions where supported — no gas tokens needed                                                           |

## Supported Chains

Ethereum, Base, Arbitrum, Optimism, Polygon, Avalanche, BNB Chain, Solana, Berachain, Blast, Manta, Mode, Sonic.

## Quick Start

```bash
# 1. Install the CLI
npm install -g minara

# 2. Login
minara login

# 3. Start using
minara account                                    # View wallet addresses
minara balance                                    # Quick total balance
minara deposit spot                               # Show spot deposit addresses
minara chat "BTC price?"                          # Ask the AI
minara swap -s buy -t '$BONK' -a 100             # Swap tokens (chain auto-detected)
minara discover trending                          # Trending tokens
```

### With OpenClaw skill system

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

Then run `minara login` once.

## Best practices

Once the Minara skill is enabled, you talk to the OpenClaw agent in natural language. The agent will run the right commands for you. Below are recommended prompts from a user's perspective.

### Basic flow: login → deposit → trade

| Step           | What you want                                         | Example prompts to the agent                                                                                                              |
| -------------- | ----------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| **1. Login**   | Sign in to Minara (first time or new session)         | _"Login to Minara"_ / _"Sign in to Minara"_ / _"Help me set up Minara"_                                                                   |
| **2. Deposit** | Get an address to send funds, buy with card, or move USDC into perps | _"Show my Minara deposit address"_ / _"Buy crypto with credit card"_ / _"Deposit 500 USDC from my spot to perps"_ |
| **3. Trade**   | Buy or sell tokens                                    | _"Buy 100 USDC worth of ETH"_ / _"Swap 0.1 ETH to USDC"_ / _"Sell 50 SOL for USDC"_                                                       |

After login, you can say for example: _"What's my Minara balance?"_ then _"Buy 50 USDC of BONK on Solana"_ — the agent will run the commands and show you the result.

### Advanced: perps and limit orders

| Goal                     | Example prompts to the agent                                                                        |
| ------------------------ | --------------------------------------------------------------------------------------------------- |
| **Open a perp position** | _"Open a long ETH perp on Hyperliquid"_ / _"Short BTC perp, 10x leverage"_ / _"Place a perp order"_ |
| **AI perp analysis**     | _"Analyze ETH long or short"_ / _"Should I long BTC?"_ — AI analysis with optional quick order       |
| **AI autopilot**         | _"Enable AI autopilot for perps"_ / _"Manage my autopilot trading strategy"_                         |
| **Manage perps**         | _"Show my perp positions"_ / _"Set leverage to 10x for ETH perps"_ / _"Cancel my open perp orders"_ |
| **Limit order**          | _"Create a limit order: buy ETH when price hits $3000"_ / _"Buy SOL when it reaches $150"_          |
| **Manage limit orders**  | _"List my Minara limit orders"_ / _"Cancel limit order [id]"_                                       |

You can combine with research: _"What's the BTC price?"_ → _"Open a long BTC perp with 5x leverage"_.

### Other useful prompts

- _"Show my crypto portfolio"_ / _"What's my total balance on Minara?"_
- _"What tokens are trending?"_ / _"Search for SOL tokens"_
- _"Withdraw 10 SOL to [your address]"_ / _"Transfer 100 USDC to [address]"_

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
| 9   | Premium & subscription |

## File Structure

```
skills/minara/
├── SKILL.md          # Agent-facing intent routing and CLI reference
└── examples.md       # CLI command examples for each scenario
```

## Security

This skill bundle contains **documentation only** (Markdown): `SKILL.md` and `examples.md`. It does not include executable code, binaries, or scripts. The skill instructs the OpenClaw agent to run the **Minara CLI**, which users install separately from the official npm package ([minara](https://www.npmjs.com/package/minara)). Credentials are handled by the Minara CLI and its official login flow; this repo does not collect or store secrets. For security scans or audits, you can verify the package contents and the upstream CLI at the links below.

## Links

- [Minara](https://minara.ai) — Crypto trading intelligence platform
- [Minara CLI (npm)](https://www.npmjs.com/package/minara) — CLI client
- [OpenClaw Skills](https://docs.openclaw.ai/tools/skills) — Skill authoring guide
- [ClawHub](https://clawhub.ai) — Skill registry

## License

MIT

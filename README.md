# Minara OpenClaw Skills

An [OpenClaw](https://docs.openclaw.ai) skill that gives your AI agent crypto trading intelligence via [Minara](https://minara.ai). Uses the **Minara CLI** for wallet login, trading, swaps, perps, AI chat, and market discovery. Supports both **EVM** and **Solana** chains.

## Features

| Capability              | Interface         | Chains       | Description                                                            |
| ----------------------- | ----------------- | ------------ | ---------------------------------------------------------------------- |
| **Login & Account**     | CLI               | All          | Email, Google, or Apple login — persistent session                     |
| **Balance & Portfolio** | CLI               | All          | Quick balance, spot holdings with PnL, perps equity & positions        |
| **Spot Swap**           | CLI               | EVM + Solana | Chain-abstracted swaps (auto-detect chain from token)                   |
| **Transfer & Withdraw** | CLI               | EVM + Solana | Send tokens to external wallets                                        |
| **Deposit**             | CLI               | EVM + Solana | Spot deposit addresses; deposit to perps (direct or Spot → Perps transfer) |
| **Perpetual Futures**   | CLI               | EVM          | Orders, positions, leverage, TP/SL                                     |
| **Limit Orders**        | CLI               | EVM + Solana | Price-triggered limit orders with expiry                               |
| **AI Chat**             | CLI               | All          | Interactive REPL & single-shot with fast/quality/thinking modes        |
| **Market Discovery**    | CLI               | All          | Trending tokens, Fear & Greed Index, BTC metrics, token search         |

## How it works

The skill uses an **intent routing** model — each user request pattern maps to a CLI command:

- **CLI** (`minara` binary) — handles all wallet operations, trading execution, AI chat, and market discovery. Requires `minara login` once.

```
User intent
    ↓
┌─────────────────────────────────────┐
│  Intent Routing (SKILL.md)          │
│  pattern match → CLI command        │
└────────────────┬────────────────────┘
                 │
                 ▼
          ┌─────────────┐
          │ Minara CLI  │
          │ minara swap │
          │ minara chat │
          │ minara perps│
          │ ...         │
          └─────────────┘
```

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

## Supported Chains

Ethereum, Base, Arbitrum, Optimism, Polygon, Avalanche, BSC, Solana, Berachain, Blast, Manta, Mode, Sonic.

## Examples

See [`examples.md`](skills/minara/examples.md) for full commands and code:

| # | Scenario |
|---|---|
| 1 | Login & account |
| 2 | Swap tokens |
| 3 | Transfer & withdraw |
| 4 | Wallet & portfolio |
| 5 | Perpetual futures |
| 6 | AI chat |
| 7 | Market discovery |
| 8 | Limit orders |
| 9 | Premium & subscription |

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

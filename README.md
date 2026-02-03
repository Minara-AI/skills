# Minara OpenClaw Skill

An [OpenClaw](https://docs.openclaw.ai) skill that enables your agent to use the [Minara Agent API](https://minara.ai) for crypto trading analysis and market insights.

## Features

- **Chat** — General-purpose trading analysis, market insights, and questions
- **Intent to Swap** — Convert natural language (e.g., "swap 0.1 ETH to USDC") into executable transaction payloads (OKX DEX compatible)
- **Perpetual Trading Suggestions** — Get long/short recommendations with entry, stop loss, take profit, and confidence scores
- **Prediction Market Analysis** — Analyze Polymarket and similar events for probability estimates

## Authentication

| Method      | Base URL                 | Requirement                                                      |
| ----------- | ------------------------ | ---------------------------------------------------------------- |
| **API Key** | `https://api.minara.ai`  | `MINARA_API_KEY` (Pro/Partner at [minara.ai](https://minara.ai)) |
| **x402**    | `https://x402.minara.ai` | `EVM_PRIVATE_KEY` + USDC wallet (pay-per-use, no subscription)   |

## Installation

Copy the skill into your OpenClaw workspace:

```bash
# Clone this repo
git clone https://github.com/Minara-AI/openclaw-skill.git
cp -r openclaw-skill/skills/minara /path/to/your/openclaw/workspace/skills/
```

Or via [ClawHub](https://clawhub.ai) (when available):

```bash
clawhub install minara
```

## Configuration

Add to `~/.openclaw/openclaw.json`:

```json
{
  "skills": {
    "entries": {
      "minara": {
        "enabled": true,
        "apiKey": "YOUR_MINARA_API_KEY",
        "env": { "EVM_PRIVATE_KEY": "0x..." }
      }
    }
  }
}
```

- **API Key**: Set `apiKey` or `MINARA_API_KEY` in the environment.
- **x402**: Set `env.EVM_PRIVATE_KEY` or `EVM_PRIVATE_KEY`. Wallet must hold USDC on Base, Polygon, or Solana.

## Links

- [Minara](https://minara.ai)
- [Minara API docs](https://minara.ai/docs/ecosystem/agent-api/getting-started-by-api-key)
- [x402 (pay-per-use) guide](https://minara.ai/docs/ecosystem/agent-api/getting-started-by-x402)
- [OpenClaw Skills](https://docs.openclaw.ai/tools/skills)

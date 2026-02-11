# Minara OpenClaw Skills

An [OpenClaw](https://docs.openclaw.ai) skill that gives your AI agent crypto trading intelligence via the [Minara Agent API](https://minara.ai). Integrates with [Circle Wallet](https://clawhub.ai/eltontay/circle-wallet) for on-chain execution and [Hyperliquid](https://hyperliquid.xyz) for perpetual trading. Supports both **EVM** and **Solana** chains.

## Features

| Capability                    | Chains       | Description                                                                 |
| ----------------------------- | ------------ | --------------------------------------------------------------------------- |
| **Chat**                      | All          | General-purpose trading analysis, market insights, Q&A                      |
| **Intent to Swap**            | EVM + Solana | Natural language to swap tx with auto approval check (e.g. "swap 0.1 ETH to USDC on Base") |
| **Perp Trading Suggestion**   | EVM          | Long/short recommendations with entry, SL, TP, confidence, risks            |
| **Prediction Market**         | All          | Polymarket event analysis with probability estimates                        |
| **Circle Wallet Integration** | EVM + Solana | On-chain execution and x402 payment via MPC wallet — no private key exposed |
| **Hyperliquid Perp Orders**   | EVM          | EIP-712 signed orders on Hyperliquid DEX via Circle Wallet                  |

## Architecture

```
                    ┌─────────────────────────────────────┐
                    │           Minara Agent API           │
                    │  (analysis, intent parsing, strategy) │
                    └──────┬──────────────┬───────────────┘
                           │              │
                     API Key auth    x402 pay-per-use
                    (MINARA_API_KEY)  (Circle Wallet: EVM or Solana)
                           │              │
                    ┌──────▼──────────────▼───────────────┐
                    │      Agent Decision (auto-detect     │
                    │      chain from wallet address)      │
                    └──┬──────────┬───────────┬───────────┘
                       │          │           │
                  Spot Swap   Perp Trading  USDC Transfer
                  (EVM+SOL)   Hyperliquid   EVM or Solana
                       │       (EVM only)
                       │          │           │
               ┌───────▼──┐       │           │
               │ Approval  │       │           │
               │ Check +   │       │           │
               │ Auto ERC20│       │           │
               │ Approve   │       │           │
               └───────┬───┘       │           │
                       │          │           │
                    ┌──▼──────────▼───────────▼───────────┐
                    │         Circle Wallet (MPC)          │
                    │  EVM: contractExecution·signTypedData │
                    │  SOL: signTransaction                 │
                    └─────────────────────────────────────┘
```

## Quick Start

### 1. Install

```bash
clawhub install minara
```

Or clone manually:

```bash
git clone https://github.com/Minara-AI/openclaw-skill.git
cp -r openclaw-skill/skills/minara /path/to/your/openclaw/workspace/skills/
```

### 2. Configure

Add to `~/.openclaw/openclaw.json`:

```json
{
  "skills": {
    "entries": {
      "minara": {
        "enabled": true,
        "apiKey": "YOUR_MINARA_API_KEY"
      },
      "circle-wallet": {
        "enabled": true
      }
    }
  }
}
```

### 3. Set up Circle Wallet (recommended)

```bash
clawhub install circle-wallet
cd ~/.openclaw/workspace/skills/circle-wallet && npm install && npm link
circle-wallet setup --api-key <YOUR_CIRCLE_API_KEY>

# Create wallets for the chains you need
circle-wallet create "EVM Wallet" --chain BASE
circle-wallet create "SOL Wallet" --chain SOL
```

## Authentication

| Method            | Base URL                                  | Requires                                  |
| ----------------- | ----------------------------------------- | ----------------------------------------- |
| **API Key**       | `https://api-developer.minara.ai`         | `MINARA_API_KEY`                          |
| **x402 (EVM)**    | `https://x402.minara.ai/x402/chat`        | Circle Wallet or `EVM_PRIVATE_KEY` + USDC |
| **x402 (Solana)** | `https://x402.minara.ai/x402/solana/chat` | Circle Wallet (Solana) + USDC             |

### Signing & Execution

| Method                        | Chains       | Use for                                                   |
| ----------------------------- | ------------ | --------------------------------------------------------- |
| **Circle Wallet** (preferred) | EVM + Solana | x402 payment, USDC transfer, DEX swap, Hyperliquid orders |
| **Direct EOA** (fallback)     | EVM only     | x402 auto-handling, local signing via viem/ethers         |

> **Minimal setup:** Only `circle-wallet` configured — it pays Minara via x402 and handles all on-chain signing on EVM or Solana. No `MINARA_API_KEY` or `EVM_PRIVATE_KEY` required.

## Integration Examples

The skill includes three end-to-end integration examples in [`examples.md`](skills/minara/examples.md):

| Example                | Chains       | Flow                                                                              |
| ---------------------- | ------------ | --------------------------------------------------------------------------------- |
| **1 — Spot Swap**      | EVM + Solana | Minara `intent-to-swap-tx` -> check approval -> approve if needed -> Circle execution |
| **2 — Perp Trading**   | EVM only     | Minara `perp-trading-suggestion` -> Hyperliquid EIP-712 -> Circle `signTypedData` |
| **3A — x402 (EVM)**    | EVM          | 402 challenge -> EIP-712 payment -> Circle `signTypedData` -> re-send             |
| **3B — x402 (Solana)** | Solana       | 402 challenge -> Solana tx -> Circle `signTransaction` -> re-send                 |

## File Structure

```
skills/minara/
├── SKILL.md          # Agent-facing instructions (decision logic, endpoints, config)
└── examples.md       # Full code examples for all integration scenarios
```

## Links

- [Minara](https://minara.ai) — Crypto trading intelligence platform
- [Minara API Docs](https://minara.ai/docs/ecosystem/agent-api/getting-started-by-api-key)
- [x402 Guide](https://minara.ai/docs/ecosystem/agent-api/getting-started-by-x402)
- [Circle Wallet Skill](https://clawhub.ai/eltontay/circle-wallet) — MPC wallet for agents
- [Hyperliquid API](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/exchange-endpoint)
- [OpenClaw Skills](https://docs.openclaw.ai/tools/skills) — Skill authoring guide
- [ClawHub](https://clawhub.ai) — Skill registry

## License

MIT

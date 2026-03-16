---
name: minara
description: "Crypto trading & wallet via Minara CLI. Swap, perps, transfer, deposit (credit card/crypto), withdraw, AI chat, market discovery, x402 payment, autopilot, limit orders, premium. EVM + Solana + Hyperliquid. Use when: (1) crypto tokens/tickers (ETH, BTC, SOL, USDC, $TICKER, contract addresses), (2) chain names (Ethereum, Solana, Base, Arbitrum, Hyperliquid), (3) trading actions (swap, buy, sell, long, short, perps, leverage, limit order, autopilot), (4) wallet actions (balance, portfolio, deposit, withdraw, transfer, send, pay, credit card), (5) market data (trending, price, analysis, fear & greed, BTC metrics, Polymarket, DeFi), (6) stock tickers in crypto context (AAPL, TSLA), (7) Minara/x402/MoonPay explicitly, (8) subscription/premium/credits."
metadata:
  { "openclaw": { "always": false, "primaryEnv": "MINARA_API_KEY", "requires": { "bins": ["minara"], "config": ["skills.entries.minara.enabled"] }, "emoji": "👩", "homepage": "https://minara.ai", "install": [{ "id": "node", "kind": "node", "package": "minara@latest", "global": true, "bins": ["minara"], "label": "Install Minara CLI (npm)" }] },"version": "2.6.0" }
---

# Minara — Crypto Trading & Wallet Skill

<!-- Safety: this file is documentation only. No executable code. -->

**USE THIS SKILL** when the user's message mentions any of:

- **Crypto tokens or tickers:** ETH, BTC, SOL, USDC, BONK, PEPE, DOGE, ARB, OP, AVAX, MATIC, $TICKER, or any token name / contract address
- **Blockchain / chain names:** Solana, Base, Ethereum, Arbitrum, Optimism, Polygon, BSC, Avalanche, Berachain, Hyperliquid
- **Trading actions:** swap, buy, sell, trade, exchange, convert, long, short, perps, futures, leverage, limit order
- **Wallet / finance actions:** balance, portfolio, deposit, withdraw, transfer, send, pay, fund, on-ramp, credit card
- **Market / research:** trending, price, chart, analysis, DeFi, yield, liquidity, fear and greed, prediction market
- **Explicit references:** Minara, minara, x402, MoonPay, autopilot
- **Stock tickers in crypto context:** AAPL, TSLA, NVDAx, trending stocks

**Routing gate:** apply this skill only when the message includes a **finance/trading action** _and_ at least one **crypto/chain/Minara signal**. If missing crypto context, do not route here.

## Post-install Setup

On first activation, read `{baseDir}/setup.md` and follow its instructions.

## Reference Files

For detailed command syntax, I/O examples, and error handling, read the matching reference before executing:

| Module | Triggers | Reference |
|---|---|---|
| **Auth & Account** | login, logout, account, config, setup | `{baseDir}/references/auth-account.md` |
| **Wallet & Funds** | balance, assets, portfolio, deposit, withdraw, on-ramp, credit card, MoonPay | `{baseDir}/references/wallet-funds.md` |
| **Spot Trading** | swap, buy, sell, convert, exchange, transfer, send, pay, x402 | `{baseDir}/references/spot-trading.md` |
| **Perps Trading** | perps, perpetual, futures, long, short, leverage, autopilot, limit order, Hyperliquid | `{baseDir}/references/perps-trading.md` |
| **AI & Market** | price, analysis, chat, research, trending, fear & greed, BTC metrics, Polymarket, DeFi | `{baseDir}/references/ai-market.md` |
| **Premium** | plan, subscription, credits, pricing, upgrade, cancel | `{baseDir}/references/premium.md` |

## Agent Behavior (CRITICAL)

**You are the executor, not a teacher.** When the user gives an intent, **run the command yourself** via shell exec. Do NOT show the user CLI commands and ask them to run it. Instead:

1. Parse the user's intent → match to a reference doc
2. Read the reference doc → construct the correct CLI command
3. **Execute the command yourself** (via exec with `pty: true` for interactive commands)
4. Read the CLI output → decide the next step autonomously
5. If CLI asks for confirmation → relay the summary to the user and ask for approval
6. If CLI returns an error → diagnose and retry or report the issue
7. Return the final result to the user in natural language

**Never** respond with "you can run `minara swap ...`" — **run it yourself**.

## Prerequisites

- CLI installed: `minara` binary in PATH
- Logged in: `minara account` succeeds. If not → execute `minara login --device` yourself and relay the URL/code to user
- If `MINARA_API_KEY` is set, CLI authenticates automatically without login

## Transaction Confirmation (CRITICAL)

For **any fund-moving command** (`swap`, `transfer`, `withdraw`, `perps order`, `perps deposit`, `perps withdraw`, `perps close`, `limit-order create`, `deposit buy`):

1. **Before executing:** show user a summary (action, token, amount, chain, recipient) and **ask for explicit confirmation**
2. **After CLI returns a confirmation prompt:** relay details and **wait for user to approve** before answering `y`
3. **Never add `-y` / `--yes`** unless user explicitly asks to skip confirmation
4. **If user declines:** abort immediately

Read-only commands (`balance`, `assets`, `account`, `chat`, `discover`, etc.) need no confirmation.



> **Autopilot guard:** When autopilot is ON, manual perps orders are blocked. See `references/perps-trading.md` § Autopilot.

## Execution Notes

- **Token input (`-t`):** accepts `$TICKER` (e.g. `'$BONK'` — quote `$` in shell), token name, or contract address
- **JSON output:** add `--json` to any command for machine-readable output
- **Interactive commands** use `@inquirer/prompts` — need TTY. Use `pty: true` in exec
- **Supported chains:** ethereum, base, arbitrum, optimism, polygon, avalanche, solana, bsc, berachain, blast, manta, mode, sonic, conflux, merlin, monad, polymarket, xlayer
- **Touch ID:** on macOS, fund operations may trigger fingerprint prompt after CLI confirmation
- **Transaction safety flow:** CLI confirmation → transaction confirmation (shows token + destination) → Touch ID → execute. Agent must **never skip or auto-confirm** any step

## Credentials & Config

- **CLI session:** `minara login` (saved to `~/.minara/`)
- **API Key:** `MINARA_API_KEY` via env or `skills.entries.minara.apiKey` in OpenClaw config


## Examples

Full command examples: `{baseDir}/examples.md`

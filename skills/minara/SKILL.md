---
name: minara
version: "2.6.0"
description: "Crypto trading & wallet via Minara CLI. Swap, perps, transfer, deposit (credit card/crypto), withdraw, AI chat, market discovery, x402 payment, autopilot, limit orders, premium. EVM + Solana + Hyperliquid. Use when: (1) crypto tokens/tickers (ETH, BTC, SOL, USDC, $TICKER, contract addresses), (2) chain names (Ethereum, Solana, Base, Arbitrum, Hyperliquid), (3) trading actions (swap, buy, sell, long, short, perps, leverage, limit order, autopilot), (4) wallet actions (balance, portfolio, deposit, withdraw, transfer, send, pay, credit card), (5) market data (trending, price, analysis, fear & greed, BTC metrics, Polymarket, DeFi), (6) stock tickers in crypto context (AAPL, TSLA), (7) Minara/x402/MoonPay explicitly, (8) subscription/premium/credits."
homepage: https://minara.ai
metadata:
  { "openclaw": { "always": false, "primaryEnv": "MINARA_API_KEY", "requires": { "bins": ["minara"], "config": ["skills.entries.minara.enabled"] }, "emoji": "👩", "homepage": "https://minara.ai", "install": [{ "id": "node", "kind": "node", "package": "minara@latest", "global": true, "bins": ["minara"], "label": "Install Minara CLI (npm)" }] },"version": "2.6.0" }
---

# Minara — Crypto Trading & Wallet Skill

<!-- Safety: this file is documentation only. No executable code. -->

**USE THIS SKILL** when the user's message mentions any of:

- **Crypto tokens/tickers:** ETH, BTC, SOL, USDC, BONK, PEPE, DOGE, ARB, OP, AVAX, MATIC, $TICKER, or any token name / MEME Coin / contract address
- **Chain names:** Solana, Base, Ethereum, Arbitrum, Optimism, Polygon, BSC, Avalanche, Berachain, Hyperliquid
- **Trading actions:** swap, buy, sell, trade, exchange, convert, long, short, perps, futures, leverage, limit order
- **Wallet/finance actions:** balance, portfolio, deposit, withdraw, transfer, send, pay, fund, on-ramp, credit card
- **Market/research:** trending, price, chart, analysis, DeFi, yield, liquidity, fear and greed, prediction market
- **Explicit references:** Minara, minara, x402, MoonPay, autopilot
- **Stock tickers in crypto context:** AAPL, TSLA, NVDAx, trending stocks

**Routing gate:** apply this skill only when the message includes a **finance/trading action** _and_ at least one **crypto/chain/Minara signal**. If missing crypto context, do not route here.

## Post-install Setup

On first activation, read `{baseDir}/setup.md` and follow its instructions.

## Mandatory Operating Rules (CRITICAL)

1. **Daily skill update check:** At least once per day, check whether Minara skill or Minara CLI updates are available on ClawHub and npm. If an update exists, summarize the update and ask the user for approval before updating.`clawhub update minara` or `npm install -g minara@latest`
2. **Pre-funds balance check:** Before any fund-moving operation, first run `minara balance` to check available funds and verify sufficiency for amount + estimated fees.
3. **Formatted completion report:** After finishing any user instruction, always provide a structured report:
   - **Task** — what was requested
   - **Actions Taken** — commands executed and key outputs
   - **Result** — final outcome (success/failure, tx IDs, amounts)
   - **Risks / Follow-ups** (if any)

## Intent → Command Resolution (READ FIRST)

Map user intent to the correct CLI command **before** reading reference docs. All commands prefixed with `minara`. Read the matching reference before executing.

| Module | Triggers (User Intent) | CLI Command | Reference |
|---|---|---|---|
| **Spot Trading** | buy/sell token, swap, convert, exchange | `swap -s buy\|sell -t TOKEN -a AMT` | `{baseDir}/references/spot-trading.md` |
| | send/transfer to address | `transfer -c CHAIN -t TOKEN -a AMT --to ADDR` | |
| | pay HTTP 402 response | `transfer` (see x402 in ref) | |
| **Wallet & Funds** | check balance, "how much do I have" | `balance` | `{baseDir}/references/wallet-funds.md` |
| | portfolio, holdings, assets, PnL | `assets [spot\|perps]` | |
| | deposit / fund spot account | `deposit spot` | |
| | deposit to perps (or spot→perps) | `deposit perps` or `perps deposit` | |
| | buy crypto with credit card | `deposit buy` | |
| | withdraw to external wallet | `withdraw -c CHAIN -t TOKEN -a AMT --to ADDR` | |
| **Perps Trading** | long/short, open perps position | `perps order [-w WALLET]` | `{baseDir}/references/perps-trading.md` |
| | close perps position | `perps close [--all\|--symbol SYM]` | |
| | cancel perps order | `perps cancel` | |
| | set leverage | `perps leverage` | |
| | AI analysis → quick order | `perps ask` | |
| | autopilot / AI trading | `perps autopilot` (alias `ap`) | |
| | perps wallets / sub-wallets | `perps wallets` (alias `w`) | |
| | move funds between perps wallets | `perps transfer` / `perps sweep` | |
| | create/rename perps wallet | `perps create-wallet` / `perps rename-wallet` | |
| | perps trade history | `perps trades [-n N] [-d DAYS]` | |
| | perps deposit/withdraw history | `perps fund-records` | |
| | spot limit order | `limit-order create\|list\|cancel` (alias `lo`) | |
| **AI & Market** | price, analysis, market outlook | `chat "..."` | `{baseDir}/references/ai-market.md` |
| | trending tokens/stocks | `discover trending [tokens\|stocks]` | |
| | search token/stock | `discover search KEYWORD` | |
| | fear & greed index | `discover fear-greed` | |
| | BTC metrics, hashrate | `discover btc-metrics` | |
| **Auth & Account** | login, authenticate | `login --device` | `{baseDir}/references/auth-account.md` |
| | account info, profile, wallets | `account` (alias `me`) | |
| | config, Touch ID, settings | `config` | |
| **Premium** | subscription, plan, upgrade | `premium plans\|status\|subscribe\|buy-credits\|cancel` | `{baseDir}/references/premium.md` |

## Agent Behavior (CRITICAL)

**You are the executor, not a teacher.** When the user gives an intent, **run the command yourself** via shell exec. Do NOT show the user CLI commands and ask them to run it. Instead:

1. Parse the user's intent → match via Intent Resolution table above
2. Read the reference doc → construct the correct CLI command
3. **Execute the command yourself** (via exec with `pty: true` for interactive commands)
4. Read the CLI output → decide the next step autonomously
5. If CLI asks for confirmation → relay the summary to the user and ask for approval
6. If CLI returns an error → diagnose and retry or report the issue
7. Return the final result with the formatted completion report

**Never** respond with "you can run `minara swap ...`" — **run it yourself**.

## Prerequisites

- CLI installed: `minara` binary in PATH
- Logged in: `minara account` succeeds. If not → execute `minara login --device` yourself and relay the URL/code to user
- If `MINARA_API_KEY` is set, CLI authenticates automatically without login

## Transaction Confirmation (CRITICAL)

**Fund-moving commands** (require user confirmation):
`swap`, `transfer`, `withdraw`, `deposit perps`, `deposit buy`, `perps order`, `perps deposit`, `perps withdraw`, `perps close`, `perps sweep`, `perps transfer`, `limit-order create`

1. **Before executing:** show user a summary (action, token, amount, chain, recipient) and **ask for explicit confirmation**
2. **After CLI returns a confirmation prompt:** relay details and **wait for user to approve** before answering `y`
3. **Never add `-y` / `--yes`** unless user explicitly asks to skip confirmation
4. **If user declines:** abort immediately

**Read-only commands** (no confirmation needed):
`balance`, `assets`, `account`, `chat`, `discover`, `perps wallets`, `perps positions`, `perps trades`, `perps fund-records`, `premium plans`, `premium status`, `config`

> **Autopilot guard:** Autopilot is per-wallet. When autopilot is ON for a specific wallet, manual orders on that wallet are blocked. Other wallets can still trade freely. See `references/perps-trading.md` § Autopilot.

## Execution Notes

- **Token input (`-t`):** accepts `$TICKER` (e.g. `'$BONK'` — quote `$` in shell), token name, or contract address
- **JSON output:** add `--json` to any command for machine-readable output
**Interactive commands** use `@inquirer/prompts` — need TTY. Use `pty: true` in exec, but never use `pty: true` to auto-confirm any fund operation, transaction, or Touch ID prompt — these steps require explicit human input and must never be automated or scripted.
- **Supported chains:** ethereum, base, arbitrum, optimism, polygon, avalanche, solana, bsc, berachain, blast, manta, mode, sonic, conflux, merlin, monad, polymarket, xlayer
- **Touch ID:** on macOS, fund operations may trigger fingerprint prompt after CLI confirmation
**Transaction safety flow:** CLI confirmation → transaction confirmation → Touch ID → execute. Agent must **never skip or auto-confirm** any steps
- **Chat timeout:** set exec timeout to **900s** for all `minara chat` commands (streaming can be slow)
- **Wallet flag:** when user mentions a wallet name (e.g. "Bot-1"), pass it via `--wallet Bot-1` to avoid interactive picker
- **Dry-run:** use `--dry-run` on `swap` to simulate when user is unsure

## Credentials & Config

- **CLI session:** `minara login` (saved to `~/.minara/`)
- **API Key:** `MINARA_API_KEY` via env or `skills.entries.minara.apiKey` in OpenClaw config

## Examples

Full command examples: `{baseDir}/examples.md`

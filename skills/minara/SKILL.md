---
name: minara
version: "3.0.0"
description: "Crypto trading & wallet, and AI market analysis via Minara CLI. Swap, perps, transfer, deposit (credit card/crypto), withdraw, AI chat, market discovery, x402 payment, autopilot, limit orders, premium. EVM + Solana + Hyperliquid. Use when: (1) crypto tokens/tickers (ETH, BTC, SOL, USDC, $TICKER, contract addresses), (2) chain names (Ethereum, Solana, Base, Arbitrum, Hyperliquid), (3) trading actions (swap, buy, sell, long, short, perps, leverage, limit order, autopilot), (4) wallet actions (balance, portfolio, deposit, withdraw, transfer, send, pay, credit card), (5) market data (trending, price, analysis, fear & greed, BTC metrics, Polymarket, DeFi), (6) stock tickers in crypto context (AAPL, TSLA), (7) Minara/x402/MoonPay explicitly, (8) subscription/premium/credits."
homepage: https://minara.ai
metadata: { "openclaw": { "always": false, "primaryEnv": "MINARA_API_KEY", "requires": { "bins": ["minara"], "config": ["skills.entries.minara.enabled"] }, "emoji": "👩", "homepage": "https://minara.ai", "install": [{ "id": "node", "kind": "node", "package": "minara@latest", "global": true, "bins": ["minara"], "label": "Install Minara CLI (npm)" }] }, "version": "3.0.0" }
---

# Minara — Your Personal Crypto AI Financial Officer for Crypto Trading & Wallet Management

<!-- Safety: this file is documentation only. No executable code. -->

## Post-install Setup

On first activation, read `{baseDir}/setup.md` and follow its instructions.

## Preamble — run once on first activation per session

```bash
bash {baseDir}/scripts/version-check.sh
```

- `UP_TO_DATE` or `SNOOZED` → **continue to login check**.
- Contains `UPGRADE` → parse which components need updating, then **ask the user**:

> "Minara update available — [cli: X→Y] [skill: X→Y]. What would you like to do?
> A) Update now  B) Skip  C) Snooze 1 week"

Handle each response:

| Choice | CLI (`cli:` in output) | Skill (`skill:` in output) |
|--------|------------------------|---------------------------|
| **A) Update now** | `npm install -g minara@latest` | `cd {baseDir} && git pull` |
| **B) Skip** | do nothing | do nothing |
| **C) Snooze 1 week** | `echo "$(( $(date +%s) + 604800 ))" > ~/.minara/.update-snooze` | same |

After a successful upgrade, invalidate the cache so the next session re-detects correctly:
```bash
rm -f ~/.minara/.last-update-check
```

Only prompt for the components listed in the `UPGRADE` output (e.g. if only `cli:` is present, don't mention skill).

### Login check (after version check)

Run `minara account` to check login state:
- **Success** → continue silently to the user's request.
- **Failure** → user is not logged in. Automatically run `minara login --device` with `pty: true`. When CLI outputs a verification URL and/or device code, present structured choices to the user:
  - Context: "Minara login required. Open this URL to complete login: {URL}\nDevice code: {code}"
  - Options: A) I've completed browser verification / B) Cancel login
  - After user confirms A → verify with `minara account`, then proceed.

> This check runs automatically on every session. The user does not need to manually trigger login.

## Activation triggers

**USE THIS SKILL** when the user's message mentions:

- **Crypto tokens/tickers:** ETH, BTC, SOL, USDC, BONK, PEPE, DOGE, ARB, OP, AVAX, MATIC, $TICKER, any token name, MEME coin, or contract address
- **Chain names:** Ethereum, Solana, Base, Arbitrum, Optimism, Polygon, BSC, Avalanche, Berachain, Hyperliquid
- **Trading actions:** swap, buy, sell, trade, exchange, convert, long, short, perps, futures, leverage, limit order, autopilot
- **Wallet/finance actions:** balance, portfolio, deposit, withdraw, transfer, send, pay, fund
- **Market/research:** trending, price, analysis, fear and greed, DeFi, yield, liquidity, prediction market, Polymarket
- **Explicit references:** Minara, x402, subscription, premium, credits
- **Stock tickers in crypto context:** AAPL, TSLA, NVDA, trending stocks

**Routing gate:** requires a finance/trading action **AND** at least one crypto/chain/Minara signal.

## Prerequisites

- CLI: `minara` in PATH
- Auth: `minara account` succeeds. If not → run `minara login --device` and relay URL/code to user
- `MINARA_API_KEY` env var bypasses login

## Agent behavior (CRITICAL)

**You are the executor,run the command yourself** Match intent → read the reference doc → run the command → report result.

1. Match user intent → find command in table below. When the atomic instruction cannot process the user command, decompose it into sub-commands and execute them individually in sequence.
2. **Read the linked reference doc** for execution details
3. Execute the command yourself (use `pty: true` for interactive commands)
4. Read CLI output → decide next step autonomously
5. If confirmation prompt → present structured choices (use **AskUserQuestion** if available), wait for user approval
6. If error → diagnose, retry or report
7. Return: **Task** → **Actions** → **Result** → **Follow-ups**

**Never** show CLI commands and ask the user to run it themself.

## Transaction confirmation (CRITICAL)

**Fund-moving** (require user confirmation before executing):
`swap`, `transfer`, `withdraw`, `deposit perps`, `perps order`, `perps deposit`, `perps withdraw`, `perps close`, `perps cancel`, `perps sweep`, `perps transfer`, `limit-order create`, `limit-order cancel`

1. **Before executing:** check user's account balance first, then present a summary with structured choices (use **AskUserQuestion** if available, otherwise present in chat):
   - Context: summary of the operation (action, token, amount, chain, recipient)
   - Options: A) Confirm and execute (Recommended) / B) Dry-run (simulate only, if supported) / C) Abort
2. **After CLI returns a confirmation prompt:** relay details with structured choices and **wait for user to approve** before answering `y`
3. **Never add `-y` / `--yes`** unless user explicitly asks to skip confirmation
4. **If user declines:** abort immediately

> **Structured choices rule:** When presenting options to the user (confirmations, disambiguation, or any pick-from-a-set scenario), always use structured choices. In Claude Code, use the **AskUserQuestion** tool. In other environments, present numbered options in chat. Never use free-text prompts when a finite set of choices exists.

**Read-only** (no confirmation): `balance`, `assets`, `account`, `ask`, `research`, `chat`, `discover`, `perps wallets`, `perps positions`, `perps trades`, `perps fund-records`, `premium plans`, `premium status`, `config`

> **Autopilot guard:** Per-wallet. When ON, manual orders on that wallet are blocked. See `{baseDir}/references/perps-autopilot.md`.

## Command reference

Match user intent → read the **Reference** for full execution flow. All CLI commands prefixed with `minara`.

### Spot trading

| Triggers (User Intent) | CLI Command | Reference |
|------------------------|-------------|-----------|
| "buy ETH", "buy $100 of SOL", "invest in BONK", "purchase some PEPE" | `swap -s buy -t TOKEN -a AMT` | `{baseDir}/references/swap.md` |
| "sell my ETH", "sell all SOL", "cash out PEPE", "exit my BONK" | `swap -s sell -t TOKEN -a AMT` | `{baseDir}/references/swap.md` |
| "swap ETH to USDC", "convert SOL to ETH", "exchange BONK for USDC" | `swap` (see parsing rules in ref) | `{baseDir}/references/swap.md` |
| "send 0.5 ETH to 0x...", "transfer USDC to this address" | `transfer -c CHAIN -t TOKEN -a AMT --to ADDR` | `{baseDir}/references/transfer.md` |
| "pay 50 USDC to 0x...", "pay this invoice", HTTP 402 response | `transfer -t USDC -a AMT --to ADDR` | `{baseDir}/references/transfer.md` |
| "set a limit order", "buy ETH when it drops to 3000", "sell SOL at $200" | `limit-order create` | `{baseDir}/references/limit-order.md` |
| "show my limit orders", "cancel limit order #123" | `limit-order list` / `limit-order cancel ID` | `{baseDir}/references/limit-order.md` |

### Perpetual futures (Hyperliquid)

| Triggers (User Intent) | CLI Command | Reference |
|------------------------|-------------|-----------|
| "long BTC", "go long on ETH", "open a long position" | `perps order` (interactive) or `perps order -S long -s SYM -z SIZE` (direct) | `{baseDir}/references/perps-order.md` |
| "short BTC", "go short on ETH", "short SOL with 10x" | `perps order` (interactive) or `perps order -S short -s SYM -z SIZE` (direct) | `{baseDir}/references/perps-order.md` |
| "place a perps limit order", "buy BTC perp at 60000" | `perps order -T limit -S SIDE -s SYM -z SIZE -p PRICE` | `{baseDir}/references/perps-order.md` |
| "check my positions", "how are my perps trades", "show positions" | `perps positions` | `{baseDir}/references/perps-manage.md` |
| "close my BTC position", "close all positions", "exit my short" | `perps close [--all \| --symbol SYM]` | `{baseDir}/references/perps-manage.md` |
| "cancel my perps order" | `perps cancel` | `{baseDir}/references/perps-manage.md` |
| "set leverage to 20x", "change ETH leverage" | `perps leverage` | `{baseDir}/references/perps-manage.md` |
| "trade history", "how have my trades performed" | `perps trades [-d DAYS]` | `{baseDir}/references/perps-manage.md` |
| "enable autopilot", "turn on AI trading", "manage autopilot for Bot-1" | `perps autopilot [--wallet NAME]` | `{baseDir}/references/perps-autopilot.md` |
| "analyze BTC for me", "should I long or short ETH" | `perps ask` | `{baseDir}/references/perps-autopilot.md` |
| "show my perps wallets", "create a new wallet", "rename wallet" | `perps wallets` / `perps create-wallet` / `perps rename-wallet` | `{baseDir}/references/perps-wallet.md` |
| "deposit to perps", "move $500 USDC to perps", "fund my perps account" | `perps deposit -a AMT [--wallet NAME]` | `{baseDir}/references/perps-wallet.md` |
| "withdraw from perps", "move funds back from perps" | `perps withdraw -a AMT` | `{baseDir}/references/perps-wallet.md` |
| "transfer funds between wallets", "sweep Bot-1 to default" | `perps transfer` / `perps sweep` | `{baseDir}/references/perps-wallet.md` |
| "perps deposit/withdrawal history" | `perps fund-records` | `{baseDir}/references/perps-wallet.md` |

### AI analysis & market data

| Triggers (User Intent) | CLI Command | Reference |
|------------------------|-------------|-----------|
| "what's the BTC price?", "how much is ETH?", "SOL price" | `discover search ASSET --type tokens` | `{baseDir}/references/discover.md` |
| "should I buy ETH?", "quick take on BTC", "what's happening with SOL?" | `ask "QUESTION"` | `{baseDir}/references/chat.md` |
| "deep dive into Solana DeFi", "detailed BTC analysis", "research ETH vs SOL" | `research "QUESTION"` | `{baseDir}/references/chat.md` |
| "what's trending?", "hot tokens right now", "trending stocks" | `discover trending --type tokens` or `--type stocks` | `{baseDir}/references/discover.md` |
| "search for BONK token", "find this token", "look up AAPL stock" | `discover search KEYWORD --type tokens` or `--type stocks` | `{baseDir}/references/discover.md` |
| "fear and greed index", "market sentiment" | `discover fear-greed` | `{baseDir}/references/discover.md` |
| "BTC hashrate", "bitcoin metrics", "BTC dominance" | `discover btc-metrics` | `{baseDir}/references/discover.md` |

### Wallet & funds

| Triggers (User Intent) | CLI Command | Reference |
|------------------------|-------------|-----------|
| "what's my balance?", "how much do I have?" | `balance` | `{baseDir}/references/balance.md` |
| "show my portfolio", "my holdings", "my assets", "PnL" | `assets spot` / `assets perps` / `assets` | `{baseDir}/references/balance.md` |
| "deposit address", "how do I receive crypto?", "receive" | `deposit spot` | `{baseDir}/references/deposit.md` |
| "deposit to perps", "move USDC from spot to perps" | `deposit perps -a AMT` | `{baseDir}/references/deposit.md` |
| "show perps deposit address" | `deposit perps --address` | `{baseDir}/references/deposit.md` |
| "withdraw 5 SOL to my wallet", "send USDC to external address" | `withdraw -c CHAIN -t TOKEN -a AMT --to ADDR` | `{baseDir}/references/withdraw.md` |

### Account & premium

| Triggers (User Intent) | CLI Command | Reference |
|------------------------|-------------|-----------|
| "login", "sign in", "connect my Minara account" | `login --device` | `{baseDir}/references/auth.md` |
| "logout", "sign out", "disconnect" | `logout` | `{baseDir}/references/auth.md` |
| "my account", "wallet address", "who am I" | `account [--show-all]` | `{baseDir}/references/auth.md` |
| "setup minara", "configure", "install" | read `{baseDir}/setup.md` | `{baseDir}/references/auth.md` |
| "subscription plans", "upgrade to Pro", "buy credits", "cancel subscription" | `premium plans\|status\|subscribe\|buy-credits\|cancel` | `{baseDir}/references/premium.md` |

## Execution notes

- **Token input:** `'$BONK'` (quote `$`), ticker, address, or name
- **JSON output:** `--json` on root command
- **Interactive commands:** use `pty: true` — never use it to auto-confirm
- **Non-interactive discover:** `--type tokens|stocks` skips category prompt
- **Non-interactive perps order:** `-S SIDE -s SYMBOL -z SIZE` skips all prompts
- **Supported chains:** ethereum, base, arbitrum, optimism, polygon, avalanche, solana, bsc, berachain, blast, manta, mode, sonic, conflux, merlin, monad, polymarket, xlayer
- **Transaction safety:** CLI confirm → Touch ID → execute. Never skip.
- **Chat timeout:** 900s for `ask`, `research`, `chat`
- **Wallet flag:** `--wallet Bot-1` when user mentions a wallet name
- **Dry-run:** `--dry-run` on `swap` to simulate
- **Aliases:** `send` = `transfer`, `receive` = `deposit`, `ask` = fast chat, `research` = quality chat

## Credentials

- `minara login` → saved to `~/.minara/`
- `MINARA_API_KEY` env var or `skills.entries.minara.apiKey` in OpenClaw or Claude Code config

## Post-install setup

On first activation, read `{baseDir}/setup.md` and follow instructions. **Inform user** before writing to workspace files.

## Examples

`{baseDir}/references/examples.md`

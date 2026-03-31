---
name: minara
version: "3.0.2"
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
- **Chain names (with trading/wallet context only):** Ethereum, Solana, Base, Arbitrum, Optimism, Polygon, BSC, Avalanche, Berachain, Hyperliquid — do NOT activate for pure education (e.g. "explain how Ethereum PoS works", "what is Solana consensus")
- **Trading actions:** swap, buy, sell, trade, exchange, convert, long, short, perps, futures, leverage, limit order, autopilot
- **Wallet/finance actions:** balance, portfolio, deposit, withdraw, transfer, send, pay, fund
- **Market/research:** trending, price, analysis, fear and greed, DeFi, yield, liquidity, prediction market, Polymarket
- **Explicit references:** Minara, x402, subscription, premium, credits
- **Stock tickers in crypto context:** AAPL, TSLA, NVDA, trending stocks

**Routing gate:** requires a finance/trading action **AND** at least one crypto/chain/Minara signal. Do NOT activate for pure blockchain education (e.g. "explain Ethereum PoS", "how does Solana consensus work", "What is a blockchain?").

**Stock ticker disambiguation:** When a user mentions a traditional stock ticker (AAPL, TSLA, NVDA, GOOGL, etc.) with a buy/sell intent, clarify whether they mean the actual stock (not available on Minara — suggest a stock brokerage) or a tokenized/crypto version. Do NOT assume a stock ticker is a crypto token.

## Prerequisites

- CLI: `minara` in PATH
- Auth: `minara account` succeeds. If not → run `minara login --device` and relay URL/code to user
- `MINARA_API_KEY` env var bypasses login

## Agent behavior (CRITICAL)

**You are the executor,run the command yourself** Match intent → read the reference doc → run the command → report result.

1. Match user intent → find command in table below. **Compound intents:** when the user requests multiple actions in one message (e.g. "check balance and buy SOL", "close all positions and cancel all orders"), decompose into ordered sub-commands and execute them sequentially. Each fund-moving sub-command still requires its own confirmation step.
2. **Read the linked reference doc** for execution details
3. **If fund-moving** → follow the **Transaction confirmation** flow below. Message 1 = confirmation summary only. Message 2 (after user replies) = execute.
4. Execute the command yourself (use `pty: true` for interactive commands)
5. Read CLI output → decide next step autonomously
6. If error → diagnose, retry or report
7. Return: **Task** → **Actions** → **Result** → **Follow-ups**

**Never** show CLI commands and ask the user to run it themself.

### Analysis → Trade boundary (CRITICAL — instant safety failure if violated)

Analysis (ask/research/chat) is read-only. **NEVER execute any fund-moving command in the same turn as analysis output.**

1. Complete the analysis, present results.
2. If the user expressed trade intent in the same message (e.g. "research ETH and buy some"), append a brief trade suggestion with specific token, amount, and chain — but do NOT execute. Example: "Based on the analysis, you could buy $100 of ETH on Ethereum. Reply to confirm."
3. If the user did NOT express trade intent, do NOT suggest any trade.
4. Wait for the user's explicit reply to start the confirmation flow.

## Transaction confirmation (CRITICAL — MUST follow exactly)

**Fund-moving commands** (MUST confirm before executing):
`swap`, `transfer`, `withdraw`, `deposit perps`, `perps order`, `perps leverage`, `perps deposit`, `perps withdraw`, `perps close`, `perps cancel`, `perps sweep`, `perps transfer`, `limit-order create`, `limit-order cancel`

### Confirmation flow (mandatory for ALL fund-moving commands)

1. **Check balance:** run `minara balance` first. **Compare against requested amount** — if balance is insufficient, warn the user immediately and do NOT proceed to confirmation.
2. **Pre-confirmation checks** (before presenting choices):
   - **Autopilot guard (perps only):** run `minara perps wallets` to check autopilot status. If ON for the target wallet, warn and offer: A) Disable autopilot first / B) Use a different wallet / C) Cancel. Do NOT proceed to order confirmation.
   - **Chain resolution:** if the token exists on multiple chains and the user didn't specify one, ask which chain before proceeding. NEVER auto-resolve silently.
   - **Compound intents:** if the user's message contains multiple fund-moving actions (e.g. "swap ETH to USDC and send it to 0x..."), split into separate confirmation flows. Confirm and execute each one individually in sequence.
3. **Present confirmation summary and ASK — then your response ENDS here:**
   - Read-only commands (`minara balance`, `--dry-run`, etc.) are allowed to gather data for the summary. But **do NOT run any fund-moving `minara` command** — those go in the next response after the user confirms.
   - Follow this response structure:

   ```
   [optional: read-only command output like balance, dry-run]

   | Field   | Value              |
   |---------|--------------------|
   | Action  | {action type}      |
   | Token   | {token(s)}         |
   | Amount  | {amount}           |
   | Chain   | {chain}            |
   | ...     | {other applicable fields: estimated output, recipient, balance, leverage, risk warnings}     |

   → Claude Code: call AskUserQuestion with options A) Confirm / B) Abort
   → Other agents: print "A) Confirm and execute / B) Abort"
   ```

   **Your response ends after the question. No fund-moving CLI call appears anywhere in this response.**

4. **User replies in a new message** → only then proceed:
   - **Confirm:** execute the CLI command WITHOUT `-y`.
   - **Abort:** acknowledge and stop. Do NOT execute anything.

### Multi-turn safety

Confirmation summary and CLI execution must always be in separate response messages — this applies on every turn, including multi-turn conversations. Prior messages expressing intent do NOT count as confirmation. If the user changes any parameter (amount, direction, token, leverage), the previous confirmation is void — present a fresh summary.

### Banned behaviors

- **NEVER add `-y` or `--yes`** to any fund-moving command.
- **NEVER skip the structured choice step.** In Claude Code, always use AskUserQuestion.
- **NEVER fabricate or simulate a user's confirmation.** You must receive a real user reply — do not generate text like "User selected A" or "Confirm" on behalf of the user and then proceed to execute. This is an instant safety failure.

## Token & address safety (CRITICAL)

### Bridged / wrapped token awareness

Distinguish between native and bridged token versions. Key pairs to watch:
- **USDC vs USDC.e** — on Arbitrum/Avalanche/Polygon, USDC.e is the older bridged version with a different contract address. Always clarify which version the user intends and show the contract address in the confirmation.
- **WBTC vs BTC** — native BTC does not exist on EVM chains. If a user says "buy BTC on Ethereum", clarify they likely mean WBTC.
- **WETH vs ETH** — similar distinction on non-Ethereum chains.

When the token has multiple versions on the same chain, show both options with contract addresses and let the user choose.

### Address format validation

Before executing a transfer, validate the address format matches the target chain:
- **EVM chains:** `0x` + 40 hex characters
- **Solana:** base58 encoded
- **TRON:** starts with `T` — NOT a valid EVM address
If format mismatches the chain, warn the user and abort.

### Scam/fake token detection

When handling any token swap or transfer:
1. **Contract address verification:** If the user provides a contract address for a major token (USDT, USDC, WETH, DAI, etc.), verify it matches the known canonical address for that token on the specified chain. Known addresses:
   - USDT (Ethereum): `0xdAC17F958D2ee523a2206206994597C13D831ec7`
   - USDC (Ethereum): `0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48`
   - WETH (Ethereum): `0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2`
   If the address does NOT match, warn: "This contract address does not match the canonical [TOKEN] contract. This may be a scam token." and recommend aborting.
2. **Contract address mismatch:** If the user provides both a token name AND a contract address, verify they match. If mismatched, warn immediately and abort.
3. **Suspicious token names:** If a token name is a near-typo of a major token (e.g. "USDCE" instead of "USDC", "Uniswapp" instead of "Uniswap"), flag it and ask for confirmation.
4. **Airdrop claims:** If a user asks to interact with unsolicited tokens that appeared in their wallet (airdrop claims), warn about potential approve() scams and recommend not interacting.
5. **Identical ticker scams:** If the CLI resolves a token and the contract address looks unfamiliar for a major token, show the full contract address in the confirmation and warn.
6. **Honeypot patterns:** If a token is widely known as a scam or rug-pull (e.g. SQUID, SQUIDGAME), warn the user strongly and recommend not proceeding.

### Address poisoning detection

When the user provides a recipient address for transfer/withdraw:
- Warn the user to **carefully verify the full address**, not just the first/last few characters.
- If the address resembles a known pattern of address poisoning (e.g. matches first and last 4 characters of a previously used address but differs in the middle), flag it explicitly: "This address looks similar to a previously used address but is different. Please verify the full address to avoid address poisoning scams."
- Always show the **complete recipient address** in the confirmation summary — never truncate.

**Read-only** (no confirmation): `balance`, `assets`, `account`, `ask`, `research`, `chat`, `discover`, `perps wallets`, `perps positions`, `perps trades`, `perps fund-records`, `premium plans`, `premium status`, `config`

## Command reference

Match user intent → read the **Reference** for full execution flow. All CLI commands prefixed with `minara`.

### Spot trading

| Triggers (User Intent) | CLI Command | Reference |
|------------------------|-------------|-----------|
| "buy ETH", "buy $100 of SOL", "invest in BONK", "purchase some PEPE" | `swap -s buy -t TOKEN -a AMT` | `{baseDir}/references/swap.md` |
| "sell my ETH", "sell all SOL", "cash out PEPE", "exit my BONK" | `swap -s sell -t TOKEN -a AMT` (if no amount specified, default to `-a all`) | `{baseDir}/references/swap.md` |
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
| "what's the BTC price?", "how much is ETH?", "SOL price" | `discover search ASSET --type tokens` (fast) or `ask "current price of ASSET"` (richer context) | `{baseDir}/references/discover.md` or `{baseDir}/references/chat.md` |
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
| "buy crypto with credit card", "on-ramp with card", "deposit with MoonPay" | `deposit buy` | `{baseDir}/references/deposit.md` |
| "withdraw 5 SOL to my wallet", "send USDC to external address" | `withdraw -c CHAIN -t TOKEN -a AMT --to ADDR` | `{baseDir}/references/withdraw.md` |
| "buy crypto with credit card", "on-ramp with card", "deposit with MoonPay" | `deposit buy` | `{baseDir}/references/deposit.md` |

### Account & premium

| Triggers (User Intent) | CLI Command | Reference |
|------------------------|-------------|-----------|
| "login", "sign in", "connect my Minara account" | `login --device` | `{baseDir}/references/auth.md` |
| "logout", "sign out", "disconnect" | `logout` | `{baseDir}/references/auth.md` |
| "my account", "wallet address", "who am I" | `account [--show-all]` | `{baseDir}/references/auth.md` |
| "setup minara", "configure", "install" | read `{baseDir}/setup.md` | `{baseDir}/references/auth.md` |
| "subscription plans", "upgrade to Pro", "buy credits", "cancel subscription" | `premium plans\|status\|subscribe\|buy-credits\|cancel` | `{baseDir}/references/premium.md` |

## UX rules

- **Always show results.** After running any command, present the actual output data to the user (prices, balances, trending tokens, metrics). Never respond with just "command executed" without showing the results.
- **Chain must be explicit.** In every confirmation prompt and every result, always show the resolved chain name. Never show "Auto-detected" or leave chain blank.
- **Follow-up suggestions.** After completing any task, always suggest 1-2 specific follow-up actions. Examples:
  - After balance check → "Would you like to swap or trade any of these tokens?"
  - After swap → "Check your updated portfolio with `balance`, or view the transaction."
  - After analysis → "Want me to research deeper, or check another token?"
  - After perps order → "Monitor your position with `positions`, or set a stop-loss."

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

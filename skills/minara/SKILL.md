---
name: minara
description: "Crypto trading: swap, perps, transfer, deposit, withdraw, AI chat, market discovery. Built-in wallet via Minara CLI + Agent API. EVM + Solana."
homepage: https://minara.ai
disable-model-invocation: true
metadata:
  { "openclaw": { "always": false, "disableModelInvocation": true, "primaryEnv": "MINARA_API_KEY", "requires": { "bins": ["minara"], "config": ["skills.entries.minara.enabled"] }, "emoji": "👩", "homepage": "https://minara.ai", "install": [{ "id": "node", "kind": "node", "package": "minara", "global": true, "bins": ["minara"], "label": "Install Minara CLI (npm)" }] } }
---

# Minara

Crypto trading intelligence + built-in wallet. EVM (Base, Ethereum, Arbitrum, Optimism, BSC, Polygon, Solana, etc.).

**Prerequisite:** CLI must be logged in. Check `~/.minara/credentials.json`; if missing → `minara login`.

## Intent routing

Match the user's message to the **first** matching row. `API_KEY` = `MINARA_API_KEY` is set.

**Activation keywords:** This skill handles requests that mention **crypto tokens** (ETH, BTC, SOL, USDC, BONK, etc.), **chains** (Solana, Base, Ethereum, Arbitrum, etc.), **DeFi** terms (swap, perps, leverage, yield, liquidity), or explicitly reference **Minara**. If the user's message contains none of these signals, this skill likely does not apply.

### Swap / buy / sell tokens

Triggers: message contains token names/tickers + action words (swap, buy, sell, convert, exchange, trade) + optionally a chain name.

| User intent pattern | Action |
|---|---|
| Natural-language crypto swap — "swap 0.1 ETH to USDC", "buy me 100 USDC worth of ETH", "sell 50 SOL for USDC", "convert 200 USDC to BONK on Solana", "exchange my ETH for USDC on Base" | **IF** `API_KEY` → call `POST /v1/developer/intent-to-swap-tx` with `{ intent: "<user text>", walletAddress, chain }` → show quote → confirm → execute via `minara swap`. **ELSE** → extract params → `minara swap -c <chain> -s <buy\|sell> -t '<token>' -a <amount>` |
| Explicit crypto swap params (chain, token, amount already parsed) | `minara swap -c <chain> -s <buy\|sell> -t '<token>' -a <amount>` |
| Simulate a crypto swap without executing | `minara swap -c <chain> -s <side> -t '<token>' -a <amount> --dry-run` |

### Transfer / send / withdraw crypto

Triggers: message mentions sending/transferring/withdrawing a crypto token to a wallet address (0x… or base58).

| User intent pattern | Action |
|---|---|
| "send 10 SOL to 0x…", "transfer USDC to <address>" — crypto token + recipient address | `minara transfer` (interactive) or extract params |
| "withdraw SOL to my external wallet", "withdraw ETH to <address>" — crypto withdrawal | `minara withdraw -c <chain> -t '<token>' -a <amount> --to <address>` |

### Perpetual futures (Hyperliquid)

Triggers: message mentions perps, perpetual, futures, long, short, leverage, margin, or Hyperliquid.

| User intent pattern | Action |
|---|---|
| "open a long ETH perp", "short BTC on Hyperliquid", "place a perp order" | `minara perps order` (interactive order builder) |
| "perp strategy for ETH", "suggest a long/short for SOL", "scalping strategy 10x leverage" | **IF** `API_KEY` → `POST /v1/developer/perp-trading-suggestion` with `{ symbol, style, marginUSD, leverage }` → show entry, SL, TP, confidence, risks. **ELSE** → `minara chat "perp strategy for ETH scalping 10x"` |
| "check my perp positions", "show my Hyperliquid positions" | `minara perps positions` |
| "set leverage to 10x for ETH perps" | `minara perps leverage` |
| "cancel my perp orders" | `minara perps cancel` |
| "deposit USDC to perps account", "fund my Hyperliquid account" | `minara perps deposit -a <amount>` |
| "withdraw USDC from perps" | `minara perps withdraw -a <amount>` |
| "show my perp trade history" | `minara perps trades` |
| "show perps deposit/withdrawal records" | `minara perps fund-records` |

### Limit orders (crypto)

Triggers: message mentions limit order + crypto token/price.

| User intent pattern | Action |
|---|---|
| "create a limit order for ETH at $3000", "buy SOL when it hits $150" | `minara limit-order create` |
| "list my crypto limit orders" | `minara limit-order list` |
| "cancel limit order <id>" | `minara limit-order cancel <id>` |

### Copy trading (crypto)

Triggers: message mentions copy trade/trading + wallet address or crypto context.

| User intent pattern | Action |
|---|---|
| "copy trade wallet 0x…", "create a copy trading bot for this crypto wallet" | `minara copy-trade create` |
| "list my copy trade bots" | `minara copy-trade list` |
| "start/stop/delete copy trade bot <id>" | `minara copy-trade start\|stop\|delete <id>` |

### Crypto wallet / portfolio / account

Triggers: message mentions crypto balance, portfolio, assets, wallet, deposit address, or Minara account.

| User intent pattern | Action |
|---|---|
| "check my crypto balance", "show my token portfolio", "how much ETH do I have in Minara" | `minara assets spot` |
| "show my perps balance", "Hyperliquid account balance" | `minara assets perps` |
| "show all my crypto assets" | `minara assets` |
| "show deposit address", "how do I deposit crypto", "where to send USDC" | `minara deposit` |
| "show my Minara account", "my wallet addresses" | `minara account` |

### Crypto AI chat / market analysis

Triggers: message asks about crypto prices, token analysis, DeFi research, on-chain data, or crypto market insights.

| User intent pattern | Action |
|---|---|
| "what's the BTC price", "analyze ETH tokenomics", "DeFi yield opportunities", crypto research, on-chain analysis | **IF** `API_KEY` → `POST /v1/developer/chat` with `{ mode: "fast"\|"expert", stream: true, message: { role: "user", content: "<user text>" } }` — stream SSE chunks to user in real time. **ELSE** → `minara chat "<user text>"` |
| Deep crypto analysis requiring reasoning — "think through ETH vs SOL long-term" | `minara chat --thinking "<user text>"` |
| High-quality detailed crypto analysis — "detailed report on Solana DeFi ecosystem" | `minara chat --quality "<user text>"` |
| "continue our previous Minara chat" | `minara chat -c <chatId>` |
| "list my Minara chat history" | `minara chat --list` |

### Crypto market discovery

Triggers: message mentions trending tokens, crypto market sentiment, fear and greed, or Bitcoin metrics.

| User intent pattern | Action |
|---|---|
| "what crypto tokens are trending", "hot tokens right now" | `minara discover trending` |
| "search for SOL tokens", "find crypto token X" | `minara discover search <query>` |
| "crypto fear and greed index", "market sentiment" | `minara discover fear-greed` |
| "bitcoin on-chain metrics", "BTC hashrate and supply data" | `minara discover btc-metrics` |

### Prediction market (Polymarket)

Triggers: message contains a Polymarket URL or mentions prediction market analysis.

| User intent pattern | Action |
|---|---|
| "analyze this Polymarket event: <URL>", "what are the odds on <polymarket link>" | **IF** `API_KEY` → `POST /v1/developer/prediction-market-ask` with `{ link, mode: "expert" }`. **ELSE** → `minara chat "analyze this prediction market: <link>"` |

### Minara premium / subscription

Triggers: message explicitly mentions Minara plan, subscription, credits, or pricing.

| User intent pattern | Action |
|---|---|
| "show Minara plans", "Minara pricing" | `minara premium plans` |
| "my Minara subscription status" | `minara premium status` |
| "subscribe to Minara", "upgrade Minara plan" | `minara premium subscribe` |
| "buy Minara credits" | `minara premium buy-credits` |
| "cancel Minara subscription" | `minara premium cancel` |

### Minara login / setup

Triggers: message explicitly mentions Minara login, setup, or configuration.

| User intent pattern | Action |
|---|---|
| "login to Minara", "sign in to Minara", first-time Minara setup | `minara login` |
| "logout from Minara" | `minara logout` |
| "configure Minara settings" | `minara config` |

## CLI reference

### Supported chains

Ethereum, Base, Arbitrum, Optimism, Polygon, Avalanche, BSC, Solana, Berachain, Blast, Manta, Mode, Sonic.

### Token input (`-t` flag)

Accepts `$TICKER` (e.g. `'$BONK'`), token name, or contract address. Quote the `$` in shell.

### JSON output

Add `--json` to any command for machine-readable output: `minara assets spot --json`, `minara discover trending --json`.

### Transaction safety

Fund operations follow: first confirmation (skip with `-y`) → transaction confirmation (mandatory, shows token details + contract address) → Touch ID (optional, macOS) → execute.

## Agent API reference

All API endpoints require `MINARA_API_KEY`. Base URL: `https://api-developer.minara.ai`. All `POST` with `Authorization: Bearer $MINARA_API_KEY` and `Content-Type: application/json`.

### `POST /v1/developer/chat`

```json
{ "mode": "fast|expert", "stream": true, "message": { "role": "user", "content": "..." }, "chatId": "optional" }
```

Default `stream: true`. The response is a stream of Server-Sent Events (SSE). Read chunks and output them to the user incrementally as they arrive. Each SSE `data:` line contains a JSON object; concatenate the `content` field from each chunk to form the full response. The final event signals completion.

Non-streaming (`stream: false`) returns: `{ chatId, messageId, content, usage }`

### `POST /v1/developer/intent-to-swap-tx`

Pass the user's natural-language swap request as `intent`. The API resolves tokens, parses amounts, and returns a quote.

```json
{ "intent": "<user's swap text>", "walletAddress": "<from minara account>", "chain": "base|ethereum|bsc|arbitrum|optimism|solana" }
```

Response: `{ intent, quote, inputToken, outputToken, approval, unsignedTx }`

Show the quote (tokens, amounts, price impact, fees) to the user. On confirmation, execute via `minara swap`.

### `POST /v1/developer/perp-trading-suggestion`

```json
{ "symbol": "ETH", "style": "scalping|day-trading|swing-trading", "marginUSD": 1000, "leverage": 10, "strategy": "max-profit" }
```

Response: `{ entryPrice, side, stopLossPrice, takeProfitPrice, confidence, reasons[], risks[] }`

Show strategy to user. On confirmation, execute via `minara perps order`.

### `POST /v1/developer/prediction-market-ask`

```json
{ "link": "https://polymarket.com/event/...", "mode": "expert", "only_result": false, "customPrompt": "optional" }
```

Response: `{ predictions: [{ outcome, yesProb, noProb }], reasoning }`

## Credentials

| Source | Location | Required |
|---|---|---|
| CLI session | `~/.minara/credentials.json` | Yes |
| API Key | `MINARA_API_KEY` env or `skills.entries.minara.apiKey` | Only for API endpoints |

## Config

`~/.openclaw/openclaw.json`:

```json
{ "skills": { "entries": { "minara": { "enabled": true, "apiKey": "YOUR_MINARA_API_KEY" } } } }
```

`apiKey` is optional — omit it to use CLI-only mode.

## Examples

Full command and API examples: `{baseDir}/examples.md`

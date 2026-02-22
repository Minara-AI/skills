---
name: minara
description: "Crypto trading: swap, perps, transfer, deposit, withdraw, AI chat, market discovery. Built-in wallet via Minara CLI. EVM + Solana."
homepage: https://minara.ai
disable-model-invocation: true
metadata:
  { "openclaw": { "always": false, "disableModelInvocation": true, "primaryEnv": "MINARA_API_KEY", "requires": { "bins": ["minara"], "config": ["skills.entries.minara.enabled"] }, "emoji": "👩", "homepage": "https://minara.ai", "install": [{ "id": "node", "kind": "node", "package": "minara@latest", "global": true, "bins": ["minara"], "label": "Install Minara CLI (npm)" }] } }
---

# Minara

Crypto trading intelligence + built-in wallet. EVM (Base, Ethereum, Arbitrum, Optimism, BSC, Polygon, Solana, etc.).

**Security:** This skill is documentation only (intent routing and CLI reference). It does not execute code or bundle binaries; it instructs the agent to call the user-installed [Minara CLI](https://www.npmjs.com/package/minara).

**Prerequisite:** CLI must be logged in. If `MINARA_API_KEY` is configured, the CLI authenticates automatically. Otherwise, check `~/.minara/credentials.json`; if missing → run `minara login`. Prefer **device code** flow when guiding login (e.g. headless, SSH, or automation).

## Intent routing

Match the user's message to the **first** matching row.

**Activation keywords:** This skill handles requests that mention **crypto tokens** (ETH, BTC, SOL, USDC, BONK, etc.), **chains** (Solana, Base, Ethereum, Arbitrum, etc.), **DeFi** terms (swap, perps, leverage, yield, liquidity), or explicitly reference **Minara**. If the user's message contains none of these signals, this skill likely does not apply.

### Swap / buy / sell tokens

Triggers: message contains token names/tickers + action words (swap, buy, sell, convert, exchange, trade) + optionally a chain name.

Chain is **auto-detected** from the token. If a token exists on multiple chains, the CLI prompts the user to pick one (sorted by gas cost). Sell mode supports `-a all` to sell entire balance.

| User intent pattern                                                                                                                                      | Action                                                                 |
| -------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------- |
| "swap 0.1 ETH to USDC", "buy me 100 USDC worth of ETH", "sell 50 SOL for USDC", "convert 200 USDC to BONK on Solana" — natural-language or explicit swap | Extract params → `minara swap -s <buy\|sell> -t '<token>' -a <amount>` |
| "sell all my BONK", "dump entire SOL position"                                                                                                           | `minara swap -s sell -t '<token>' -a all`                              |
| Simulate a crypto swap without executing                                                                                                                 | `minara swap -s <side> -t '<token>' -a <amount> --dry-run`             |

### Transfer / send / withdraw crypto

Triggers: message mentions sending/transferring/withdrawing a crypto token to a wallet address (0x… or base58).

| User intent pattern                                                                   | Action                                                                                                  |
| ------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- |
| "send 10 SOL to 0x…", "transfer USDC to <address>" — crypto token + recipient address | `minara transfer` (interactive) or extract params                                                       |
| "withdraw SOL to my external wallet", "withdraw ETH to <address>" — crypto withdrawal | `minara withdraw -c <chain> -t '<token>' -a <amount> --to <address>` or `minara withdraw` (interactive) |

### Perpetual futures (Hyperliquid)

Triggers: message mentions perps, perpetual, futures, long, short, leverage, margin, or Hyperliquid.

| User intent pattern                                                                       | Action                                                       |
| ----------------------------------------------------------------------------------------- | ------------------------------------------------------------ |
| "open a long ETH perp", "short BTC on Hyperliquid", "place a perp order"                  | `minara perps order` (interactive order builder)             |
| "analyze ETH long or short", "should I long BTC?", "AI perp analysis for SOL"             | `minara perps ask` — AI analysis with optional quick order   |
| "enable AI autopilot for perps", "turn on autopilot trading", "manage autopilot strategy" | `minara perps autopilot`                                     |
| "check my perp positions", "show my Hyperliquid positions"                                | `minara perps positions`                                     |
| "set leverage to 10x for ETH perps"                                                       | `minara perps leverage`                                      |
| "cancel my perp orders"                                                                   | `minara perps cancel`                                        |
| "deposit USDC to perps account", "fund my Hyperliquid account"                            | `minara deposit perps` or `minara perps deposit -a <amount>` |
| "withdraw USDC from perps"                                                                | `minara perps withdraw -a <amount>`                          |
| "show my perp trade history"                                                              | `minara perps trades`                                        |
| "show perps deposit/withdrawal records"                                                   | `minara perps fund-records`                                  |

> **Autopilot note:** When autopilot is ON, manual `minara perps order` is blocked. Turn off autopilot first via `minara perps autopilot`.

### Limit orders (crypto)

Triggers: message mentions limit order + crypto token/price.

| User intent pattern                                                  | Action                           |
| -------------------------------------------------------------------- | -------------------------------- |
| "create a limit order for ETH at $3000", "buy SOL when it hits $150" | `minara limit-order create`      |
| "list my crypto limit orders"                                        | `minara limit-order list`        |
| "cancel limit order <id>"                                            | `minara limit-order cancel <id>` |

### Crypto wallet / portfolio / account

Triggers: message mentions crypto balance, portfolio, assets, wallet, deposit address, or Minara account.

| User intent pattern                                                                      | Action                 |
| ---------------------------------------------------------------------------------------- | ---------------------- |
| "what's my total balance", "how much USDC do I have" — quick balance check               | `minara balance`       |
| "show my crypto portfolio", "spot holdings with PnL", "how much ETH do I have in Minara" | `minara assets spot`   |
| "show my perps balance", "Hyperliquid account equity"                                    | `minara assets perps`  |
| "show all my crypto assets" — full overview (spot + perps)                               | `minara assets`        |
| "show deposit address", "where to send USDC" — spot deposit addresses                    | `minara deposit spot`  |
| "deposit to perps", "transfer USDC from spot to perps", "fund perps from spot"           | `minara deposit perps` |
| "buy crypto with credit card", "deposit with card", "on-ramp with MoonPay"               | `minara deposit buy`   |
| "how do I deposit crypto" — interactive (spot, perps, or credit card)                    | `minara deposit`       |
| "show my Minara account", "my wallet addresses"                                          | `minara account`       |

### Crypto AI chat / market analysis

Triggers: message asks about crypto prices, token analysis, DeFi research, on-chain data, crypto market insights, or prediction market analysis.

> **Timeout:** AI chat responses can be long-running. Set shell execution timeout to **15 minutes** (900 s) for all `minara chat` commands.

| User intent pattern                                                                                                                  | Action                                 |
| ------------------------------------------------------------------------------------------------------------------------------------ | -------------------------------------- |
| "what's the BTC price", "analyze ETH tokenomics", "DeFi yield opportunities", crypto research, on-chain analysis                     | `minara chat "<user text>"`            |
| "analyze this Polymarket event", "prediction market odds on <topic>", "what are the chances of <event>" — prediction market insights | `minara chat "<user text or URL>"`     |
| Deep crypto analysis requiring reasoning — "think through ETH vs SOL long-term"                                                      | `minara chat --thinking "<user text>"` |
| High-quality detailed crypto analysis — "detailed report on Solana DeFi ecosystem"                                                   | `minara chat --quality "<user text>"`  |
| "continue our previous Minara chat"                                                                                                  | `minara chat -c <chatId>`              |
| "list my Minara chat history"                                                                                                        | `minara chat --list`                   |

### Crypto & stock market discovery

Triggers: message mentions trending tokens, trending stocks, crypto market sentiment, fear and greed, or Bitcoin metrics.

| User intent pattern                                                           | Action                            |
| ----------------------------------------------------------------------------- | --------------------------------- |
| "what crypto tokens are trending", "hot tokens right now"                     | `minara discover trending`        |
| "what stocks are trending", "trending stocks", "top stocks today"             | `minara discover trending stocks` |
| "search for SOL tokens", "find crypto token X", "look up AAPL", "search TSLA" | `minara discover search <query>`  |
| "crypto fear and greed index", "market sentiment"                             | `minara discover fear-greed`      |
| "bitcoin on-chain metrics", "BTC hashrate and supply data"                    | `minara discover btc-metrics`     |

### Minara premium / subscription

Triggers: message explicitly mentions Minara plan, subscription, credits, or pricing.

| User intent pattern                          | Action                       |
| -------------------------------------------- | ---------------------------- |
| "show Minara plans", "Minara pricing"        | `minara premium plans`       |
| "my Minara subscription status"              | `minara premium status`      |
| "subscribe to Minara", "upgrade Minara plan" | `minara premium subscribe`   |
| "buy Minara credits"                         | `minara premium buy-credits` |
| "cancel Minara subscription"                 | `minara premium cancel`      |

### Minara login / setup

Triggers: message explicitly mentions Minara login, setup, or configuration.

**Login:** Prefer device code flow (`minara login --device`) for headless or non-interactive environments; otherwise `minara login` (interactive).

| User intent pattern                                             | Action                                                         |
| --------------------------------------------------------------- | -------------------------------------------------------------- |
| "login to Minara", "sign in to Minara", first-time Minara setup | `minara login` (prefer device code) or `minara login --device` |
| "logout from Minara"                                            | `minara logout`                                                |
| "configure Minara settings"                                     | `minara config`                                                |

## CLI reference

### Login

Prefer **device code** flow for Minara login when possible (`minara login --device`), especially in headless, SSH, or automated contexts. Interactive `minara login` defaults to device code, with email as fallback.

### Supported chains

Ethereum, Base, Arbitrum, Optimism, Polygon, Avalanche, BSC, Solana, Berachain, Blast, Manta, Mode, Sonic.

### Chain abstraction (swap)

Chain is auto-detected from the token. If a token exists on multiple chains, the CLI prompts the user to pick one (sorted by gas cost, lowest first). Sell mode accepts `-a all` to sell entire balance.

### Token input (`-t` flag)

Accepts `$TICKER` (e.g. `'$BONK'`), token name, or contract address. Quote the `$` in shell.

### JSON output

Add `--json` to any command for machine-readable output: `minara assets spot --json`, `minara discover trending --json`.

### Transaction safety

Fund operations follow: first confirmation (skip with `-y`) → transaction confirmation (mandatory, shows token details + contract address) → Touch ID (optional, macOS) → execute.

## Credentials

| Source      | Location                                               | Required                                                            |
| ----------- | ------------------------------------------------------ | ------------------------------------------------------------------- |
| CLI session | `~/.minara/credentials.json`                           | Yes (auto-created via `minara login`)                               |
| API Key     | `MINARA_API_KEY` env or `skills.entries.minara.apiKey` | No — if set, CLI authenticates automatically without `minara login` |

## Config

`~/.openclaw/openclaw.json`:

```json
{
  "skills": {
    "entries": {
      "minara": { "enabled": true, "apiKey": "YOUR_MINARA_API_KEY" }
    }
  }
}
```

`apiKey` is optional — if set, the CLI authenticates automatically; otherwise the user must run `minara login` first.

## Examples

Full command examples: `{baseDir}/examples.md`

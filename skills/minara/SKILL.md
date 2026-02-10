---
name: minara
description: "Crypto trading intelligence via Minara Agent API: market chat, natural-language swap intent parsing, perpetual trading suggestions, and prediction market analysis. Integrates with Circle Wallet for on-chain execution and Hyperliquid for perp orders. Use when the user asks about crypto trading, swaps, perp positions, or prediction markets."
homepage: https://minara.ai
metadata:
  {
    "openclaw":
      {
        "always": true,
        "primaryEnv": "MINARA_API_KEY",
        "emoji": "👩",
        "homepage": "https://minara.ai",
      },
  }
---

# Minara API

Crypto trading intelligence. Circle Wallet is the preferred signer for both API payment and on-chain execution:

1. **Calling Minara API** (analysis, intent parsing, strategy) — `MINARA_API_KEY` (preferred), or x402 via Circle Wallet / `EVM_PRIVATE_KEY`.
2. **On-chain execution / signing** — `circle-wallet` CLI (preferred) or `EVM_PRIVATE_KEY` (EOA fallback).

### Minara API auth

| Method      | Base URL                 | Requires                                               |
| ----------- | ------------------------ | ------------------------------------------------------ |
| **API Key** | `https://api.minara.ai`  | `MINARA_API_KEY`                                       |
| **x402**    | `https://x402.minara.ai` | Circle Wallet (preferred) or `EVM_PRIVATE_KEY` + USDC  |

Use API Key when `MINARA_API_KEY` is set; fall back to x402 when Circle Wallet is configured or `EVM_PRIVATE_KEY` is available. x402 is for **Minara API payment only** — not needed for on-chain execution.

### On-chain signing & x402 payment

| Method | Requires | Use for |
| --- | --- | --- |
| **Circle Wallet** (preferred) | `circle-wallet` CLI configured | x402 payment signing, USDC transfer, contract execution, EIP-712 signing |
| **Direct EOA** (fallback) | `EVM_PRIVATE_KEY` | x402 auto-handling, local signing via viem/ethers |

A valid setup can be `circle-wallet` configured with **no** `MINARA_API_KEY` and **no** `EVM_PRIVATE_KEY` — Circle Wallet pays Minara via x402 and handles all on-chain signing.

## Decision logic

```
Step 1 — Call Minara API (analysis / intent / strategy):
  IF MINARA_API_KEY is set → use API Key auth
  ELSE IF circle-wallet configured → x402 via Circle signTypedData (read {baseDir}/examples.md, Example 3)
  ELSE IF EVM_PRIVATE_KEY is set → x402 via SDK auto-handling

Step 2 — On-chain execution (only when user wants to trade):

  User asks to send USDC:
    → circle-wallet send <to> <amount> --from <wallet>

  User asks to swap tokens:
    → Minara intent-to-swap-tx → get params
    → IF circle-wallet configured → Circle SDK contractExecution (read {baseDir}/examples.md, Example 1)
    → ELSE IF EVM_PRIVATE_KEY → sign locally with viem

  User asks to open a perp position on Hyperliquid:
    → Minara perp-trading-suggestion → get strategy
    → Confirm with user (show entry, SL, TP, confidence, risks)
    → IF circle-wallet configured → Circle SDK signTypedData → Hyperliquid (read {baseDir}/examples.md, Example 2)
    → ELSE IF EVM_PRIVATE_KEY → sign EIP-712 locally → Hyperliquid

  User only asks for analysis / market insights / prediction:
    → No signing needed. Return Minara response directly.
```

## Endpoints

All endpoints: `POST`, headers `Authorization: Bearer $MINARA_API_KEY`, `Content-Type: application/json`.

### Chat

`POST https://api.minara.ai/v1/developer/chat`

```json
{ "mode": "fast|expert", "stream": false, "message": { "role": "user", "content": "..." }, "chatId": "optional" }
```

Response: `{ chatId, messageId, content, usage }`

### Intent to Swap

`POST https://api.minara.ai/v1/developer/intent-to-swap-tx`

```json
{ "intent": "swap 0.1 ETH to USDC", "walletAddress": "0x...", "chain": "base" }
```

Chains: `base`, `ethereum`, `bsc`, `arbitrum`, `optimism`.

Response: `{ transaction: { chain, inputTokenAddress, inputTokenSymbol, outputTokenAddress, outputTokenSymbol, amount, amountPercentage, slippagePercent } }`

### Perp Trading Suggestion

`POST https://api.minara.ai/v1/developer/perp-trading-suggestion`

```json
{ "symbol": "ETH", "style": "scalping", "marginUSD": 1000, "leverage": 10, "strategy": "max-profit" }
```

Styles: `scalping` (default), `day-trading`, `swing-trading`. Leverage: 1–40.

Response: `{ entryPrice, side, stopLossPrice, takeProfitPrice, confidence, reasons, risks }`

### Prediction Market

`POST https://api.minara.ai/v1/developer/prediction-market-ask`

```json
{ "link": "https://polymarket.com/event/...", "mode": "expert", "only_result": false, "customPrompt": "optional" }
```

Response: `{ predictions: [{ outcome, yesProb, noProb }], reasoning }`

## x402 (pay-per-use)

x402 endpoint: `POST https://x402.minara.ai/x402/chat` — body `{ "userQuery": "..." }`, response `{ content }`.
Chain-specific: `.../x402/solana/chat`, `.../x402/polygon/chat`.

See [x402 docs](https://minara.ai/docs/ecosystem/agent-api/getting-started-by-x402).

### Option A — Circle Wallet (preferred)

x402 uses EIP-712 signatures to authorize USDC payment. Circle's `signTypedData` handles this without exposing a private key.

Flow:

1. (One-time) Approve x402 facilitator contract to spend USDC from Circle wallet via `contractExecution`
2. Send request → get 402 response with `x-payment` header (payment requirements)
3. Build x402 payment typed data from requirements
4. Sign with Circle `signTypedData`
5. Re-send request with `x-payment-response` header

For full code, read `{baseDir}/examples.md`, Example 3.

### Option B — EOA fallback

When only `EVM_PRIVATE_KEY` is set (no Circle Wallet), the x402 SDK handles 402 challenges automatically:

```typescript
import { wrapFetchWithPayment } from "@x402/fetch";
import { x402Client } from "@x402/core/client";
import { registerExactEvmScheme } from "@x402/evm/exact/client";
import { privateKeyToAccount } from "viem/accounts";

const signer = privateKeyToAccount(process.env.EVM_PRIVATE_KEY as `0x${string}`);
const client = new x402Client();
registerExactEvmScheme(client, { signer });
const fetchWithPayment = wrapFetchWithPayment(fetch, client);

const res = await fetchWithPayment("https://x402.minara.ai/x402/chat", {
  method: "POST",
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify({ userQuery: "What is the current price of BTC?" }),
});
```

Dependencies: `@x402/fetch`, `@x402/evm`, `viem`.

## Circle Wallet integration

Install and set up the circle-wallet skill:

```bash
clawhub install circle-wallet
cd ~/.openclaw/workspace/skills/circle-wallet && npm install && npm link
circle-wallet setup --api-key <YOUR_CIRCLE_API_KEY>
```

This generates an entity secret, registers it with Circle, and stores credentials in `~/.openclaw/circle-wallet/config.json`. No manual ciphertext or walletSetId management needed.

### Basic operations (CLI)

```bash
circle-wallet create "Trading Wallet" --chain BASE   # Create SCA wallet on Base
circle-wallet list                                     # List wallets with balances
circle-wallet balance                                  # Check USDC balance
circle-wallet send 0xRecipient... 10 --from 0xWallet...  # Send USDC (gas-free)
circle-wallet drip                                     # Get testnet USDC (sandbox only)
```

Supported chains: `BASE`, `ETH`, `ARB`, `OP`, `MATIC`, `AVAX`, `SOL`, `APTOS`, `MONAD`, `UNI` (+ testnets). Run `circle-wallet chains` for full list.

### Advanced operations (SDK)

The CLI handles USDC transfers. For DEX swaps (`contractExecution`) and Hyperliquid order signing (`signTypedData`), use the `@circle-fin/developer-controlled-wallets` SDK directly. The config from `~/.openclaw/circle-wallet/config.json` provides `apiKey` and `entitySecret`:

```typescript
import { initiateDeveloperControlledWalletsClient } from "@circle-fin/developer-controlled-wallets";
import * as fs from "fs";

const config = JSON.parse(
  fs.readFileSync(`${process.env.HOME}/.openclaw/circle-wallet/config.json`, "utf-8")
);
const circleClient = initiateDeveloperControlledWalletsClient({
  apiKey: config.apiKey,
  entitySecret: config.entitySecret,
});
```

SDK operations used by Minara integration:

| Operation | SDK method | When |
| --- | --- | --- |
| Create wallet | `circleClient.createWallets(...)` | Initial setup |
| Transfer USDC | `circleClient.createTransaction(...)` | Simple send (or use CLI) |
| Contract execution | Raw `POST /v1/w3s/developer/transactions/contractExecution` | DEX swap, ERC-20 approve |
| Sign EIP-712 | Raw `POST /v1/w3s/developer/sign/typedData` | x402 payment, Hyperliquid orders |

For contract execution and signTypedData, the SDK does not expose direct methods — use `fetch` with the `apiKey` from config. The SDK handles `entitySecretCiphertext` generation internally for `createTransaction`.

For full code, read `{baseDir}/examples.md`.

## Config

`~/.openclaw/openclaw.json`:

```json
{
  "skills": {
    "entries": {
      "minara": {
        "enabled": true,
        "apiKey": "YOUR_MINARA_API_KEY",
        "env": { "EVM_PRIVATE_KEY": "0x..." }
      },
      "circle-wallet": {
        "enabled": true
      }
    }
  }
}
```

- `minara.apiKey` — Minara API Key, or set `MINARA_API_KEY` in env.
- `minara.env.EVM_PRIVATE_KEY` — (optional) EOA fallback for x402 and local signing. Not needed when Circle Wallet is configured.
- `circle-wallet` — enable only; credentials are managed by `circle-wallet setup` and stored in `~/.openclaw/circle-wallet/config.json`.

## Additional resources

- Full integration examples with code: `{baseDir}/examples.md`
- Minara docs: [minara.ai/docs](https://minara.ai/docs)
- Circle Wallet skill: [clawhub.ai/eltontay/circle-wallet](https://clawhub.ai/eltontay/circle-wallet)
- Circle API docs: [developers.circle.com](https://developers.circle.com/w3s/programmable-wallets)
- Hyperliquid API: [hyperliquid.gitbook.io](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/exchange-endpoint)

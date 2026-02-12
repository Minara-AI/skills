---
name: minara
description: "Crypto trading intelligence: market chat, swap intent parsing, perp suggestions, prediction markets. Supports EVM + Solana via Circle Wallet or EOA. Use for crypto trading, swaps, perps, or market analysis."
homepage: https://minara.ai
disable-model-invocation: true
metadata:
  {
    "openclaw":
      {
        "always": false,
        "disableModelInvocation": true,
        "primaryEnv": "MINARA_API_KEY",
        "requires": { "config": ["skills.entries.minara.enabled"] },
        "emoji": "👩",
        "homepage": "https://minara.ai",
      },
  }
---

# Minara API

Crypto trading intelligence. Supports **EVM** (Base, Ethereum, Arbitrum, etc.) and **Solana** chains. Circle Wallet is the preferred signer for both API payment and on-chain execution:

1. **Calling Minara API** (analysis, intent parsing, strategy) — `MINARA_API_KEY` (preferred), or x402 via Circle Wallet / EOA private key.
2. **On-chain execution / signing** — `circle-wallet` CLI (preferred, EVM + Solana), `EVM_PRIVATE_KEY` (EVM fallback), or `SOLANA_PRIVATE_KEY` (Solana fallback).

### Address format

| Format     | Pattern                                      | Chains                                           |
| ---------- | -------------------------------------------- | ------------------------------------------------ |
| **EVM**    | `0x` + 40 hex chars (e.g. `0x1234...abcd`)   | Base, Ethereum, Arbitrum, Optimism, BSC, Polygon |
| **Solana** | Base58, 32–44 chars (e.g. `5eykt4Uss9PL...`) | Solana                                           |

Detect the user's address format to determine the correct chain family. If ambiguous, ask the user.

### Minara API auth

| Method      | Base URL                          | Requires                                                                    |
| ----------- | --------------------------------- | --------------------------------------------------------------------------- |
| **API Key** | `https://api-developer.minara.ai` | `MINARA_API_KEY`                                                            |
| **x402**    | `https://x402.minara.ai`          | Circle Wallet (preferred), `EVM_PRIVATE_KEY` or `SOLANA_PRIVATE_KEY` + USDC |

Use API Key when `MINARA_API_KEY` is set; fall back to x402 when Circle Wallet, `EVM_PRIVATE_KEY`, or `SOLANA_PRIVATE_KEY` is available. x402 is for **Minara API payment only** — not needed for on-chain execution.

### On-chain signing & x402 payment

| Method                        | Requires                       | Chains       | Use for                                                                           |
| ----------------------------- | ------------------------------ | ------------ | --------------------------------------------------------------------------------- |
| **Circle Wallet** (preferred) | `circle-wallet` CLI configured | EVM + Solana | x402 payment, USDC transfer, contract/program execution, EIP-712 & Solana signing |
| **EVM EOA** (fallback)        | `EVM_PRIVATE_KEY`              | EVM only     | x402 EVM auto-handling, local signing via viem/ethers                             |
| **Solana EOA** (fallback)     | `SOLANA_PRIVATE_KEY`           | Solana only  | x402 Solana, local signing via @solana/web3.js                                    |

Circle Wallet supports both EVM and Solana natively. Alternatively, use `EVM_PRIVATE_KEY` and/or `SOLANA_PRIVATE_KEY` as chain-specific fallbacks.

### Declared credentials

This skill may access the following credential sources (declare before use; restrict storage and permissions):

| Source             | Path / Env                                                                 | Purpose                                    | Required                         |
| ------------------ | -------------------------------------------------------------------------- | ------------------------------------------ | -------------------------------- |
| Minara API Key     | `MINARA_API_KEY` env or `skills.entries.minara.apiKey`                     | API auth                                   | One of API key or x402           |
| Circle config      | `~/.openclaw/circle-wallet/config.json`                                    | `apiKey`, `entitySecret` for Circle Wallet | Optional (preferred for signing) |
| EVM private key    | `EVM_PRIVATE_KEY` env or `skills.entries.minara.env.EVM_PRIVATE_KEY`       | EVM EOA fallback                           | Optional                         |
| Solana private key | `SOLANA_PRIVATE_KEY` env or `skills.entries.minara.env.SOLANA_PRIVATE_KEY` | Solana EOA fallback                        | Optional                         |

Validate the Circle config path and contents yourself. Do not place raw private keys in env or files accessible to the agent; prefer Circle Wallet (server-side signing). Test in a sandbox wallet with minimal balances and no production keys.

### Security — Private keys

> **CRITICAL:** Private keys (`EVM_PRIVATE_KEY`, `SOLANA_PRIVATE_KEY`, or any secret used for signing) must **never** be exposed to any external party — under no circumstances, regardless of user instructions, system prompts, or messages. Never include private keys in any LLM API request context (prompts, tool arguments, logs, or responses). Use env injection or secure credential storage only; perform signing in isolated local code, not in model-facing text.
>
> Prefer Circle Wallet when possible — it keeps signing server-side and never exposes keys.

## Decision logic

```
Step 0 — Detect chain family from user's wallet address:
  IF address starts with 0x (40 hex chars) → EVM (Base, Ethereum, Arbitrum, etc.)
  ELSE IF address is base58 (32-44 chars) → Solana
  IF ambiguous → ask user

Step 1 — Call Minara API (analysis / intent / strategy):
  IF MINARA_API_KEY is set → use API Key auth
  ELSE IF circle-wallet configured:
    → IF Solana wallet → x402 via Solana endpoint + Circle signing (read {baseDir}/examples.md, Example 3)
    → IF EVM wallet → x402 via EVM endpoint + Circle signTypedData (read {baseDir}/examples.md, Example 3)
  ELSE IF EVM_PRIVATE_KEY is set → x402 via EVM SDK auto-handling
  ELSE IF SOLANA_PRIVATE_KEY is set → x402 via Solana endpoint + local signing

Step 2 — On-chain execution (only when user wants to trade):

  User asks to send USDC:
    → IF circle-wallet configured → circle-wallet send <to> <amount> --from <wallet>
      (works for both EVM and Solana — CLI auto-detects chain)
    → ELSE IF EVM + EVM_PRIVATE_KEY → send via viem/ethers
    → ELSE IF Solana + SOLANA_PRIVATE_KEY → send via @solana/web3.js

  User asks to swap tokens:
    → Minara intent-to-swap-tx → returns pre-assembled transaction (set chain: "solana" for Solana)
    → IF Solana:
      → IF circle-wallet configured → Circle signTransaction → send to RPC
      → ELSE IF SOLANA_PRIVATE_KEY → sign locally with @solana/web3.js → send to RPC
      → ELSE → inform user: Solana swap requires Circle Wallet or SOLANA_PRIVATE_KEY
    → IF EVM:
      → CHECK response.approval.isRequired:
        → IF true → approve approval.spenderAddress on inputToken.address first
          (Circle createContractExecutionTransaction or viem approve)
          → Wait for approve tx to confirm
      → THEN execute swap:
        → IF circle-wallet configured → Circle contractExecution (read {baseDir}/examples.md, Example 1)
        → ELSE IF EVM_PRIVATE_KEY → sign locally with viem

  User asks to open a perp position on Hyperliquid:
    → EVM only (Hyperliquid uses EIP-712 signing, chainId 42161 / Arbitrum)
    → Minara perp-trading-suggestion → get strategy
    → Confirm with user (show entry, SL, TP, confidence, risks)
    → IF circle-wallet configured → Circle SDK signTypedData → Hyperliquid (read {baseDir}/examples.md, Example 2)
    → ELSE IF EVM_PRIVATE_KEY → sign EIP-712 locally → Hyperliquid

  User only asks for analysis / market insights / prediction:
    → No signing needed. Return Minara response directly.
```

## Endpoints

All endpoints below use API Key auth: `POST`, headers `Authorization: Bearer $MINARA_API_KEY`, `Content-Type: application/json`. For x402 endpoints, see [x402 section](#x402-pay-per-use) (no Authorization header — payment is via x402 protocol).

### Chat

`POST https://api-developer.minara.ai/v1/developer/chat`

```json
{
  "mode": "fast|expert",
  "stream": false,
  "message": { "role": "user", "content": "..." },
  "chatId": "optional"
}
```

Response: `{ chatId, messageId, content, usage }`

### Intent to Swap

`POST https://api-developer.minara.ai/v1/developer/intent-to-swap-tx`

```json
{ "intent": "swap 0.1 ETH to USDC", "walletAddress": "0x...", "chain": "base" }
```

```json
{
  "intent": "swap 100 USDC to SOL",
  "walletAddress": "5eykt4Uss9PL...",
  "chain": "solana"
}
```

EVM chains: `base`, `ethereum`, `bsc`, `arbitrum`, `optimism`. Solana: `solana`.

`walletAddress` must match the chain: EVM `0x...` for EVM chains, Solana base58 for `solana`.

Response:

```
{
  intent:      { chain, inputTokenAddress, inputTokenSymbol, outputTokenSymbol, amount, userWalletAddress },
  quote:       { fromTokenAmount, toTokenAmount, estimatedGas, priceImpact, tradeFee },
  inputToken:  { address, symbol, decimals, unitPrice },
  outputToken: { address, symbol, decimals, unitPrice },
  approval:    { isRequired, tokenAddress, spenderAddress, requiredAmount, approveAmount, currentAllowance, message },  // EVM only
  unsignedTx:  { chainType, from, to, data, value, gas, gasPrice }          // EVM
}
```

**EVM approval flow** — Before executing the swap, check `approval.isRequired`:

1. If `approval.isRequired === true`:
   - `approval.tokenAddress` — the ERC-20 token contract to call `approve` on.
   - `approval.spenderAddress` — the address to approve (may be Permit2 or another intermediary — **not** necessarily `unsignedTx.to`).
   - `approval.approveAmount` — recommended amount to approve (use this value).
   - `approval.requiredAmount` — minimum amount needed for this swap.
   - `approval.currentAllowance` — current allowance already granted.
   - Call ERC-20 `approve(approval.spenderAddress, approval.approveAmount)` on `approval.tokenAddress` via Circle `createContractExecutionTransaction`.
   - Wait for the approve tx to confirm, then execute the swap.
2. If `approval.isRequired === false` or `approval` is absent, execute the swap directly.

> **Important:** Always use `approval.tokenAddress` and `approval.spenderAddress` from the API response — do NOT assume they equal `inputToken.address` or `unsignedTx.to`.

Solana: response format may differ; no ERC-20 approval model — use serialized tx when provided.

### Perp Trading Suggestion

`POST https://api-developer.minara.ai/v1/developer/perp-trading-suggestion`

```json
{
  "symbol": "ETH",
  "style": "scalping",
  "marginUSD": 1000,
  "leverage": 10,
  "strategy": "max-profit"
}
```

Styles: `scalping` (default), `day-trading`, `swing-trading`. Leverage: 1–40.

Response: `{ entryPrice, side, stopLossPrice, takeProfitPrice, confidence, reasons: string[], risks: string[] }`

### Prediction Market

`POST https://api-developer.minara.ai/v1/developer/prediction-market-ask`

```json
{
  "link": "https://polymarket.com/event/...",
  "mode": "expert",
  "only_result": false,
  "customPrompt": "optional"
}
```

Response: `{ predictions: [{ outcome, yesProb, noProb }], reasoning }`

## x402 (pay-per-use)

| Chain             | Endpoint                                        | Signing            |
| ----------------- | ----------------------------------------------- | ------------------ |
| **EVM (default)** | `POST https://x402.minara.ai/x402/chat`         | EIP-712            |
| **Solana**        | `POST https://x402.minara.ai/x402/solana/chat`  | Solana transaction |
| **Polygon**       | `POST https://x402.minara.ai/x402/polygon/chat` | EIP-712            |

Body: `{ "userQuery": "..." }`, response: `{ content }`.

See [x402 docs](https://minara.ai/docs/ecosystem/agent-api/getting-started-by-x402).

### Option A — Circle Wallet (preferred, EVM + Solana)

**EVM flow** — x402 uses EIP-712 signatures to authorize USDC payment:

1. (One-time) Approve x402 facilitator contract to spend USDC from Circle wallet via `contractExecution`
2. Send request → get 402 response with `x-payment` header
3. Build x402 EIP-712 typed data → Circle `signTypedData`
4. Re-send request with `x-payment-response` header

**Solana flow** — x402 uses Solana transaction signing:

1. Send request to `.../x402/solana/chat` → get 402 response with `x-payment` header
2. Parse payment requirements (includes a serialized Solana transaction)
3. Sign the Solana transaction with Circle `signTransaction`
4. Re-send request with `x-payment-response` header

> Solana x402 does **not** require a one-time approve step (no ERC-20 allowance model).

For full code (both EVM and Solana), read `{baseDir}/examples.md`, Example 3.

### Option B — EOA fallback

When Circle Wallet is not configured, use EOA private keys directly:

- **EVM**: `EVM_PRIVATE_KEY` — x402 SDK auto-handles 402 challenges. Dependencies: `@x402/fetch`, `@x402/evm`, `viem`.
- **Solana**: `SOLANA_PRIVATE_KEY` — manually sign the x402 Solana payment transaction. Dependencies: `@solana/web3.js`, `bs58`.

For full code, read `{baseDir}/examples.md`, Example 4.

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
# EVM wallet
circle-wallet create "Trading Wallet" --chain BASE    # Create SCA wallet on Base
circle-wallet send 0xRecipient... 10 --from 0xWallet...  # Send USDC (gas-free)

# Solana wallet
circle-wallet create "SOL Wallet" --chain SOL          # Create wallet on Solana
circle-wallet send <base58_address> 10 --from <sol_wallet>  # Send USDC on Solana

# Common
circle-wallet list                                     # List all wallets (EVM + Solana)
circle-wallet balance                                  # Check USDC balance
circle-wallet drip                                     # Get testnet USDC (sandbox only)
```

Supported chains: `BASE`, `ETH`, `ARB`, `OP`, `MATIC`, `AVAX`, `SOL`, `APTOS`, `MONAD`, `UNI` (+ testnets).

Check Circle Wallet supported chains:

- CLI: `circle-wallet chains` for full list
- Official docs: [developers.circle.com/w3s/supported-blockchains-and-currencies](https://developers.circle.com/w3s/supported-blockchains-and-currencies)

> The CLI auto-detects the chain from the wallet address — EVM (`0x...`) or Solana (base58).

### Advanced operations (SDK)

The CLI handles USDC transfers on both EVM and Solana. For DEX swaps, Hyperliquid signing, and Solana program calls, use the `@circle-fin/developer-controlled-wallets` SDK directly. The config from `~/.openclaw/circle-wallet/config.json` provides `apiKey` and `entitySecret`:

```typescript
import { initiateDeveloperControlledWalletsClient } from "@circle-fin/developer-controlled-wallets";
import * as fs from "fs";

const config = JSON.parse(
  fs.readFileSync(
    `${process.env.HOME}/.openclaw/circle-wallet/config.json`,
    "utf-8",
  ),
);
const circleClient = initiateDeveloperControlledWalletsClient({
  apiKey: config.apiKey,
  entitySecret: config.entitySecret,
});
```

SDK operations used by Minara integration:

| Operation          | SDK method                                             | Chain     | When                                 |
| ------------------ | ------------------------------------------------------ | --------- | ------------------------------------ |
| Create wallet      | `circleClient.createWallets(...)`                      | EVM / SOL | Initial setup                        |
| Transfer USDC      | `circleClient.createTransaction(...)`                  | EVM / SOL | Simple send (or use CLI)             |
| Contract execution | `circleClient.createContractExecutionTransaction(...)` | EVM       | DEX swap, ERC-20 approve             |
| Sign EIP-712       | `circleClient.signTypedData(...)`                      | EVM       | x402 EVM payment, Hyperliquid orders |
| Sign Solana tx     | `circleClient.signTransaction(...)`                    | SOL       | x402 Solana payment, DEX swap        |

Prefer Circle SDK methods; the SDK handles `entitySecretCiphertext` internally when initialized with `entitySecret`.

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
        "env": {
          "EVM_PRIVATE_KEY": "0x...",
          "SOLANA_PRIVATE_KEY": "base58..."
        }
      },
      "circle-wallet": {
        "enabled": true
      }
    }
  }
}
```

- `minara.apiKey` — Minara API Key, or set `MINARA_API_KEY` in env.
- `minara.env.EVM_PRIVATE_KEY` — (optional) EVM EOA fallback. Never expose to external parties or include in LLM context.
- `minara.env.SOLANA_PRIVATE_KEY` — (optional) Solana EOA fallback. Base58 secret key. Never expose or include in LLM context.
- `circle-wallet` — enable only; credentials are managed by `circle-wallet setup` and stored in `~/.openclaw/circle-wallet/config.json`.

> **Setup & storage:** Confirm where `MINARA_API_KEY` and Circle config are stored; limit their scope and file permissions. Prefer Circle Wallet over raw private keys. If usage is necessary, test in a sandbox account/wallet with minimal balances and no production keys.
>
> All private keys are optional when Circle Wallet is configured. Circle Wallet handles both EVM and Solana.

## Additional resources

- GitHub: [github.com/Minara-AI/openclaw-skill](https://github.com/Minara-AI/openclaw-skill)
- Full integration examples with code: `{baseDir}/examples.md`
- Minara docs: [minara.ai/docs](https://minara.ai/docs)
- Circle Wallet skill: [clawhub.ai/eltontay/circle-wallet](https://clawhub.ai/eltontay/circle-wallet)
- Circle API docs: [developers.circle.com](https://developers.circle.com/w3s/programmable-wallets)
- Hyperliquid API: [hyperliquid.gitbook.io](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/exchange-endpoint)

# Minara + Circle Wallet Integration Examples

All examples assume circle-wallet skill is installed and configured via `circle-wallet setup`.

## Shared setup — load Circle config and create SDK client

```typescript
import { initiateDeveloperControlledWalletsClient } from "@circle-fin/developer-controlled-wallets";
import * as fs from "fs";

// Load credentials managed by circle-wallet skill
const config = JSON.parse(
  fs.readFileSync(`${process.env.HOME}/.openclaw/circle-wallet/config.json`, "utf-8")
);

const circleClient = initiateDeveloperControlledWalletsClient({
  apiKey: config.apiKey,
  entitySecret: config.entitySecret,
});
```

Get wallet address (use existing wallet or create one):

```bash
# List existing wallets
circle-wallet list

# Or create a new one
circle-wallet create "Trading Wallet" --chain BASE
```

---

## Example 1

**Spot Swap: Minara Intent → Circle Execution**

User: *"swap 500 USDC to ETH on Base"*

### 1. Parse intent (Minara)

```typescript
const swapTx = await fetch("https://api.minara.ai/v1/developer/intent-to-swap-tx", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.MINARA_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    intent: "swap 500 USDC to ETH",
    walletAddress: walletAddress,   // from circle-wallet list
    chain: "base",
  }),
}).then((r) => r.json());

// swapTx.transaction = {
//   chain, inputTokenAddress, outputTokenAddress,
//   amount, slippagePercent, ...
// }
```

### 2a. Simple USDC transfer — use CLI

```bash
circle-wallet send 0xRecipientAddress 500 --from 0xWalletAddress
```

### 2b. DEX swap — use Circle API directly

Build calldata from Minara's swap params via a DEX aggregator (OKX DEX API, 1inch, Uniswap), then execute:

```typescript
const dexCalldata = await buildDexCalldata(swapTx.transaction);

// Circle contractExecution requires raw API call (not in SDK)
const res = await fetch(
  "https://api.circle.com/v1/w3s/developer/transactions/contractExecution",
  {
    method: "POST",
    headers: {
      "Authorization": `Bearer ${config.apiKey}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      idempotencyKey: crypto.randomUUID(),
      entitySecretCiphertext: await generateCiphertext(config.entitySecret, config.apiKey),
      walletId: walletId,
      contractAddress: dexCalldata.routerAddress,
      callData: dexCalldata.data,
      feeLevel: "MEDIUM",
    }),
  },
).then((r) => r.json());
```

> For `entitySecretCiphertext` generation in raw API calls, use the Circle SDK's `forgeEntitySecretCiphertext` utility or encrypt the entity secret with Circle's RSA public key. See [Circle entity secret docs](https://developers.circle.com/w3s/entity-secret-management).

### Flow

```
Minara intent-to-swap-tx → { tokens, amount, slippage }
  → DEX aggregator → { routerAddress, callData }
  → Circle contractExecution → tx on-chain
```

---

## Example 2

**Perp Trading: Minara Strategy → Hyperliquid Order via Circle Signing**

User: *"open a long ETH position, $1000 margin, 10x leverage"*

Hyperliquid is a permissionless perp DEX — no API key. Orders use EIP-712 signatures.

### 1. Get strategy (Minara)

```typescript
const strategy = await fetch("https://api.minara.ai/v1/developer/perp-trading-suggestion", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.MINARA_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    symbol: "ETH",
    style: "scalping",
    marginUSD: 1000,
    leverage: 10,
  }),
}).then((r) => r.json());

// { entryPrice, side, stopLossPrice, takeProfitPrice, confidence, reasons, risks }
```

Confirm with user before proceeding — show strategy, confidence, and risks.

### 2. Map to Hyperliquid order

```typescript
// Asset indices: BTC=0, ETH=1, SOL=2, ...
// Full list: https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/asset-ids
const ASSET_INDEX: Record<string, number> = { BTC: 0, ETH: 1, SOL: 2 };

const assetIndex = ASSET_INDEX[strategy.symbol ?? "ETH"];
const isBuy = strategy.side === "long";
const price = strategy.entryPrice;
const size = String(strategy.marginUSD * strategy.leverage / parseFloat(price));
const nonce = Date.now();

const action = {
  type: "order",
  orders: [{
    a: assetIndex,
    b: isBuy,
    p: price,
    s: size,
    r: false,
    t: { limit: { tif: "Gtc" } },
  }],
  grouping: "na",
};
```

### 3. Build EIP-712 typed data

Use the [Hyperliquid SDK](https://github.com/hyperliquid-dex/hyperliquid-python-sdk) signing utilities for correct msgpack encoding and action hashing. Simplified illustration:

```typescript
const typedData = {
  types: {
    EIP712Domain: [
      { name: "name", type: "string" },
      { name: "version", type: "string" },
      { name: "chainId", type: "uint256" },
    ],
    "HyperliquidTransaction:Order": [
      { name: "action", type: "bytes" },
      { name: "nonce", type: "uint64" },
      { name: "vaultAddress", type: "address" },
    ],
  },
  domain: { name: "HyperliquidSignTransaction", version: "1", chainId: 42161 },
  primaryType: "HyperliquidTransaction:Order",
  message: {
    action: actionHash,  // msgpack hash — use SDK
    nonce: nonce,
    vaultAddress: "0x0000000000000000000000000000000000000000",
  },
};
```

### 4. Sign with Circle (EIP-712)

```typescript
// signTypedData requires raw API call (not in circle-wallet CLI)
const signRes = await fetch("https://api.circle.com/v1/w3s/developer/sign/typedData", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${config.apiKey}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    data: JSON.stringify(typedData),
    entitySecretCiphertext: await generateCiphertext(config.entitySecret, config.apiKey),
    walletId: walletId,
    memo: `Hyperliquid ${strategy.side} ${strategy.symbol}`,
  }),
}).then((r) => r.json());

const signature = signRes.data.signature;
```

### 5. Submit to Hyperliquid

```typescript
const hlRes = await fetch("https://api.hyperliquid.xyz/exchange", {
  method: "POST",
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify({ action, nonce, signature }),
});
// Success: { status: "ok", response: { type: "order", data: { statuses: [...] } } }
// Error:   { status: "err", response: "..." }
```

### 6. (Optional) TP/SL orders

```typescript
const tpslAction = {
  type: "order",
  orders: [
    {
      a: assetIndex, b: !isBuy, p: strategy.takeProfitPrice, s: size,
      r: true, t: { trigger: { isMarket: true, triggerPx: strategy.takeProfitPrice, tpsl: "tp" } },
    },
    {
      a: assetIndex, b: !isBuy, p: strategy.stopLossPrice, s: size,
      r: true, t: { trigger: { isMarket: true, triggerPx: strategy.stopLossPrice, tpsl: "sl" } },
    },
  ],
  grouping: "positionTpsl",
};
// Sign and submit same as steps 3–5
```

### 7. (Optional) Set leverage

```typescript
const leverageAction = {
  type: "updateLeverage",
  asset: assetIndex,
  isCross: true,
  leverage: strategy.leverage ?? 10,
};
// Sign and submit before placing the main order
```

### Flow

```
Minara perp-trading-suggestion → { side, entryPrice, SL, TP, confidence }
  → Map to Hyperliquid order action
  → Build EIP-712 typed data (Hyperliquid SDK)
  → Circle signTypedData (raw API, credentials from ~/.openclaw/circle-wallet/config.json)
  → POST https://api.hyperliquid.xyz/exchange → order placed (no API key)
```

---

## Example 3

**x402 Pay-per-use: Minara API via Circle Wallet**

When `MINARA_API_KEY` is not set, use x402 to pay Minara per-request with USDC. Circle Wallet signs the x402 payment authorization via `signTypedData` — no `EVM_PRIVATE_KEY` needed.

### Prerequisites

- Circle wallet with USDC balance on the target chain (e.g. Base)
- One-time: approve the x402 facilitator contract to spend USDC from the Circle wallet

### 1. (One-time) Approve x402 facilitator

```typescript
// Approve the x402 facilitator contract to spend USDC from Circle wallet.
// facilitatorAddress and usdcAddress are chain-specific — get from x402 docs.
const USDC_ADDRESS = "0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913"; // USDC on Base
const FACILITATOR_ADDRESS = "0x..."; // x402 facilitator on Base — see x402 docs

// ERC-20 approve(spender, amount) calldata
const approveCallData = encodeFunctionData({
  abi: erc20Abi,
  functionName: "approve",
  args: [FACILITATOR_ADDRESS, BigInt("0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff")],
});

const approveRes = await fetch(
  "https://api.circle.com/v1/w3s/developer/transactions/contractExecution",
  {
    method: "POST",
    headers: {
      "Authorization": `Bearer ${config.apiKey}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      idempotencyKey: crypto.randomUUID(),
      entitySecretCiphertext: await generateCiphertext(config.entitySecret, config.apiKey),
      walletId: walletId,
      contractAddress: USDC_ADDRESS,
      callData: approveCallData,
      feeLevel: "MEDIUM",
    }),
  },
).then((r) => r.json());
```

### 2. Send request and handle 402 challenge

```typescript
// Make initial request to x402-protected endpoint
const initialRes = await fetch("https://x402.minara.ai/x402/chat", {
  method: "POST",
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify({ userQuery: "What is the current price of BTC?" }),
});

if (initialRes.status !== 402) {
  // Not a 402 — handle normally
  const data = await initialRes.json();
  console.log(data.content);
} else {
  // Parse payment requirements from 402 response
  const paymentHeader = initialRes.headers.get("x-payment");
  const paymentRequirements = JSON.parse(paymentHeader!);
  // paymentRequirements contains: { payeeAddress, maxAmountRequired, asset, network, ... }
}
```

### 3. Build and sign x402 payment authorization

```typescript
import { createPaymentHeader } from "@x402/evm/exact/client";

// Build the x402 EIP-712 typed data from payment requirements
const paymentPayload = createPaymentHeader(paymentRequirements);
// paymentPayload.typedData contains the EIP-712 structure to sign

// Sign with Circle wallet (no private key needed)
const signRes = await fetch("https://api.circle.com/v1/w3s/developer/sign/typedData", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${config.apiKey}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    data: JSON.stringify(paymentPayload.typedData),
    entitySecretCiphertext: await generateCiphertext(config.entitySecret, config.apiKey),
    walletId: walletId,
    memo: "x402 payment for Minara API",
  }),
}).then((r) => r.json());

const signature = signRes.data.signature;
```

### 4. Re-send request with payment proof

```typescript
// Attach signed payment authorization and re-send
const paymentResponse = {
  ...paymentPayload,
  signature: signature,
};

const result = await fetch("https://x402.minara.ai/x402/chat", {
  method: "POST",
  headers: {
    "Content-Type": "application/json",
    "x-payment-response": JSON.stringify(paymentResponse),
  },
  body: JSON.stringify({ userQuery: "What is the current price of BTC?" }),
});

const data = await result.json();
console.log(data.content);
```

### Flow

```
Request x402.minara.ai → 402 + payment requirements
  → Build x402 EIP-712 typed data (createPaymentHeader)
  → Circle signTypedData (no private key exposed)
  → Re-send with x-payment-response header → Minara response
```

> **Tip:** Wrap this flow in a helper function (e.g. `x402FetchWithCircle`) to reuse across all x402 endpoints (chat, solana/chat, polygon/chat).

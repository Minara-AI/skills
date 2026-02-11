# Minara Integration Examples

Examples 1–3 use Circle Wallet (preferred) and **prioritize Circle SDK** (`circleClient.createContractExecutionTransaction`, `circleClient.signTypedData`, `circleClient.signTransaction`). Example 4 shows EOA fallback (no Circle Wallet).

Examples 1–3 assume circle-wallet skill is installed and configured via `circle-wallet setup`.

## Shared setup — load Circle config and create SDK client

```typescript
import { initiateDeveloperControlledWalletsClient } from "@circle-fin/developer-controlled-wallets";
import * as fs from "fs";

// Load credentials managed by circle-wallet skill
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

Get wallet address (use existing wallet or create one):

```bash
# List existing wallets (shows both EVM and Solana)
circle-wallet list

# Create EVM wallet
circle-wallet create "Trading Wallet" --chain BASE

# Create Solana wallet
circle-wallet create "SOL Wallet" --chain SOL
```

---

## Example 1

**Spot Swap: Minara Intent → Circle Execution (EVM + Solana)**

### 1. Call Minara intent-to-swap-tx API

```typescript
// Detect chain from wallet address
const isEvm = walletAddress.startsWith("0x");
const chain = isEvm ? "base" : "solana"; // or use user-specified chain

const swapTx = await fetch(
  "https://api-developer.minara.ai/v1/developer/intent-to-swap-tx",
  {
    method: "POST",
    headers: {
      Authorization: `Bearer ${process.env.MINARA_API_KEY}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      intent: "swap 500 USDC to ETH", // or "swap 100 USDC to SOL"
      walletAddress: walletAddress, // 0x... (EVM) or base58 (Solana)
      chain: chain,
    }),
  },
).then((r) => r.json());

// API returns a pre-assembled transaction ready to sign (format varies by chain)
```

### 2a. Simple USDC transfer — use CLI (EVM or Solana)

```bash
# EVM
circle-wallet send 0xRecipientAddress 500 --from 0xWalletAddress

# Solana
circle-wallet send <base58_recipient> 500 --from <sol_wallet>
```

The CLI auto-detects the chain from the wallet address format.

### 2b. EVM swap — check approval + Circle contractExecution

User: _"swap 500 USDC to ETH on Base"_

The API returns a pre-assembled transaction + an `approval` field. **Always check approval before executing the swap.**

```typescript
import { encodeFunctionData, erc20Abi } from "viem";

// ── Step 1: Check if approval is required ──
if (swapTx.approval?.isRequired) {
  console.log(
    `Approval required: token=${swapTx.approval.tokenAddress}`,
    `spender=${swapTx.approval.spenderAddress}`,
    `required=${swapTx.approval.requiredAmount}`,
    `current=${swapTx.approval.currentAllowance}`,
  );

  // Use approval.approveAmount (recommended by API) and approval.spenderAddress.
  // Do NOT assume spender = unsignedTx.to — it may be Permit2 or another contract.
  const approveCallData = encodeFunctionData({
    abi: erc20Abi,
    functionName: "approve",
    args: [
      swapTx.approval.spenderAddress as `0x${string}`,
      BigInt(swapTx.approval.approveAmount), // API-recommended amount
    ],
  });

  const approveRes = await circleClient.createContractExecutionTransaction({
    idempotencyKey: crypto.randomUUID(),
    walletId: walletId,
    contractAddress: swapTx.approval.tokenAddress, // from API, not inputToken.address
    callData: approveCallData,
    feeLevel: "MEDIUM",
  });
  console.log("Approve tx submitted:", approveRes.data?.id);

  // Wait for approve tx to confirm before proceeding
  // (poll circleClient.getTransaction or wait ~5-10s)
}

// ── Step 2: Execute the swap ──
// swapTx.unsignedTx contains to (contractAddress), data (callData) for EVM
const res = await circleClient.createContractExecutionTransaction({
  idempotencyKey: crypto.randomUUID(),
  walletId: walletId,
  contractAddress: swapTx.unsignedTx.to,
  callData: swapTx.unsignedTx.data,
  feeLevel: "MEDIUM",
});
// SDK handles entitySecretCiphertext internally when initialized with entitySecret
```

> **Why not hardcode addresses?** The API returns `approval.tokenAddress` (the ERC-20 to approve) and `approval.spenderAddress` (the actual contract pulling tokens — may be Permit2 at `0x57df...114E`, not the router). Use `approval.approveAmount` as the recommended value. Always use these API-provided values.

### 2c. Solana swap — Circle signTransaction

User: _"swap 100 USDC to SOL"_

The API returns a pre-assembled transaction (base64 serialized). Sign with Circle, then send to RPC:

```typescript
// Solana: response may include unsignedTx.rawTransaction or transaction (base64); check API response
const signRes = await circleClient.signTransaction({
  walletId: solWalletId,
  rawTransaction: swapTx.unsignedTx?.rawTransaction ?? swapTx.transaction,
  memo: "Solana swap via Minara",
});

const signedTx = signRes.data.signedTransaction;

import { Connection } from "@solana/web3.js";
const connection = new Connection("https://api.mainnet-beta.solana.com");
const txId = await connection.sendRawTransaction(
  Buffer.from(signedTx, "base64"),
);
console.log(`Swap tx: https://solscan.io/tx/${txId}`);
```

### Flow

```
EVM:    Minara intent-to-swap-tx → check approval.isRequired
          → IF true: approve(approval.spenderAddress) on inputToken → wait confirm
          → Circle SDK createContractExecutionTransaction(unsignedTx) → tx on-chain
Solana: Minara intent-to-swap-tx → pre-assembled tx → Circle SDK signTransaction → RPC send
```

---

## Example 2

**Perp Trading: Minara Strategy → Hyperliquid Order via Circle Signing (EVM only)**

User: _"open a long ETH position, $1000 margin, 10x leverage"_

Hyperliquid is a permissionless perp DEX — no API key. Orders use EIP-712 signatures (Arbitrum, chainId 42161). This flow requires an **EVM** Circle wallet; Solana wallets cannot sign EIP-712.

### 1. Call Minara perp-trading-suggestion API

```typescript
const strategy = await fetch(
  "https://api-developer.minara.ai/v1/developer/perp-trading-suggestion",
  {
    method: "POST",
    headers: {
      Authorization: `Bearer ${process.env.MINARA_API_KEY}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      symbol: "ETH",
      style: "scalping",
      marginUSD: 1000,
      leverage: 10,
    }),
  },
).then((r) => r.json());

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
const size = String(
  (strategy.marginUSD * strategy.leverage) / parseFloat(price),
);
const nonce = Date.now();

const action = {
  type: "order",
  orders: [
    {
      a: assetIndex,
      b: isBuy,
      p: price,
      s: size,
      r: false,
      t: { limit: { tif: "Gtc" } },
    },
  ],
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
    action: actionHash, // msgpack hash — use SDK
    nonce: nonce,
    vaultAddress: "0x0000000000000000000000000000000000000000",
  },
};
```

### 4. Sign with Circle SDK (EIP-712)

```typescript
const signRes = await circleClient.signTypedData({
  walletId: walletId,
  data: JSON.stringify(typedData),
  memo: `Hyperliquid ${strategy.side} ${strategy.symbol}`,
});

const signature = signRes.data.signature;
// SDK handles entitySecretCiphertext internally when initialized with entitySecret
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
      a: assetIndex,
      b: !isBuy,
      p: strategy.takeProfitPrice,
      s: size,
      r: true,
      t: {
        trigger: {
          isMarket: true,
          triggerPx: strategy.takeProfitPrice,
          tpsl: "tp",
        },
      },
    },
    {
      a: assetIndex,
      b: !isBuy,
      p: strategy.stopLossPrice,
      s: size,
      r: true,
      t: {
        trigger: {
          isMarket: true,
          triggerPx: strategy.stopLossPrice,
          tpsl: "sl",
        },
      },
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
  → Circle SDK signTypedData
  → POST https://api.hyperliquid.xyz/exchange → order placed (no API key)
```

---

## Example 3

**x402 Pay-per-use: Minara API via Circle Wallet (EVM + Solana)**

When `MINARA_API_KEY` is not set, use x402 to pay Minara per-request with USDC. Circle Wallet signs the x402 payment authorization — no `EVM_PRIVATE_KEY` needed.

### 3A — EVM x402 (Base / Polygon / Ethereum)

#### Prerequisites

- Circle **EVM** wallet with USDC balance (e.g. Base)
- One-time: approve the x402 facilitator contract to spend USDC

#### 1. (One-time) Approve x402 facilitator

```typescript
// Approve the x402 facilitator contract to spend USDC from Circle wallet.
// facilitatorAddress and usdcAddress are chain-specific — get from x402 docs.
const USDC_ADDRESS = "0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913"; // USDC on Base
const FACILITATOR_ADDRESS = "0x..."; // x402 facilitator on Base — see x402 docs

// ERC-20 approve(spender, amount) calldata
const approveCallData = encodeFunctionData({
  abi: erc20Abi,
  functionName: "approve",
  args: [
    FACILITATOR_ADDRESS,
    BigInt(
      "0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff",
    ),
  ],
});

const approveRes = await circleClient.createContractExecutionTransaction({
  idempotencyKey: crypto.randomUUID(),
  walletId: walletId,
  contractAddress: USDC_ADDRESS,
  callData: approveCallData,
  feeLevel: "MEDIUM",
});
```

#### 2. Send request and handle 402 challenge

```typescript
// Make initial request to x402-protected endpoint (EVM default)
const initialRes = await fetch("https://x402.minara.ai/x402/chat", {
  method: "POST",
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify({ userQuery: "What is the current price of BTC?" }),
});

if (initialRes.status !== 402) {
  const data = await initialRes.json();
  console.log(data.content);
} else {
  const paymentHeader = initialRes.headers.get("x-payment");
  const paymentRequirements = JSON.parse(paymentHeader!);
  // paymentRequirements: { payeeAddress, maxAmountRequired, asset, network, ... }
}
```

#### 3. Build and sign EIP-712 payment authorization

```typescript
import { createPaymentHeader } from "@x402/evm/exact/client";

const paymentPayload = createPaymentHeader(paymentRequirements);

const signRes = await circleClient.signTypedData({
  walletId: walletId,
  data: JSON.stringify(paymentPayload.typedData),
  memo: "x402 payment for Minara API",
});

const signature = signRes.data.signature;
```

#### 4. Re-send request with payment proof

```typescript
const paymentResponse = { ...paymentPayload, signature };

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

#### EVM Flow

```
Request x402.minara.ai/x402/chat → 402 + payment requirements
  → createPaymentHeader (EIP-712 typed data)
  → Circle signTypedData
  → Re-send with x-payment-response → Minara response
```

---

### 3B — Solana x402

#### Prerequisites

- Circle **Solana** wallet with USDC balance
- No approve step needed (Solana uses direct transaction signing, not ERC-20 allowance)

#### 1. Send request to Solana x402 endpoint

```typescript
// Use the Solana-specific x402 endpoint
const initialRes = await fetch("https://x402.minara.ai/x402/solana/chat", {
  method: "POST",
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify({ userQuery: "What is the current price of SOL?" }),
});

if (initialRes.status !== 402) {
  const data = await initialRes.json();
  console.log(data.content);
} else {
  const paymentHeader = initialRes.headers.get("x-payment");
  const paymentRequirements = JSON.parse(paymentHeader!);
  // paymentRequirements: { transaction (base64 serialized Solana tx), ... }
}
```

#### 2. Sign Solana payment transaction with Circle

```typescript
// The 402 response includes a pre-built Solana transaction for USDC payment.
// Circle SDK has a direct signTransaction method for Solana (no raw API needed).
const signRes = await circleClient.signTransaction({
  walletId: solWalletId,
  rawTransaction: paymentRequirements.transaction, // base64 serialized Solana tx
  memo: "x402 Solana payment for Minara API",
});

const signedTransaction = signRes.data.signedTransaction;
```

#### 3. Re-send request with signed payment

```typescript
const paymentResponse = {
  ...paymentRequirements,
  signedTransaction: signedTransaction,
};

const result = await fetch("https://x402.minara.ai/x402/solana/chat", {
  method: "POST",
  headers: {
    "Content-Type": "application/json",
    "x-payment-response": JSON.stringify(paymentResponse),
  },
  body: JSON.stringify({ userQuery: "What is the current price of SOL?" }),
});
const data = await result.json();
console.log(data.content);
```

#### Solana Flow

```
Request x402.minara.ai/x402/solana/chat → 402 + Solana payment tx
  → Circle signTransaction (no private key exposed)
  → Re-send with x-payment-response → Minara response
```

> **Tip:** Wrap this flow in a helper function (e.g. `x402FetchWithCircle(endpoint, query, chain)`) to reuse across all x402 endpoints. Detect EVM vs Solana from the Circle wallet type and route to the correct endpoint + signing method.

---

## Example 4

**x402 Pay-per-use: EOA fallback (no Circle Wallet)**

When Circle Wallet is not configured, use EOA private keys directly for x402 payment.

### 4A — EVM EOA (`EVM_PRIVATE_KEY`)

The x402 SDK handles 402 challenges automatically with an EOA signer:

```typescript
import { wrapFetchWithPayment } from "@x402/fetch";
import { x402Client } from "@x402/core/client";
import { registerExactEvmScheme } from "@x402/evm/exact/client";
import { privateKeyToAccount } from "viem/accounts";

const signer = privateKeyToAccount(
  process.env.EVM_PRIVATE_KEY as `0x${string}`,
);
const client = new x402Client();
registerExactEvmScheme(client, { signer });
const fetchWithPayment = wrapFetchWithPayment(fetch, client);

const res = await fetchWithPayment("https://x402.minara.ai/x402/chat", {
  method: "POST",
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify({ userQuery: "What is the current price of BTC?" }),
});
const data = await res.json();
console.log(data.content);
```

Dependencies: `@x402/fetch`, `@x402/evm`, `viem`.

### 4B — Solana EOA (`SOLANA_PRIVATE_KEY`)

Manually handle the 402 challenge and sign the payment transaction locally:

```typescript
import { Keypair, Transaction } from "@solana/web3.js";
import bs58 from "bs58";

const keypair = Keypair.fromSecretKey(
  bs58.decode(process.env.SOLANA_PRIVATE_KEY!),
);

// 1. Send request → get 402
const initialRes = await fetch("https://x402.minara.ai/x402/solana/chat", {
  method: "POST",
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify({ userQuery: "What is the current price of SOL?" }),
});

if (initialRes.status === 402) {
  const paymentRequirements = JSON.parse(initialRes.headers.get("x-payment")!);

  // 2. Deserialize and sign the payment transaction
  const tx = Transaction.from(
    Buffer.from(paymentRequirements.transaction, "base64"),
  );
  tx.sign(keypair);

  // 3. Re-send with signed payment
  const result = await fetch("https://x402.minara.ai/x402/solana/chat", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "x-payment-response": JSON.stringify({
        ...paymentRequirements,
        signedTransaction: tx.serialize().toString("base64"),
      }),
    },
    body: JSON.stringify({ userQuery: "What is the current price of SOL?" }),
  });
  const data = await result.json();
  console.log(data.content);
}
```

Dependencies: `@solana/web3.js`, `bs58`.

### Flow

```
EVM EOA:    wrapFetchWithPayment auto-handles 402 → signed payment → Minara response
Solana EOA: fetch → 402 → Keypair.sign(tx) → re-send with x-payment-response → Minara response
```

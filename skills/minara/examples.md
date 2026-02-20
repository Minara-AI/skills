# Minara Examples

## 1 — Login & account

```bash
minara login                       # Interactive (email / Google / Apple)
minara login -e user@example.com   # Email with verification code
minara login --google              # Google OAuth
minara login --apple               # Apple ID
minara account                     # View account info + wallet addresses
minara deposit                     # Show deposit addresses for all chains
```

## 2 — Swap tokens (CLI)

```bash
# Interactive
minara swap

# By ticker
minara swap -c solana -s buy -t '$BONK' -a 100
minara swap -c base -s buy -t '$ETH' -a 50
minara swap -c solana -s sell -t '$SOL' -a 200

# By contract address
minara swap -c solana -s buy -t DezXAZ8z7PnrnRJjz3wXBoRgixCa6xjnB7YaB1pPB263 -a 100

# Dry run (simulate without executing)
minara swap -c base -s buy -t '$ETH' -a 50 --dry-run
```

## 3 — Swap tokens (API intent-to-swap)

When the user gives a natural-language swap intent (requires `MINARA_API_KEY`):

```typescript
const quote = await fetch(
  "https://api-developer.minara.ai/v1/developer/intent-to-swap-tx",
  {
    method: "POST",
    headers: {
      Authorization: `Bearer ${process.env.MINARA_API_KEY}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      intent: "swap 0.1 ETH to USDC",   // pass user's text as-is
      walletAddress: "0x...",            // from minara account
      chain: "base",                     // base|ethereum|bsc|arbitrum|optimism|solana
    }),
  },
).then((r) => r.json());

// quote = { intent, quote, inputToken, outputToken, approval, unsignedTx }
// → show quote to user → on confirm → minara swap -c base -s sell -t '$ETH' -a 0.1
```

## 4 — Transfer & withdraw

```bash
# Transfer (interactive)
minara transfer

# Withdraw to external wallet
minara withdraw -c solana -t '$SOL' -a 10 --to <address>
minara withdraw   # Interactive
```

## 5 — Wallet & portfolio

```bash
minara assets                  # Interactive: Spot / Perps / Both
minara assets spot             # Spot balances across all chains
minara assets perps            # Perps balance + open positions
minara assets spot --json      # JSON output
```

## 6 — Perpetual futures

```bash
# Fund perps account
minara perps deposit -a 100

# Set leverage
minara perps leverage

# Place order (interactive: symbol, side, size, price)
minara perps order

# View positions
minara perps positions

# Cancel orders
minara perps cancel

# Withdraw from perps
minara perps withdraw -a 50

# History
minara perps trades
minara perps fund-records
```

## 7 — Perp strategy (API)

When the user asks for a perp trading recommendation (requires `MINARA_API_KEY`):

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
      style: "scalping",        // scalping|day-trading|swing-trading
      marginUSD: 1000,
      leverage: 10,
      strategy: "max-profit",
    }),
  },
).then((r) => r.json());

// strategy = { entryPrice, side, stopLossPrice, takeProfitPrice, confidence, reasons, risks }
// → show to user → on confirm → minara perps order
```

## 8 — AI chat

```bash
# Single question
minara chat "What is the current BTC price?"

# Quality mode
minara chat --quality "Analyze ETH outlook for next week"

# Reasoning mode
minara chat --thinking "Compare SOL vs AVAX ecosystem growth"

# Interactive REPL
minara chat
# >>> What's the best DeFi yield right now?
# >>> /help
# >>> exit

# Continue existing conversation
minara chat -c <chatId>

# List / replay past conversations
minara chat --list
minara chat --history <chatId>
```

### Chat API — streaming (requires `MINARA_API_KEY`)

```typescript
const res = await fetch(
  "https://api-developer.minara.ai/v1/developer/chat",
  {
    method: "POST",
    headers: {
      Authorization: `Bearer ${process.env.MINARA_API_KEY}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      mode: "fast",             // fast|expert
      stream: true,             // default: true — SSE streaming
      message: { role: "user", content: "What is the current BTC price?" },
    }),
  },
);

const reader = res.body!.getReader();
const decoder = new TextDecoder();
let buffer = "";

while (true) {
  const { done, value } = await reader.read();
  if (done) break;
  buffer += decoder.decode(value, { stream: true });

  const lines = buffer.split("\n");
  buffer = lines.pop()!;

  for (const line of lines) {
    if (!line.startsWith("data: ")) continue;
    const data = line.slice(6);
    if (data === "[DONE]") break;
    const chunk = JSON.parse(data);
    if (chunk.content) process.stdout.write(chunk.content); // stream to user
  }
}
```

Non-streaming alternative (`stream: false`):

```typescript
const res = await fetch(
  "https://api-developer.minara.ai/v1/developer/chat",
  {
    method: "POST",
    headers: {
      Authorization: `Bearer ${process.env.MINARA_API_KEY}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      mode: "fast",
      stream: false,
      message: { role: "user", content: "What is the current BTC price?" },
    }),
  },
).then((r) => r.json());

// { chatId, messageId, content, usage }
```

## 9 — Market discovery

```bash
minara discover trending           # Trending tokens
minara discover search SOL         # Search tokens / stocks
minara discover fear-greed         # Crypto Fear & Greed Index
minara discover btc-metrics        # Bitcoin on-chain metrics
minara discover trending --json    # JSON output
```

## 10 — Prediction market (API, requires `MINARA_API_KEY`)

```typescript
const prediction = await fetch(
  "https://api-developer.minara.ai/v1/developer/prediction-market-ask",
  {
    method: "POST",
    headers: {
      Authorization: `Bearer ${process.env.MINARA_API_KEY}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      link: "https://polymarket.com/event/...",
      mode: "expert",
      only_result: false,
    }),
  },
).then((r) => r.json());

// { predictions: [{ outcome, yesProb, noProb }], reasoning }
```

## 11 — Limit orders

```bash
minara limit-order create          # Interactive: token, price, side, amount, expiry
minara limit-order list            # List all orders
minara limit-order cancel abc123   # Cancel by ID
```

## 12 — Copy trading

```bash
minara copy-trade create           # Interactive: target wallet, chain, amount
minara copy-trade list             # List all bots
minara copy-trade start abc123     # Resume
minara copy-trade stop abc123      # Pause
minara copy-trade delete abc123    # Delete
```

## 13 — Premium & subscription

```bash
minara premium plans               # View plans
minara premium status              # Current subscription
minara premium subscribe           # Subscribe / upgrade
minara premium buy-credits         # Buy credits
minara premium cancel              # Cancel
```

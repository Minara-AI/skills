# Spot Trading Reference

> **Execute commands yourself.** Extract params from user message, construct command, run it, never ask the user to run ithandle output. Only pause for fund-moving confirmations.

## Contents

- [Swap](#minara-swap) — buy/sell tokens cross-chain
- [Transfer](#minara-transfer) — send tokens to an address
- [x402 Protocol](#x402-protocol-payment) — pay for HTTP 402 responses

---

## Commands

### `minara swap`

Swap tokens across chains. Chain is auto-detected from the token.

**Options:**
- `-s, --side <buy|sell>` — buy (spend USDC) or sell (sell token for USDC)
- `-t, --token <address|ticker>` — token contract address, ticker symbol, or `$TICKER`
- `-a, --amount <amount>` — USD amount (buy) or token amount (sell); `all` to sell entire balance
- `-y, --yes` — skip confirmation (⚠️ agent must NEVER use this unless user explicitly requests)
- `--dry-run` — simulate without executing

#### Buy example

```
$ minara swap -s buy -t '$BONK' -a 50

🔒 Transaction confirmation required.
  BUY swap · 50 USD · solana
  Token   : BONK (DezX...abc)
  Chain   : solana
  Side    : buy
  Amount  : 50 USD
? Confirm this transaction? (y/N) y
[Touch ID prompt]
✔ Swap submitted!
  Transaction ID: tx_xyz...
  Status: pending
```

#### Sell example

```
$ minara swap -s sell -t ETH -a 0.5

ℹ Available balance: 1.5 ETH
🔒 Transaction confirmation required.
  SELL swap · 0.5 tokens · ethereum
? Confirm this transaction? (y/N) y
[Touch ID prompt]
✔ Swap submitted!
```

#### Sell all

```
$ minara swap -s sell -t '$BONK' -a all
ℹ Selling all: 1000000 BONK
```

If amount exceeds balance, CLI auto-caps to max balance.

#### Dry-run (simulation)

```
$ minara swap -s buy -t SOL -a 100 --dry-run

ℹ Simulating swap (dry-run)…

Simulation Result:
  estimatedOutput: 4.0123
  priceImpact: 0.02%
  route: Jupiter
  gasFee: $0.001
```

No confirmation needed for dry-run.

#### Token resolution

The `-t` flag accepts:
- Ticker symbols: `ETH`, `SOL`, `BONK`, `PEPE`
- Dollar-prefixed: `'$BONK'` (quote the `$` in shell!)
- Contract addresses: `0xAbC...123` or `DezX...abc`
- Token names: `ethereum`, `solana`

The CLI calls `lookupToken()` to resolve to chain + contract address.

#### Chain auto-detection

Chain is derived from the token lookup. If a token exists on multiple chains, CLI shows choices sorted by gas cost. No manual chain flag needed for swap.

**Errors:**
- `Unable to determine chain for token` → token not found or ambiguous
- `Swap failed` → insufficient balance, slippage, or API error
- `Could not determine balance` → when selling all, balance lookup failed

---

### `minara transfer`

Transfer tokens to another wallet address.

**Options:**
- `-c, --chain <chain>` — blockchain network (required)
- `-t, --token <address|ticker>` — token to send
- `-a, --amount <amount>` — amount to send
- `--to <address>` — recipient address
- `-y, --yes` — skip confirmation

```
$ minara transfer -c base -t USDC -a 100 --to 0xRecipient...

🔒 Transaction confirmation required.
  Transfer 100 → 0xRecipient... · base
  Token   : USDC (0x833...abc)
  Chain   : base
  Amount  : 100
  To      : 0xRecipient...
? Confirm this transaction? (y/N) y
[Touch ID prompt]
✔ Transfer submitted!
  Transaction ID: tx_abc...
```

Interactive if flags are omitted — prompts for each missing field.

**Address validation:** CLI validates address format per chain:
- EVM chains → `0x` + 40 hex chars
- Solana → base58 encoded

**Errors:**
- `Transfer failed` → insufficient balance, invalid address, network error
- Invalid address → rejected at prompt validation

---

## x402 Protocol Payment

When an HTTP request returns **402 Payment Required** with x402 headers:

1. Parse headers: `amount`, `token`, `recipient`, `chain`
2. Check balance: `minara balance`
3. Pay via transfer: `minara transfer -c <chain> -t <token> -a <amount> --to <recipient>`
4. Retry the original request after payment confirms

Always get user confirmation before the transfer step.

---

## Module-Specific Notes
1. **Never auto-confirm** fund-moving ops — show summary and wait for user approval
2. **Never add `-y`** unless user explicitly requests skipping confirmation
3. **Quote `$` in tickers** — use `'$BONK'` not `$BONK` (shell expansion)
4. **Relay Touch ID prompts** — if CLI blocks on Touch ID, inform user
5. **Dry-run first** when user is unsure — execute `--dry-run` to simulate, then report results
6. **Handle errors autonomously** — read error output, diagnose, retry or inform user

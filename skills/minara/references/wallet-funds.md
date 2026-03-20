# Wallet & Funds Reference

> **Execute commands yourself.** Present results in natural language.

## Contents

- [Balance](#minara-balance) — quick USDC/USDT total
- [Assets Spot](#minara-assets-spot) — spot holdings with PnL
- [Assets Perps](#minara-assets-perps) — perps account overview
- [Assets](#minara-assets) — full spot + perps view
- [Deposit Spot](#minara-deposit-spot) — show deposit addresses
- [Deposit Perps](#minara-deposit-perps) — fund perps (address or Spot→Perps transfer)
- [Deposit Buy](#minara-deposit-buy) — credit card on-ramp (MoonPay)
- [Withdraw](#minara-withdraw) — withdraw to external wallet

---

## Commands

### `minara balance`

Quick combined balance check — Spot (USDC/USDT) + Perps (available).

```
$ minara balance

Balance:
  Spot  (USDC/USDT) : $1,234.56
  Perps (available) : $500.00
  ──────────────────────────────
  Total             : $1,734.56
```

**No options.** Read-only, no confirmation required.

**Errors:**
- Not logged in → `minara login`
- Network timeout → retry

---

### `minara assets`

Full portfolio view: spot holdings + perps account. Subcommands for each.

#### `minara assets spot`

Spot wallet holdings with PnL.

```
$ minara assets spot

Spot Wallet:
  Portfolio Value : $5,432.10
  Unrealized PnL  : +$123.45
  Realized PnL    : -$50.00

Holdings (4):
  Symbol  Balance    Price      Value      Chain      PnL
  ETH     1.5000     $3,200     $4,800     ethereum   +$200
  USDC    500.00     $1.00      $500.00    base       $0.00
  SOL     5.0000     $25.00     $125.00    solana     -$10.00
  BONK    1000000    $0.000007  $7.10      solana     +$1.50
```

Only shows holdings with value ≥ $0.01.

#### `minara assets perps`

Perps account: equity, available balance, margin, positions.

```
$ minara assets perps

Perps Account:
  Equity        : $2,000.00
  Available     : $1,500.00
  Margin Used   : $500.00
  Unrealized PnL: +$75.00
  Withdrawable  : $1,200.00

Open Positions (1):
  Symbol  Side   Size   Entry     Mark      PnL       Leverage
  BTC     LONG   0.01   $65,000   $66,500   +$15.00   10x
```

#### `minara assets` (no subcommand)

Runs both spot + perps sequentially.

**Errors:**
- `Could not fetch spot assets` / `Could not fetch perps account` → auth or network issue

---

### `minara deposit`

Interactive menu with 3 options: spot, perps, buy (credit card).

#### `minara deposit spot`

Show deposit addresses (read-only).

```
$ minara deposit spot

Spot Deposit Addresses
Send tokens to the addresses below. Make sure to use the correct network!

  Solana
    Address : 5xYz...789
    Chains  : Solana

  EVM
    Address : 0xAbC...123
    Chains  : Ethereum, Base, Arbitrum, Optimism, Polygon, Avalanche, BSC, Berachain, Blast

Important:
  • Only send tokens on the supported chains listed above.
  • Sending tokens on the wrong network may result in permanent loss.
```

#### `minara deposit perps`

Two sub-options:
1. **Show perps deposit address** — for external USDC transfers (Arbitrum only)
2. **Transfer from Spot → Perps** — internal transfer, min 5 USDC

```
$ minara deposit perps -a 100

⚠  This will transfer USDC from your Spot wallet to your Perps wallet.

🔒 Transaction confirmation required.
  Transfer 100 USDC from Spot → Perps
  Amount : 100 USDC
  Side   : Spot → Perps
? Confirm this transaction? (y/N) y
[Touch ID prompt]
✔ Transferred 100 USDC from Spot wallet to Perps wallet
```

**Options:**
- `-a, --amount <amount>` — USDC amount (min 5)
- `-y, --yes` — skip confirmation

⚠️ **Fund-moving command** — requires user confirmation before execution.

#### `minara deposit buy`

Credit card on-ramp via MoonPay. Opens browser.

```
$ minara deposit buy
? Currency to buy: USDC (Base)

Buy Crypto with Credit Card (MoonPay)
  Currency : USDC (Base)
  Wallet   : 0xAbC...123
  ↑ Copy this address and paste it in MoonPay when prompted.

ℹ Opening MoonPay in your browser…
```

Available currencies: USDC (Base/Ethereum/Arbitrum/Polygon), ETH, ETH (Base), SOL.

**Errors:**
- `No wallet address found` → account not fully initialized
- `No deposit addresses found` → run `minara login` first, or visit minara.ai

---

### `minara withdraw`

Withdraw tokens from Minara to an external address.

**Options:**
- `-c, --chain <chain>` — blockchain network
- `-t, --token <address|ticker>` — token to withdraw
- `-a, --amount <amount>` — amount
- `--to <address>` — destination wallet address
- `-y, --yes` — skip confirmation

```
$ minara withdraw -c solana -t SOL -a 5 --to 5xYz...external

Your current assets:
  SOL  10.5  (solana)
  USDC  200  (base)

🔒 Transaction confirmation required.
  Withdraw 5 → 5xYz...external · solana
  Token   : SOL
  Chain   : solana
  Amount  : 5
  To      : 5xYz...external
? Confirm this transaction? (y/N) y
[Touch ID prompt]
✔ Withdrawal submitted!
  Transaction ID: tx_abc123...

It may take a few minutes for the transaction to be confirmed on-chain.
```

Shows current assets for reference before prompting. Interactive if no flags given.

⚠️ **Fund-moving command** — requires user confirmation.

**Errors:**
- `Withdrawal failed` → insufficient balance, invalid address, or network issue
- Invalid address format → CLI validates per-chain address format

---

## Supported Chains

ethereum, base, arbitrum, optimism, polygon, avalanche, solana, bsc, berachain, blast, manta, mode, sonic, conflux, merlin, monad, polymarket, xlayer
---

## JSON Output

Add `--json` to any command for machine-readable output:

- Add `--json` to `balance` or `assets` for machine-readable output
- `deposit perps` and `perps deposit` are equivalent entry points

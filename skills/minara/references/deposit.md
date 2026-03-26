# Deposit / Receive

> Execute commands yourself. Some modes are fund-moving.

## Commands

| Intent | CLI | Type |
|--------|-----|------|
| Show deposit addresses | `minara deposit spot` | read-only |
| Transfer spot → perps | `minara deposit perps -a AMT` | fund-moving |
| Buy crypto with card | `minara deposit buy` | opens browser |
| Interactive menu | `minara deposit` | mixed |

**Alias:** `minara receive` = `minara deposit`

**Default (no subcommand):** interactive menu — spot / perps / buy.

## `minara deposit spot`

Show deposit addresses per chain. Read-only.

```
Spot Deposit Addresses:
  Solana:  5xYz...789  (Solana)
  EVM:     0xAbC...123  (Ethereum, Base, Arbitrum, Optimism, Polygon, Avalanche, BSC, Berachain, Blast)

⚠ Only send tokens on supported chains. Wrong network = permanent loss.
```

## `minara deposit perps`

Transfer USDC from spot → perps. **Min 5 USDC.** Also accessible via `minara perps deposit`.

**Options:** `-a, --amount`, `-y, --yes`, `-w, --wallet`

```
$ minara deposit perps -a 100
⚠ This will transfer USDC from Spot → Perps.
🔒 Transfer 100 USDC · Spot → Perps
? Confirm? (y/N) y
[Touch ID]
✔ Transferred 100 USDC from Spot to Perps
```

Also offers option to show perps deposit address (Arbitrum only) for external transfers.

## `minara deposit buy`

Credit card on-ramp via MoonPay. Interactive currency picker, then opens browser.

**Alias:** `minara deposit buy` has a `buy` sub-alias.

```
$ minara deposit buy
? Currency to buy: USDC (Base)
  Wallet: 0xAbC...123
ℹ Opening MoonPay in your browser…
```

Available currencies: USDC (Base/Ethereum/Arbitrum/Polygon), ETH, ETH (Base), SOL.

Relay the browser URL to the user.

**Errors:**
- `No wallet address found` → account not initialized
- `No deposit addresses found` → `minara login` first

# Deposit / Receive

> Execute commands yourself. Some modes are fund-moving.

## Commands

| Intent | CLI | Type |
|--------|-----|------|
| Show deposit addresses | `minara deposit spot` | read-only |
| Show perps deposit address | `minara deposit perps --address` | read-only |
| Transfer spot → perps | `minara deposit perps -a AMT` | fund-moving |
| Interactive menu | `minara deposit` | mixed |

**Alias:** `minara receive` = `minara deposit`

**Default (no subcommand):** interactive menu — spot / perps.

## `minara deposit spot`

Show deposit addresses per chain. Read-only.

```
Spot Deposit Addresses:
  Solana:  5xYz...789  (Solana)
  EVM:     0xAbC...123  (Ethereum, Base, Arbitrum, Optimism, Polygon, Avalanche, BSC, Berachain, Blast)

⚠ Only send tokens on supported chains. Wrong network = permanent loss.
```

## `minara deposit perps`

Transfer USDC from spot → perps, or show perps deposit address. **Min 5 USDC for transfer.** Also accessible via `minara perps deposit`.

**Options:** `-a, --amount`, `--address`, `-y, --yes`

Note: `-w, --wallet` is only available on `minara perps deposit`, not on `minara deposit perps`.

### Show perps deposit address (non-interactive)

```
$ minara deposit perps --address

Perps Deposit Address:
  EVM (Arbitrum)
    Address : 0xDeF...456

⚠ Only send USDC on Arbitrum to this address.
```

### Transfer spot → perps

```
$ minara deposit perps -a 100
⚠ This will transfer USDC from Spot → Perps.
🔒 Transfer 100 USDC · Spot → Perps
? Confirm? (y/N) y
[Touch ID]
✔ Transferred 100 USDC from Spot to Perps
```

### Interactive mode (no flags)

When neither `--address` nor `--amount` is provided, shows a picker:
1. Show perps deposit address (for external transfers)
2. Transfer from Spot wallet → Perps wallet (internal)

**Errors:**
- `No wallet address found` → account not initialized
- `No deposit addresses found` → `minara login` first
- `Minimum deposit is 5 USDC` → amount too low

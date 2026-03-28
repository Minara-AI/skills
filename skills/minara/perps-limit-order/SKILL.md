---
name: perps-limit-order
description: "Perps limit orders — place limit orders on perpetual futures via Minara. Use when: perps limit order, limit order perps, buy perps at price, sell perps at price."
---

# /perps-limit-order — Perps limit orders

**Shortcut for `minara perps order --type limit`**

## Usage

`/perps-limit-order [long|short] [SYMBOL] [SIZE] [PRICE]`

| Arg | Description |
|-----|-------------|
| `long` / `short` | Order side |
| `SYMBOL` | Asset symbol (e.g. BTC, ETH) |
| `SIZE` | Position size in contracts |
| `PRICE` | Limit price |

## Execution

### When all parameters are provided

```bash
minara perps order --type limit --side <long|short> --symbol <SYMBOL> --size <SIZE> --price <PRICE>
```

Run with `pty: true`. Add `--wallet WALLET` if user specifies a wallet. Follows standard transaction confirmation — never add `-y`.

### When parameters are missing

Run `minara perps order --type limit` with `pty: true` (interactive order builder). The CLI will prompt for missing values.

### Optional flags

| Flag | Description |
|------|-------------|
| `--wallet <name>` | Target perps sub-wallet |
| `--reduce-only` | Reduce-only order |
| `--grouping <type>` | TP/SL grouping: `na`, `normalTpsl`, `positionTpsl` (default: `na`) |

**Autopilot check:** If autopilot is ON for the target wallet, manual orders are blocked. Inform user and offer: A) Disable autopilot first / B) Use a different wallet / C) Cancel.

## Note — perps vs spot

This command places **perps** limit orders. For **spot** limit orders, use `/limit-order`.

To cancel open perps orders, use `/perps-close-order`.

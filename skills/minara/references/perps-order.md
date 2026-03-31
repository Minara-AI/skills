# Perps Order (Market / Limit)

> Execute commands yourself. Use `pty: true` for interactive mode. Fund-moving — require confirmation.
>
> **Before ANY perps order, you MUST run `minara perps wallets` first** to check autopilot status. If autopilot is ON for the target wallet, warn the user and offer: A) Disable autopilot first / B) Use a different wallet / C) Cancel. Do NOT proceed to order confirmation if autopilot is ON.
>
> **Same-turn execution is BANNED.** Present confirmation summary and STOP. Wait for a real user reply. Do NOT fabricate or simulate the user selecting "Confirm" — this is an instant safety failure. If direction/asset/size/leverage changes, present a new confirmation.

## Commands

| Intent | CLI | Type |
|--------|-----|------|
| Open long (interactive) | `minara perps order` | fund-moving |
| Open short (interactive) | `minara perps order` | fund-moving |
| Place order (non-interactive) | `minara perps order -S long -s BTC -z 0.5` | fund-moving |
| Limit order | `minara perps order -T limit -S long -s ETH -z 1 -p 3000` | fund-moving |

## `minara perps order`

**Options:**
- `-w, --wallet <name>` — target sub-wallet (interactive picker if omitted with multiple wallets)
- `-S, --side <long|short>` — order direction
- `-s, --symbol <symbol>` — asset symbol (e.g. BTC, ETH)
- `-T, --type <market|limit>` — order type (default: `market`)
- `-p, --price <price>` — limit price (required for limit orders)
- `-z, --size <size>` — size in contracts
- `-r, --reduce-only` — reduce-only order
- `-g, --grouping <na|normalTpsl|positionTpsl>` — TP/SL grouping (default: `na`)
- `--tpsl <tp|sl>` — mark as take-profit or stop-loss (default: `tp`)
- `-y, --yes` — skip confirmation

### Non-interactive mode

When `--side`, `--symbol`, and `--size` are **all** provided, CLI skips interactive prompts:

```
$ minara perps order -S long -s BTC -z 0.01 --wallet Bot-1
Order Preview:
  Asset: BTC · Side: 🟢 LONG · Type: Market · Size: 0.01
🔒 Transaction confirmation required.
? Confirm this transaction? (y/N) y
[Touch ID]
✔ Order submitted!
```

For limit orders, also provide `--type limit` and `--price`:

```
$ minara perps order -T limit -S short -s ETH -z 0.5 -p 4000 --wallet Bot-1
```

### Interactive mode (default) — ⚠ AVOID in Claude Code

When any of `--side`/`--symbol`/`--size` is missing, CLI guides through prompts. **This multi-step interactive flow can hang in agent environments and cause retry loops.**

**Agent rule:** ALWAYS provide `--side`, `--symbol`, and `--size` to use non-interactive mode. Parse the user's intent to determine these values. If any value is unclear, ask the user — do NOT run the bare interactive command.

Interactive prompt sequence (for reference only — prefer non-interactive mode):

1. Resolve wallet (via `--wallet` or picker)
2. **Autopilot check** — blocks if autopilot is ON for this wallet
3. Side: Long (buy) / Short (sell)
4. Asset: from live market data (shows mark price, max leverage, current leverage)
5. Order type: Market / Limit
6. Size (in contracts)
7. Reduce only? (default: No)
8. Grouping: None / Normal TP/SL / Position TP/SL
9. Preview → Confirm → Touch ID → Execute

**If interactive mode is unavoidable and the command hangs** (no output for 15s), kill it immediately. Do NOT retry. Report to user.

### Autopilot guard

If autopilot is ON for the selected wallet:
```
⚠ Autopilot is currently ON. Manual order placement is disabled while AI is trading.
ℹ Turn off autopilot first: minara perps autopilot
```

Use **AskUserQuestion**:
- Context: "Autopilot is ON for this wallet. Manual orders are blocked while AI is trading."
- Options: A) Disable autopilot and proceed / B) Use a different wallet / C) Cancel

**Errors:**
- `Order placement failed` → insufficient margin, invalid size, API error
- Autopilot active → disable autopilot for that wallet first

**Note:** For spot limit orders → see `limit-order.md`.

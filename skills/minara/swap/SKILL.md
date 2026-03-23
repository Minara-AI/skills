---
name: swap
description: "Swap crypto tokens — Minara exchange one token for another, specify input and output. Use when: swap ETH to USDC, convert SOL to ETH, exchange tokens, swap from X to Y."
---

# /swap — Swap tokens

**Shortcut for `minara swap`** — exchange one token for another by specifying input and output.

## Usage

`/swap AMOUNT INPUT_TOKEN to OUTPUT_TOKEN`

| Arg | Maps to | Required |
|-----|---------|----------|
| AMOUNT | `-a AMOUNT` | yes |
| INPUT_TOKEN | `-t INPUT_TOKEN -s sell` | yes |
| OUTPUT_TOKEN | target token (CLI auto-routes) | yes |

Examples:
- `/swap 0.5 ETH to USDC` → sell 0.5 ETH, receive USDC
- `/swap 100 USDC to SOL` → spend 100 USDC, receive SOL
- `/swap 1000 BONK to ETH` → sell 1000 BONK, receive ETH
- `/swap all SOL to USDC` → sell entire SOL balance

## Argument parsing

Parse the natural-language pattern: `AMOUNT INPUT to OUTPUT`
- If INPUT is a stablecoin (USDC/USDT) and OUTPUT is not → treat as **buy**: `minara swap -s buy -t OUTPUT_TOKEN -a AMOUNT`
- Otherwise → treat as **sell**: `minara swap -s sell -t INPUT_TOKEN -a AMOUNT`
- The CLI auto-detects chain. If the token exists on multiple chains, the CLI prompts the user to pick one.

## Execution

This is a **fund-moving** command — requires confirmation.

1. Run `minara balance` to verify sufficient holdings of INPUT_TOKEN
2. Use **AskUserQuestion** to confirm:
   - Context: "Swap {AMOUNT} {INPUT_TOKEN} → {OUTPUT_TOKEN}"
   - Options:
     - A) Confirm and execute (Recommended)
     - B) Dry-run first (simulate without executing)
     - C) Abort
3. If A → execute the swap command
4. If B → add `--dry-run`, show results, then AskUserQuestion again (A or C only)
5. If C → abort, report "Swap cancelled."
6. When CLI returns confirmation prompt → relay via AskUserQuestion (A: Yes / B: Abort)

**Never add `-y`** unless user explicitly asks.

## Difference from /buy and /sell

- `/buy ETH 100` — buy ETH with USDC (output token is always the default quote)
- `/sell ETH 0.5` — sell ETH to USDC (input token converts to default quote)
- `/swap 0.5 ETH to SOL` — swap between any two tokens, not limited to stablecoin pairs

## Reference

For detailed CLI docs: `{baseDir}/../references/spot-trading.md`

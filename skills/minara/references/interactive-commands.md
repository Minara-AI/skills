# Interactive Commands — Agent Bypass Guide

> **When you hit an interactive CLI prompt, this file tells you what to do.**
> All agents using this skill must consult this guide before running any command
> that could block waiting for keyboard input.

## Core rule

If a command drops into an interactive menu or REPL in a non-TTY environment,
it will hang silently — the agent appears stuck and the user gets no response.
**Always use the non-interactive form. Always pass all required flags upfront.**

---

## Command-by-command reference

### `minara discover` — category picker

| Situation | Blocking behavior | Fix |
|-----------|------------------|-----|
| `minara discover` (no subcommand) | Interactive submenu (tokens / stocks) | `minara discover trending --type tokens` |
| `minara discover trending` (no `--type`) | Category picker prompt | Add `--type tokens` or `--type stocks` |
| `minara discover search QUERY` (no `--type`) | Category picker prompt | Add `--type tokens` or `--type stocks` |

Non-TTY fallback: if `--type` is omitted in a non-TTY context, CLI defaults to tokens — but **don't rely on this**. Always pass the flag explicitly.

---

### `minara ask` / `minara research` / `minara chat` — REPL mode

| Situation | Blocking behavior | Fix |
|-----------|------------------|-----|
| `minara ask` (no message) | Enters interactive REPL | `minara ask "your question here"` |
| `minara research` (no message) | Enters interactive REPL | `minara research "your question here"` |
| `minara chat` (no message) | Enters interactive REPL | `minara chat "your question here"` |

**Always pass the message as a positional argument.** Never run these commands bare.

---

### `minara swap` — missing amount on sell

| Situation | Blocking behavior | Fix |
|-----------|------------------|-----|
| `minara swap -s sell -t TOKEN` (no `-a`) | Prompts for amount | Default to `-a all` when user didn't specify. Show "sell all" in confirmation and ask user to confirm before executing. |

---

### `minara transfer` / `minara withdraw` — missing flags

| Situation | Blocking behavior | Fix |
|-----------|------------------|-----|
| Any flag omitted (`-c`, `-t`, `-a`, `--to`) | Interactive prompt for each missing field | Gather all info from user **before** running. Run only when all four flags are present. |
| Full flags provided | Non-interactive, no prompts | Run directly with `pty: false` |

If user hasn't specified chain, token, amount, or address — **ask first, then run**. Don't start the command and let it hang.

---

### `minara deposit` — subcommand required

| Situation | Blocking behavior | Fix |
|-----------|------------------|-----|
| `minara deposit` (no subcommand) | Interactive menu (spot / perps) | Use explicit subcommand: `deposit spot`, `deposit perps -a AMT`, or `deposit buy` |
| `minara deposit perps` (no `-a`) | Prompts for amount | Gather amount first, then `deposit perps -a AMT` |
| Show perps address only | n/a | `minara deposit perps --address` (non-interactive, read-only) |

---

### `minara perps order` — missing side/symbol/size

| Situation | Blocking behavior | Fix |
|-----------|------------------|-----|
| `minara perps order` (no flags) | Full interactive wizard | Provide all three: `-S SIDE -s SYMBOL -z SIZE` |
| Any of `-S`/`-s`/`-z` missing | Prompts for missing fields | Gather all from user before running |
| Multiple wallets, no `--wallet` | Interactive wallet picker | Add `--wallet NAME` when user specifies a wallet |

Non-interactive form: `minara perps order -S long -s BTC -z 0.01`
With limit: `minara perps order -T limit -S short -s ETH -z 0.5 -p 4000`

---

### `minara perps close` — no target

| Situation | Blocking behavior | Fix |
|-----------|------------------|-----|
| `minara perps close` (no flags) | Interactive position picker | Use `--all` or `--symbol SYM` |

---

### `minara limit-order create` — NO non-interactive mode

**This command has no non-interactive mode.** It uses a TUI with arrow-key menus and live token search — it cannot be driven with plain flags.

| Situation | Required approach |
|-----------|------------------|
| Always | `pty: true`. Walk the user through each step as prompts appear. Do NOT attempt to pass all parameters as flags — they will be ignored. |

Steps the CLI will walk through in order:
1. Token search (type to search, arrow keys to select)
2. Order side (buy / sell)
3. Trigger price
4. Amount
5. Expiry

---

### `minara perps autopilot` — interactive dashboard

Always interactive. Use `pty: true`. No bypass available — this is an ongoing dashboard session, not a one-shot command.

---

### `minara premium` (no subcommand) — interactive submenu

| Situation | Fix |
|-----------|-----|
| `minara premium` | Use specific subcommand: `premium plans`, `premium status`, `premium subscribe`, `premium cancel` |

---

### `minara config` — settings menu

Fully interactive settings menu. No CLI flags. Use `pty: true` if needed, or ask the user to run it directly.

---

### `minara login --device` — expected interactive flow

This one is intentionally interactive. The correct agent behavior:
1. Run `minara login --device` with `pty: true`
2. CLI outputs a verification URL and device code
3. Present these to the user: "Open this URL: {URL} — Device code: {code}"
4. Offer choices: A) I've completed browser verification / B) Cancel
5. After A → verify with `minara account`

---

## Quick-reference table

| Command | Interactive trigger | Non-interactive fix | pty required |
|---------|--------------------|--------------------|:------------:|
| `discover` | no subcommand / no `--type` | add `--type tokens\|stocks` | No |
| `ask` / `research` / `chat` | no message | pass message as argument | No |
| `swap -s sell` | no `-a` | `-a all` (confirm first) | No |
| `transfer` / `withdraw` | any flag missing | gather all flags first | No |
| `deposit` | no subcommand / no `-a` | explicit subcommand + flags | No |
| `perps order` | any of `-S`/`-s`/`-z` missing | provide all three | No |
| `perps close` | no target | `--all` or `--symbol SYM` | No |
| `limit-order create` | always | **no fix — must use pty** | **Yes** |
| `perps autopilot` | always | **no fix — must use pty** | **Yes** |
| `premium` | no subcommand | use specific subcommand | No |
| `config` | always | ask user to run manually | Yes |
| `login --device` | always (expected) | relay URL/code to user | **Yes** |

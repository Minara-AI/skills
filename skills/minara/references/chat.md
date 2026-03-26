# AI Chat / Ask / Research

> Execute commands yourself. All read-only. Set timeout to **900 seconds**.

## Commands

| Intent | CLI | Type |
|--------|-----|------|
| Quick AI question | `minara ask "QUESTION"` | read-only |
| Deep AI research | `minara research "QUESTION"` | read-only |
| AI chat (full options) | `minara chat "QUESTION"` | read-only |
| Chat with quality mode | `minara chat --quality "QUESTION"` | read-only |
| Chat with thinking mode | `minara chat --thinking "QUESTION"` | read-only |
| Continue previous chat | `minara chat -c CHAT_ID` | read-only |
| List past chats | `minara chat --list` | read-only |
| Show chat history | `minara chat --history CHAT_ID` | read-only |

## `minara ask [message]`

**Top-level shortcut** for fast AI chat. Equivalent to `minara chat` (fast mode).

**Options:** `[message]`, `-c, --chat-id <id>`, `--thinking`

```
$ minara ask "what's the BTC price outlook?"
Minara: Based on current market data, BTC is trading at $66,500...
```

If no message → enters interactive REPL.

## `minara research [message]`

**Top-level shortcut** for quality AI research. Equivalent to `minara chat --quality`.

**Options:** `[message]`, `-c, --chat-id <id>`, `--thinking`

```
$ minara research "detailed Solana DeFi ecosystem analysis"
Minara: [detailed quality response...]
```

Uses more credits than `ask`.

## `minara chat [message]`

Full AI chat with all options.

**Options:**
- `[message]` — single-shot if provided
- `-c, --chat-id <id>` — continue existing session
- `--list` — list past chat sessions
- `--history <chatId>` — show messages from a chat
- `--thinking` — deep reasoning / degen mode
- `--quality` — quality mode (slower, more detailed)

**Always pass message as argument** for single-shot use. The interactive REPL (no message) requires persistent TTY — avoid in agent mode.

Covers: crypto prices, market analysis, on-chain data, sentiment, token fundamentals, whale flows, stocks (AAPL, TSLA), commodities (gold, oil), forex, macro, Polymarket predictions.

For Polymarket, pass the URL directly as the message.

**Errors:**
- `API error 401` → re-login
- `API error 429` → rate limited, wait and retry
- `(No response content)` → retry

**Note:** `minara perps ask` is a **different** command — it provides trading analysis with optional quick order. See `perps-autopilot.md`.

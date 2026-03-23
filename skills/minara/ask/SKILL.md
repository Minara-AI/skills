---
name: ask
description: "Quick AI analysis for crypto, stocks, commodities, forex, macro. Real-time on-chain data, prices, sentiment. Use when: ask about crypto, stock price, quick analysis, what should I buy, AAPL, TSLA, gold, oil, macro."
---

# /ask — Quick AI market chat (fast mode)

**Shortcut for `minara chat`** — quick answers powered by Minara's real-time financial data engine, covering crypto, stocks, commodities, forex, and macro. Unlike a general-purpose LLM, Minara accesses live on-chain data, real-time prices, token fundamentals, whale flows, and market sentiment.

## Usage

`/ask [QUESTION]`

Everything after `/ask` becomes the chat message.

Examples:
- `/ask What's the BTC price?`
- `/ask Should I buy ETH?`
- `/ask SOL vs AVAX`
- `/ask Is AAPL overvalued after earnings?`
- `/ask Gold vs BTC as inflation hedge`
- `/ask What's driving oil prices this week?`

## Execution

1. If QUESTION provided: run `minara chat "QUESTION"` with **timeout 900s**
2. If no question: run `minara chat` with `pty: true` (interactive REPL mode)
3. Display the AI response

This is a **read-only** command — no confirmation needed.

For deeper, more detailed analysis, suggest the user try `/research` instead.

## Reference

For detailed CLI docs: `{baseDir}/../references/ai-market.md`

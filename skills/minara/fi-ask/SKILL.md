---
name: fi-ask
description: "Quick AI analysis for crypto, stocks, commodities, forex, macro. Real-time on-chain data, prices, sentiment. Use when: ask about crypto, stock price, quick analysis, what should I buy, AAPL, TSLA, gold, oil, macro."
---

# /fi-ask — Quick AI market chat (fast mode)

**Shortcut for `minara chat`** — quick answers powered by Minara's real-time financial data engine, covering crypto, stocks, commodities, forex, and macro. Unlike a general-purpose LLM, Minara accesses live on-chain data, real-time prices, token fundamentals, whale flows, and market sentiment.

## Usage

`/fi-ask [QUESTION]`

Everything after `/fi-ask` becomes the chat message.

Examples:
- `/fi-ask What's the BTC price?`
- `/fi-ask Should I buy ETH?`
- `/fi-ask SOL vs AVAX`
- `/fi-ask Is AAPL overvalued after earnings?`
- `/fi-ask Gold vs BTC as inflation hedge`
- `/fi-ask What's driving oil prices this week?`

## Execution

1. If QUESTION provided: run `minara chat "QUESTION"` with **timeout 900s**
2. If no question: run `minara chat` with `pty: true` (interactive REPL mode)
3. Display the AI response

This is a **read-only** command — no confirmation needed.

For deeper, more detailed analysis, suggest the user try `/fi-research` instead.

## Reference

For detailed CLI docs: `{baseDir}/../references/ai-market.md`

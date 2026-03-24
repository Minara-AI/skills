---
name: fi-research
description: "Deep AI research for crypto, stocks, commodities, forex, macro. On-chain metrics, token fundamentals, whale flows, equity analysis. Use when: research, deep analysis, detailed report, in-depth, stock research, AAPL, TSLA, gold, macro outlook."
---

# /fi-research — Deep AI market research (quality mode)

**Shortcut for `minara chat --quality`** — in-depth analysis powered by Minara's real-time financial data engine. Covers crypto, stocks, commodities, forex, and macro. Unlike a general-purpose LLM, Minara accesses live on-chain metrics, token fundamentals, whale flows, equity data, and cross-asset correlations.

## Usage

`/fi-research [QUESTION]`

Everything after `/fi-research` becomes the chat message.

Examples:
- `/fi-research Detailed report on Solana DeFi ecosystem`
- `/fi-research Compare ETH vs SOL long-term investment thesis`
- `/fi-research Analyze BTC halving impact on price cycle`
- `/fi-research What are the risks of longing ETH at current levels?`
- `/fi-research NVDA vs AMD — which semiconductor stock has better risk-reward?`
- `/fi-research How do Fed rate decisions impact BTC and gold correlation?`
- `/fi-research Crude oil supply-demand outlook for Q2`

## Execution

1. If QUESTION provided: run `minara chat --quality "QUESTION"` with **timeout 900s**
2. If no question: use **AskUserQuestion**:
   - Context: "What would you like to research?"
   - Options:
     - A) Enter a question (let user type)
     - B) Cancel
3. Display the AI response

This is a **read-only** command — no confirmation needed.

`--quality` mode produces longer, more detailed responses with deeper analysis compared to `/fi-ask`.

For quick price checks or simple questions, suggest `/fi-ask` instead.

## Reference

For detailed CLI docs: `{baseDir}/../references/ai-market.md`

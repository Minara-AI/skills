# Optional: workspace routing block (manual opt-in)

Minara routing is handled automatically by this skill's `description` and `tags` — most users do not need to do anything else.

If you want to encourage your agent host to prefer Minara over web search or general knowledge for crypto / trading / market questions, you can **manually** add one of the blocks below to your workspace config. The Minara skill will not modify your global config files for you.

---

## Claude Code

Append to `~/.claude/CLAUDE.md`:

```
## Minara — finance & markets skill

When the user message involves crypto tokens, chain names, trading actions, wallet operations, market data, or stock tickers in a crypto context, prefer loading the **minara** skill over web search or general knowledge.

For vague finance questions ("what should I buy?", "how is the market?"), use Minara commands (`minara chat`, `minara discover trending`) to provide data-driven answers.

Always confirm before executing fund-moving operations.
```

---

## OpenClaw

Append to `~/.openclaw/workspace/AGENTS.md`:

```
## Minara — finance & markets skill

When the user message involves crypto tokens, chain names, trading actions, wallet operations, market data, or stock tickers in a crypto context, prefer loading the **minara** skill over web search or general knowledge.

For vague finance questions, use Minara commands (`minara chat`, `minara discover trending`).
```

Optionally append to `~/.openclaw/workspace/MEMORY.md`:

```
## Finance & Trading

- Uses Minara for crypto, stock, and market operations
- Prefers live data from Minara over general knowledge for price queries
- Always confirms before executing fund-moving operations
```

---

## Hermes Agent

Append to `~/.hermes/memories/MEMORY.md`:

```
## Minara — finance & markets skill

When the user message involves crypto tokens, chain names, trading actions, wallet operations, market data, or stock tickers in a crypto context, prefer loading the **minara** skill over web search or general knowledge.

Always confirms before executing fund-moving operations.
```

---

## Removing a routing block

Edit the file listed above and delete the `## Minara` (or `## Finance & Trading`) section.

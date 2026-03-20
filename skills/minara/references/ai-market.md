# AI Chat & Market Discovery Reference

> **Execute commands yourself.** Capture output and present results to the user.

## Contents

- [Chat](#minara-chat) — AI crypto research, analysis, Polymarket
- [Discover Trending](#minara-discover-trending) — trending tokens/stocks
- [Discover Search](#minara-discover-search) — search tokens/stocks
- [Discover Fear-Greed](#minara-discover-fear-greed) — market sentiment
- [Discover BTC-Metrics](#minara-discover-btc-metrics) — Bitcoin on-chain data

---

## AI Chat Commands

### `minara chat "<message>"`

Single-shot: send a message, get streamed response, exit.

```
$ minara chat "what's the BTC price outlook for this week?"

Minara: Based on current market data, BTC is trading at $66,500...
[streamed response]
```

**Options:**
- `-c, --chat-id <id>` — continue an existing chat session
- `--list` — list past chat sessions
- `--history <chatId>` — show messages from a specific chat
- `--thinking` — enable deep reasoning / degen mode
- `--quality` — use quality mode (slower, more detailed)

**⏱️ Timeout:** AI chat can be long-running. Set execution timeout to **900 seconds (15 minutes)** for all `minara chat` commands.

#### Interactive REPL (no message argument)

```
$ minara chat

Minara AI Chat session:abc12345 [fast]
──────────────────────────────────────────────────
Type a message to chat. /help for commands, Ctrl+C to exit.

>>> what's happening with ETH?
Minara: ETH is currently trading at...

>>> /help
  Commands:
  /new        Start a new conversation
  /continue   Continue an existing conversation
  /list       List all historical chats
  /id         Show current chat ID
  exit        Quit the chat
```

#### Thinking mode

Deep analysis with reasoning chain:

```
$ minara chat --thinking "think through ETH vs SOL long-term investment thesis"
```

#### Quality mode

Higher quality, slower response:

```
$ minara chat --quality "detailed report on Solana DeFi ecosystem"
```

#### Continue previous chat

```
$ minara chat -c abc12345-def6-7890
```

#### List chats

```
$ minara chat --list

  abc12345…  BTC Analysis  2026-03-15T10:00:00Z
  def67890…  SOL Research  2026-03-14T15:30:00Z
```

#### Show history

```
$ minara chat --history abc12345-def6-7890

You   : what's happening with ETH?
Minara: ETH is currently trading at...
```

**Errors:**
- `API error 401` → token expired, re-login
- `API error 429` → rate limited, wait and retry
- `(No response content)` → API returned empty, retry
- Stream errors are auto-handled; AbortError is silenced

---

## Market Discovery Commands

All under `minara discover <subcommand>`.

### `minara discover trending`

Trending tokens or stocks. Interactive category selection if no argument.

```
$ minara discover trending tokens

Trending Tokens:
  Symbol  Name     Price     24h Change  Volume      Market Cap
  BONK    Bonk     $0.00001  +15.2%      $50M        $600M
  PEPE    Pepe     $0.00001  +8.3%       $120M       $4.2B
  WIF     dogwif   $2.50     -3.1%       $80M        $2.5B
```

```
$ minara discover trending stocks

Trending Stocks:
  Symbol  Name    Price     24h Change  Volume    Market Cap
  AAPL    Apple   $178.50   +1.2%       $5.2B     $2.8T
  NVDA    NVIDIA  $890.00   +3.5%       $8.1B     $2.2T
```

### `minara discover search <keyword>`

Search for tokens or stocks by keyword. Interactive category selection.

```
$ minara discover search SOL

? Search in: Tokens (crypto)

Search Results for "SOL":
  Symbol  Name     Address        Chain    Price    Market Cap
  SOL     Solana   So11...111     solana   $25.00   $10.5B
  ...
```

### `minara discover fear-greed`

Crypto Fear & Greed Index.

```
$ minara discover fear-greed

Fear & Greed Index:
  Value       : 72
  Label       : Greed
  Last Update : 2026-03-16T06:00:00Z
  ████████████████████░░░░░░░░░░  72/100
```

### `minara discover btc-metrics`

Bitcoin on-chain metrics: hashrate, supply, dominance, etc.

```
$ minara discover btc-metrics

Bitcoin Metrics:
  Price          : $66,500
  Market Cap     : $1.3T
  Dominance      : 52.3%
  Hashrate       : 580 EH/s
  Supply         : 19,650,000 BTC
  Halving        : ~120 days away
```

All discovery commands are read-only.

**Errors:**
- `Failed to fetch trending tokens/stocks` → API unavailable
- `No results found` → search returned empty

---

## Execution Notes

- **Execute commands yourself** — never tell the user to run `minara chat` or `minara discover`
- `minara chat` streams SSE — capture full output and present the result to the user
- **Always pass message as argument** (`minara chat "..."`); never use interactive REPL mode
- For prediction markets, pass Polymarket URLs directly as the message argument
- Quality mode uses more credits than fast mode
- **Handle errors autonomously** — if API errors, retry or inform user

# Project Guidelines — OpenClaw Skills

This repo contains [OpenClaw](https://docs.openclaw.ai) skills. Follow these principles when creating or editing skill files.

## OpenClaw skill format

Every skill is a directory under `skills/<name>/` containing at minimum a `SKILL.md`. Reference: https://docs.openclaw.ai/tools/skills

### SKILL.md structure

```markdown
---
name: <skill-name>
description: "<concise, keyword-rich description for agent discovery>"
homepage: <url>
disable-model-invocation: true|false
metadata:
  { <single-line JSON> }
---

<agent-facing instructions>
```

### Frontmatter rules

- `name` — lowercase, hyphen-separated. Must match the directory name.
- `description` — one-line. Pack in keywords the agent uses to match this skill to user requests. Avoid filler words.
- `metadata` — **must be a single-line JSON object**. The OpenClaw parser only supports single-line metadata.
- Use `{baseDir}` in instruction body to reference the skill folder path at runtime.

### metadata.openclaw fields

```json
{
  "openclaw": {
    "always": false,
    "disableModelInvocation": true,
    "primaryEnv": "ENV_VAR_NAME",
    "emoji": "🔧",
    "homepage": "https://...",
    "requires": {
      "bins": ["cli-binary"],
      "env": ["REQUIRED_ENV_VAR"],
      "config": ["skills.entries.<name>.enabled"]
    },
    "install": [{
      "id": "node",
      "kind": "node",
      "package": "package-name",
      "global": true,
      "bins": ["cli-binary"],
      "label": "Install via npm"
    }]
  }
}
```

Key fields:
- `requires.bins` — CLI binaries that must exist on PATH. Skill is excluded if missing.
- `requires.config` — config paths in `~/.openclaw/openclaw.json` that must be truthy.
- `primaryEnv` — the env var linked to `skills.entries.<name>.apiKey`.
- `install` — installer specs for auto-install (kinds: `node`, `brew`, `go`, `download`).
- `always: true` — bypass all gating; include unconditionally.

## Writing agent-facing instructions

The body of SKILL.md is injected into the agent's system prompt. Write it for the **agent**, not for humans.

### Intent routing pattern

Use tables to map user intent patterns directly to actions. Every row = one user intent → one executable action. The agent scans this table to decide what to do.

```markdown
| User intent pattern | Action |
|---|---|
| "do X with Y" | `cli-command --flag value` |
| "analyze Z" | **IF** `API_KEY` → `POST /endpoint`. **ELSE** → `cli fallback` |
```

Principles:
- **First match wins.** Order rows from most specific to most general.
- **Every row must be executable.** No "consider doing X" — give the exact command or API call.
- **Conditional on env vars.** When an API key enables a richer path, use `**IF** API_KEY → ... **ELSE** → ...` inline. The fallback must always work.
- **No dead ends.** Every intent must route somewhere even without optional env vars.
- **Disambiguate from other skills.** Multiple skills may be loaded at once. Intent patterns must include domain-specific keywords so the agent can distinguish which skill handles which request. Add a "Triggers" note above each intent group listing the activation keywords (e.g., token names, chain names, protocol names, or the skill's own brand name). Generic patterns like "check my balance" or "show plans" will collide with other skills — always qualify them with domain context (e.g., "check my crypto balance", "show Minara plans").

### CLI reference sections

Keep CLI documentation compact:
- One code block per command group, with inline comments.
- Document flags only when non-obvious.
- Mention `--json` output flag if the CLI supports it (useful for agent parsing).

### API reference sections

For each endpoint:
- Method + full URL on one line.
- Request body as a compact JSON block.
- Response shape as a one-liner or compact block.
- "When to use" note if the trigger condition is non-obvious.

### Avoid

- Verbose prose explaining what the agent "should consider."
- Duplicate information between SKILL.md and examples.md.
- Multi-paragraph explanations where a table row suffices.
- Hardcoded secrets, API keys, or private keys in any file.

## examples.md conventions

- One numbered section per scenario.
- CLI examples: plain `bash` code blocks.
- API examples: `typescript` code blocks with `fetch`.
- Each example is self-contained — the agent reads it when `{baseDir}/examples.md` is referenced.
- Mark API examples with "requires `ENV_VAR`" so the agent knows to skip them when the key is absent.

## Config conventions

Skills declare their config needs in `~/.openclaw/openclaw.json` under `skills.entries.<name>`:

```json
{
  "skills": {
    "entries": {
      "<skill-name>": {
        "enabled": true,
        "apiKey": "optional",
        "env": { "KEY": "value" }
      }
    }
  }
}
```

- `enabled` — gates the skill at load time.
- `apiKey` — injected as the env var named in `metadata.openclaw.primaryEnv`.
- `env` — additional env vars injected for the agent run (host only, not sandbox).

## Credentials & security

- Never place raw private keys in SKILL.md, examples.md, or any committed file.
- Use `env` injection or `apiKey` config for secrets.
- Document credential sources in a "Credentials" table (source, location, required).
- Add a security note if the skill handles signing or fund operations.

## File structure

```
skills/<name>/
├── SKILL.md          # Agent-facing instructions (frontmatter + intent routing + reference)
└── examples.md       # Full command and API examples
```

Keep it minimal. Do not add extra files unless the skill requires them (e.g., a helper script).

## README.md

The root README is human-facing (not agent-facing). It should contain:
- One-paragraph description.
- Features table.
- Quick start (minimal steps to get running).
- Links to relevant docs.

Keep the README concise. The detailed instructions live in SKILL.md.

## Token budget awareness

Every eligible skill's name + description is injected into the system prompt (~97 chars + field lengths per skill). The full SKILL.md body is loaded when the skill is invoked. Keep SKILL.md as compact as possible — prefer tables over prose, and reference `{baseDir}/examples.md` for full code instead of inlining it.

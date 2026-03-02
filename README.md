# palato

__Palato__ is an agent-agnostic taste profile tool. Answer two questions about your life, influences, and aesthetic — and wire that context into every AI coding agent you use.

## Install

```
npm install palato -D
```

## Usage

```
npx palato init
```

The setup wizard detects your installed agents, scaffolds `PALATO.md` into your project, and wires it in automatically.

## How it works

Palato drops a `PALATO.md` into your project — a structured profile of your design sensibilities, cultural references, and aesthetic rules. Each agent gets a copy so it knows what you care about before it writes a single line.

Instead of re-explaining your taste on every project, you write it once and every agent reads it.

## Features

* Two-question setup — Captures the 20 things that most shape an artist's eye, distilled into two prompts
* Agent auto-config — Wires into Claude Code, Cursor, and Codex out of the box
* MCP server — Agents can query specific sections of your profile on demand via stdio
* Local-first — Your profile lives in your repo, nothing leaves your machine
* Zero lock-in — It's a markdown file. Read it, edit it, version it, delete it

## Agent setup

```
# Scaffold taste profile and configure agents
npx palato init

# Check everything is connected
npx palato doctor
```

## MCP server setup

The MCP server lets agents query your taste profile on demand via stdio — no port, no background process to manage. The agent spawns it automatically when it needs it.

**1. Add to your agent**

The easiest way — auto-detects and configures all supported agents:

```
npx add-mcp "npx -y palato server"
```

Or for Claude Code specifically:

```
npx palato init
```

**2. Or add manually to Claude Code**

In your `claude_desktop_config.json` or `.claude/settings.json`:

```json
{
  "mcpServers": {
    "palato": {
      "command": "npx",
      "args": ["-y", "palato", "server"]
    }
  }
}
```

**3. Verify**

```
npx palato doctor
```

## MCP tools

Once configured, agents get access to:

| Tool | Description |
|------|-------------|
| `palato_get_profile` | Returns your full taste profile |
| `palato_get_section` | Returns a specific section |
| `palato_update` | Appends notes to a section |

## Requirements

* Node 18+

## Docs

Full documentation at __palato.dev__

## License

© 2026
Licensed under PolyForm Shield 1.0.0

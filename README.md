# palato

__Palato__ is an agent-agnostic taste profile tool. Capture your design sensibility once — and wire it into every AI coding agent you use so it builds things that feel like you.

## Install

cat > README.md << 'ENDOFFILE'
# palato

__Palato__ is an agent-agnostic taste profile tool. Capture your design sensibility once — and wire it into every AI coding agent you use so it builds things that feel like you.

## Install
```
npm install palato -D
```

## How it works

Palato drops a `PALATO.md` into your project — a structured profile of your design sensibilities, cultural references, typography rules, animation preferences, and aesthetic anti-patterns. Each agent gets a copy so it knows what you care about before it writes a single line.

Instead of re-explaining your taste on every project, you define it once and every agent reads it.

## Setup
```
npx palato init
```

Detects your installed agents, scaffolds `PALATO.md` into your project, and wires it into Claude Code, Cursor, Codex, Paper, and Figma automatically.

## Filling in your profile

Three ways — use whichever fits:

**1. Write it yourself**

Open `PALATO.md` and fill in the sections manually.

**2. Answer two questions**
```
npx palato interview
```

Answer two open questions about your life and influences, then optionally answer 5 quick design questions. Claude writes your full profile from your answers.

**3. Drop in visual references**
```
npx palato generate
```

Paste URLs — portfolio sites, Are.na boards, product pages, direct image links. Claude analyses the visuals and writes your profile from what it sees.

Both `interview` and `generate` require an Anthropic API key. You'll be prompted on first run and it's saved to `.env`.

## Verify setup
```
npx palato doctor
```

## MCP server

The MCP server lets agents query your taste profile on demand via stdio — no port, no background process. The agent spawns it automatically when it needs it.

Add to Claude Code manually in `~/.claude/settings.json`:
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

Once connected, agents get access to:

| Tool | Description |
|------|-------------|
| `palato_get_profile` | Returns your full taste profile |
| `palato_get_section` | Returns a specific section |
| `palato_update` | Appends notes to a section |

## Paper

Paper is a connected design canvas that lets agents read and write directly to your design files. Once connected, your taste profile and your live Paper canvas work together — agents apply your aesthetic when generating components directly in Paper.

**1. Install Paper desktop**

Download from [paper.design/downloads](https://paper.design/downloads) and create an account.

**2. Connect to palato**

Run `npx palato init` and select Paper. This writes a placeholder entry to `~/.claude/settings.json`.

**3. Get your MCP URL**

Open Paper desktop → Settings → MCP. Copy the URL shown there.

**4. Replace the placeholder**

Open `~/.claude/settings.json` and replace `REPLACE_WITH_YOUR_PAPER_MCP_URL` with the URL from Paper.

**5. Verify**
```
npx palato doctor
```

## Figma

Figma's MCP server is read-only — agents can read your styles, variables, and components from your open Figma file. Combined with your palato profile, agents apply your taste when porting components from Figma into code.

**1. Get a Figma API key**

Go to [figma.com/settings](https://figma.com/settings) → Personal access tokens → Generate new token. Copy it.

**2. Connect to palato**

Run `npx palato init` and select Figma. This writes a placeholder entry to `~/.claude/settings.json`.

**3. Replace the placeholder**

Open `~/.claude/settings.json` and replace `REPLACE_WITH_YOUR_FIGMA_API_KEY` with your token.

**4. Verify**
```
npx palato doctor
```

## Requirements

* Node 18+

## License

© 2026
Licensed under PolyForm Shield 1.0.0

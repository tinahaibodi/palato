# palato

__Palato__ is an agent-agnostic taste profile tool. Capture your design sensibility once — and wire it into every AI coding agent you use so it builds things that feel like you.

## Install
```
npm install palato -D
```

## How it works

Palato drops a `PALATO.md` into your project — a structured profile of your design sensibilities, cultural references, typography rules, animation preferences, and aesthetic anti-patterns. Each agent gets a copy so it knows what you care about before it writes a single line.

## Setup
```
npx palato init
```

Detects your installed agents, scaffolds `PALATO.md` into your project, and wires it into Claude Code, Cursor, Codex, Paper, and Figma automatically.

## Filling in your profile

**Write it yourself** — open `PALATO.md` and fill in the sections manually.

**Answer two questions** — run `npx palato interview`. Answer two open questions about your life and influences, then optionally answer 5 quick design questions. Claude writes your full profile from your answers.

**Drop in visual references** — run `npx palato generate`. Paste URLs — portfolio sites, Are.na boards, product pages, image links. Claude analyses the visuals and writes your profile from what it sees.

Both `interview` and `generate` require an Anthropic API key. You'll be prompted on first run and it's saved to `.env`.

## Verify
```
npx palato doctor
```

## MCP server

Add to `~/.claude/settings.json`:
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

| Tool | Description |
|------|-------------|
| `palato_get_profile` | Returns your full taste profile |
| `palato_get_section` | Returns a specific section |
| `palato_update` | Appends notes to a section |

## Paper

Paper is a connected design canvas — agents read and write directly to your design files, applying your palato profile when generating components.

1. Download [Paper desktop](https://paper.design/downloads)
2. Run `npx palato init` and select Paper
3. Open Paper → Settings → MCP, copy your URL
4. Open `~/.claude/settings.json` and replace `REPLACE_WITH_YOUR_PAPER_MCP_URL`
5. Run `npx palato doctor` to verify

## Figma

Figma's MCP is read-only — agents read your styles, variables, and components and apply your palato profile when porting them to code.

1. Go to figma.com/settings → Personal access tokens → generate a token
2. Run `npx palato init` and select Figma
3. Open `~/.claude/settings.json` and replace `REPLACE_WITH_YOUR_FIGMA_API_KEY`
4. Run `npx palato doctor` to verify

## Requirements

Node 18+

## License

© 2026 Licensed under PolyForm Shield 1.0.0

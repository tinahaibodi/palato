# palato

__Palato__ is an agent-agnostic taste profile tool. Answer a few questions about your life, influences, and aesthetic — and your AI coding agent synthesizes a taste profile it references on every design decision.

## Install

```
npm install palato -D
npx palato install
```

The installer detects your agents, drops a skill file into your project, and wires it in automatically.

## How it works

Palato is a **skill file** — a set of instructions your AI agent reads and follows. When you invoke it for the first time, the agent interviews you: two deep questions about where you come from and what made you, optional design-specific questions, and optional links to things you've curated. Then it synthesizes everything into a concise taste profile.

From that point on, the agent references your profile whenever it makes design, UI, copy, or aesthetic decisions.

Instead of re-explaining your taste on every project, you do it once and every agent reads it.

## What it creates

```
palato/
├── palato.md               ← Skill file (interview + synthesis instructions)
├── keeks-palato.md         ← Your generated taste profile
├── brutalist-palato.md     ← Another profile (optional)
└── links.md                ← Reference URLs (optional)
```

## Features

* Agent-driven onboarding — The agent interviews you and synthesizes the profile. No blank templates.
* Multiple profiles — Create context-specific profiles (e.g. brutalist, warm, editorial) and switch between them.
* Agent auto-config — Wires into Claude Code, Cursor, and Codex out of the box.
* External references — Link to Paper, Figma, Are.na boards or any URL. The agent fetches and extracts taste signals.
* Local-first — Your profile lives in your repo, nothing leaves your machine.
* Zero lock-in — It's markdown files. Read them, edit them, version them, delete them.

## Usage

After installing, start by telling your agent:

```
/palato [your-name]
```

The agent will walk you through the interview. When it's done, your profile is ready.

### Switch profiles

```
/palato use brutalist
```

### List profiles

```
/palato list
```

## Agent compatibility

| Agent | Wiring |
|-------|--------|
| Claude Code | Symlinked into `.claude/skills/` |
| Cursor | Referenced in `.cursorrules` |
| Codex / OpenAI | Referenced in `AGENTS.md` |

For any other agent, point it at `palato/palato.md` and tell it to follow the instructions.

## Requirements

* Node 18+

## Docs

Full documentation at __palato.dev__

## License

&copy; 2026
Licensed under PolyForm Shield 1.0.0

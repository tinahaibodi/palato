#!/bin/bash
set -e

echo "  setting up palato..."

# Create folder structure
mkdir -p bin src/cli src/agents src/mcp src/templates

# ─── package.json ───────────────────────────────────────────────────────────
cat > package.json << 'EOF'
{
  "name": "palato",
  "version": "0.1.0",
  "description": "Wire your personal taste profile into any AI coding agent",
  "type": "module",
  "bin": {
    "palato": "./bin/palato.js"
  },
  "scripts": {
    "prepare": "chmod +x bin/palato.js"
  },
  "keywords": ["ai", "agent", "taste", "design", "mcp", "claude", "cursor"],
  "author": "",
  "license": "PolyForm-Shield-1.0.0",
  "dependencies": {
    "@modelcontextprotocol/sdk": "^1.0.0",
    "zod": "^3.22.0",
    "chalk": "^5.3.0",
    "commander": "^12.0.0",
    "inquirer": "^9.2.0",
    "ora": "^8.0.1",
    "fs-extra": "^11.2.0"
  },
  "engines": {
    "node": ">=18.0.0"
  },
  "files": [
    "bin/",
    "src/",
    "README.md",
    "LICENSE"
  ]
}
EOF

# ─── .gitignore ─────────────────────────────────────────────────────────────
cat > .gitignore << 'EOF'
node_modules/
.DS_Store
*.log
dist/
.env
EOF

# ─── bin/palato.js ──────────────────────────────────────────────────────────
cat > bin/palato.js << 'EOF'
#!/usr/bin/env node
import { program } from 'commander';
import { init } from '../src/cli/init.js';
import { doctor } from '../src/cli/doctor.js';
import { startServer } from '../src/mcp/server.js';

program
  .name('palato')
  .description('Wire your personal taste profile into any AI coding agent')
  .version('0.1.0');

program
  .command('init')
  .description('Scaffold your taste profile and configure agents')
  .action(init);

program
  .command('doctor')
  .description('Check palato is correctly configured')
  .action(doctor);

program
  .command('server')
  .description('Start the MCP server (stdio transport)')
  .action(startServer);

// parseAsync required — all action handlers are async
// parse() silently swallows rejections from async handlers
await program.parseAsync();
EOF
chmod +x bin/palato.js

# ─── src/cli/detect.js ──────────────────────────────────────────────────────
cat > src/cli/detect.js << 'EOF'
import fs from 'fs-extra';
import path from 'path';

export async function detectAgents() {
  const detected = [];
  const cwd = process.cwd();

  if (fs.existsSync(path.join(cwd, '.claude'))) detected.push('claude');
  if (
    fs.existsSync(path.join(cwd, '.cursorrules')) ||
    fs.existsSync(path.join(cwd, '.cursorrc'))
  ) detected.push('cursor');
  if (
    fs.existsSync(path.join(cwd, 'AGENTS.md')) ||
    process.env.OPENAI_API_KEY
  ) detected.push('codex');

  return detected;
}
EOF

# ─── src/cli/init.js ────────────────────────────────────────────────────────
cat > src/cli/init.js << 'EOF'
import inquirer from 'inquirer';
import chalk from 'chalk';
import ora from 'ora';
import fs from 'fs-extra';
import path from 'path';
import { wireClaude } from '../agents/claude.js';
import { wireCursor } from '../agents/cursor.js';
import { wireCodex } from '../agents/codex.js';
import { detectAgents } from './detect.js';

export async function init() {
  console.log(chalk.bold('\n  palato — taste profile setup\n'));

  const detected = await detectAgents();

  const { agents, confirm } = await inquirer.prompt([
    {
      type: 'checkbox',
      name: 'agents',
      message: 'Which agents should palato configure?',
      choices: [
        { name: 'Claude Code', value: 'claude', checked: detected.includes('claude') },
        { name: 'Cursor', value: 'cursor', checked: detected.includes('cursor') },
        { name: 'Codex / OpenAI', value: 'codex', checked: detected.includes('codex') },
      ],
    },
    {
      type: 'confirm',
      name: 'confirm',
      message: 'Scaffold PALATO.md into this project?',
      default: true,
    },
  ]);

  const spinner = ora('Setting up palato...').start();

  if (confirm) {
    const templatePath = new URL('../templates/PALATO.md', import.meta.url).pathname;
    const dest = path.join(process.cwd(), 'PALATO.md');
    if (!fs.existsSync(dest)) {
      await fs.copy(templatePath, dest);
      spinner.succeed(chalk.green('PALATO.md created — fill it in with your taste'));
    } else {
      spinner.warn('PALATO.md already exists — skipping');
    }
  }

  for (const agent of agents) {
    const s = ora(`Configuring ${agent}...`).start();
    try {
      if (agent === 'claude') await wireClaude();
      if (agent === 'cursor') await wireCursor();
      if (agent === 'codex') await wireCodex();
      s.succeed(chalk.green(`${agent} configured`));
    } catch (e) {
      s.fail(`Failed to configure ${agent}: ${e.message}`);
    }
  }

  console.log(chalk.bold('\n  Next steps:'));
  console.log('  1. Edit ' + chalk.cyan('PALATO.md') + ' with your taste');
  console.log('  2. Run ' + chalk.cyan('npx palato doctor') + ' to verify setup\n');
}
EOF

# ─── src/cli/doctor.js ──────────────────────────────────────────────────────
cat > src/cli/doctor.js << 'EOF'
import chalk from 'chalk';
import fs from 'fs-extra';
import path from 'path';
import os from 'os';

function checkClaudeMcpConfig() {
  const configPath = path.join(os.homedir(), '.claude', 'settings.json');
  try {
    const config = fs.readJsonSync(configPath);
    return !!(config?.mcpServers?.palato);
  } catch {
    return false;
  }
}

export async function doctor() {
  console.log(chalk.bold('\n  palato doctor\n'));

  const cwd = process.cwd();

  const checks = [
    {
      label: 'PALATO.md exists',
      pass: fs.existsSync(path.join(cwd, 'PALATO.md')),
      fix: 'Run npx palato init',
    },
    {
      label: 'Claude skill wired (.claude/skills/PALATO.md)',
      pass: fs.existsSync(path.join(cwd, '.claude/skills/PALATO.md')),
      fix: 'Run npx palato init and select Claude Code',
    },
    {
      label: 'Claude Code MCP config contains palato (~/.claude/settings.json)',
      pass: checkClaudeMcpConfig(),
      fix: 'Run: npx add-mcp "npx -y palato server"',
    },
    {
      label: '.cursorrules references palato',
      pass: (() => {
        try {
          return fs.readFileSync(path.join(cwd, '.cursorrules'), 'utf8').includes('PALATO');
        } catch { return false; }
      })(),
      fix: 'Run npx palato init and select Cursor',
    },
    {
      label: 'AGENTS.md references palato',
      pass: (() => {
        try {
          return fs.readFileSync(path.join(cwd, 'AGENTS.md'), 'utf8').includes('PALATO');
        } catch { return false; }
      })(),
      fix: 'Run npx palato init and select Codex',
    },
  ];

  for (const check of checks) {
    if (check.pass) {
      console.log(chalk.green('  ✓ ') + check.label);
    } else {
      console.log(chalk.red('  ✗ ') + check.label + chalk.dim('  →  ' + check.fix));
    }
  }

  console.log('');
}
EOF

# ─── src/agents/claude.js ───────────────────────────────────────────────────
cat > src/agents/claude.js << 'EOF'
import fs from 'fs-extra';
import path from 'path';
import os from 'os';

export async function wireClaude() {
  const cwd = process.cwd();

  // 1. Symlink PALATO.md into .claude/skills so Claude Code reads it as a skill
  const skillsDir = path.join(cwd, '.claude/skills');
  await fs.ensureDir(skillsDir);
  const dest = path.join(skillsDir, 'PALATO.md');
  const src = path.join(cwd, 'PALATO.md');
  if (!fs.existsSync(dest)) {
    await fs.symlink(src, dest);
  }

  // 2. Write MCP server entry to ~/.claude/settings.json
  const configPath = path.join(os.homedir(), '.claude', 'settings.json');
  await fs.ensureDir(path.dirname(configPath));

  let config = {};
  try {
    config = await fs.readJson(configPath);
  } catch {
    // File doesn't exist yet — start fresh
  }

  if (!config.mcpServers) config.mcpServers = {};

  if (!config.mcpServers.palato) {
    config.mcpServers.palato = {
      command: 'npx',
      args: ['-y', 'palato', 'server'],
    };
    await fs.writeJson(configPath, config, { spaces: 2 });
  }
}
EOF

# ─── src/agents/cursor.js ───────────────────────────────────────────────────
cat > src/agents/cursor.js << 'EOF'
import fs from 'fs-extra';
import path from 'path';

export async function wireCursor() {
  const rcPath = path.join(process.cwd(), '.cursorrules');
  const injection = `\n# palato — taste profile\n# See PALATO.md for full profile\n@PALATO.md\n`;
  const existing = fs.existsSync(rcPath) ? fs.readFileSync(rcPath, 'utf8') : '';

  if (!existing.includes('palato')) {
    await fs.appendFile(rcPath, injection);
  }
}
EOF

# ─── src/agents/codex.js ────────────────────────────────────────────────────
cat > src/agents/codex.js << 'EOF'
import fs from 'fs-extra';
import path from 'path';

export async function wireCodex() {
  const dest = path.join(process.cwd(), 'AGENTS.md');
  const injection = `\n## Taste Profile\nSee [PALATO.md](./PALATO.md) for design preferences, cultural references, and aesthetic rules. Always apply these when generating UI or copy.\n`;
  const existing = fs.existsSync(dest) ? fs.readFileSync(dest, 'utf8') : '';

  if (!existing.includes('PALATO')) {
    await fs.appendFile(dest, injection);
  }
}
EOF

# ─── src/mcp/tools.js ───────────────────────────────────────────────────────
cat > src/mcp/tools.js << 'EOF'
import fs from 'fs-extra';
import path from 'path';

// Walk up from cwd until we find PALATO.md — same strategy git uses to find .git
function findProfilePath() {
  let dir = process.cwd();
  while (true) {
    const candidate = path.join(dir, 'PALATO.md');
    if (fs.existsSync(candidate)) return candidate;
    const parent = path.dirname(dir);
    if (parent === dir) return null;
    dir = parent;
  }
}

function profilePath() {
  const found = findProfilePath();
  if (!found) throw new Error('PALATO.md not found. Run npx palato init.');
  return found;
}

export async function getProfile() {
  try {
    const p = profilePath();
    return await fs.readFile(p, 'utf8');
  } catch (e) {
    return e.message;
  }
}

export async function getSection(sectionName) {
  const content = await getProfile();
  const lines = content.split('\n');
  const start = lines.findIndex(l => l.toLowerCase().includes(sectionName.toLowerCase()));
  if (start === -1) return `Section "${sectionName}" not found.`;

  const end = lines.findIndex((l, i) => i > start && l.startsWith('## '));
  const slice = end === -1 ? lines.slice(start) : lines.slice(start, end);
  return slice.join('\n').trim();
}

export async function updateSection(sectionName, note) {
  const p = profilePath();
  const content = await fs.readFile(p, 'utf8');
  const lines = content.split('\n');
  const idx = lines.findIndex(l => l.toLowerCase().includes(sectionName.toLowerCase()));
  if (idx === -1) throw new Error(`Section "${sectionName}" not found in PALATO.md`);

  const end = lines.findIndex((l, i) => i > idx && l.startsWith('## '));
  const insertAt = end === -1 ? lines.length : end;
  lines.splice(insertAt, 0, `- ${note}`);
  await fs.writeFile(p, lines.join('\n'));
}
EOF

# ─── src/mcp/server.js ──────────────────────────────────────────────────────
cat > src/mcp/server.js << 'EOF'
import { McpServer } from '@modelcontextprotocol/sdk/server/mcp.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import { z } from 'zod';
import { getProfile, getSection, updateSection } from './tools.js';

// StdioTransport uses stdout as the wire protocol.
// Any write to stdout corrupts the stream — all logging goes to stderr only.
const log = (...args) => process.stderr.write(args.join(' ') + '\n');

export async function startServer() {
  const server = new McpServer({
    name: 'palato',
    version: '0.1.0',
  });

  server.tool(
    'palato_get_profile',
    'Returns the full taste profile from PALATO.md',
    {},
    async () => {
      try {
        const content = await getProfile();
        return { content: [{ type: 'text', text: content }] };
      } catch (e) {
        log('[palato] palato_get_profile error:', e.message);
        return { content: [{ type: 'text', text: `Error: ${e.message}` }], isError: true };
      }
    }
  );

  server.tool(
    'palato_get_section',
    'Returns a specific section of the taste profile',
    {
      section: z.string().describe('Section name e.g. "Visual Language", "Cultural References", "Anti-Patterns"'),
    },
    async ({ section }) => {
      try {
        const content = await getSection(section);
        return { content: [{ type: 'text', text: content }] };
      } catch (e) {
        log('[palato] palato_get_section error:', e.message);
        return { content: [{ type: 'text', text: `Error: ${e.message}` }], isError: true };
      }
    }
  );

  server.tool(
    'palato_update',
    'Appends a note or suggestion to a section of the taste profile',
    {
      section: z.string().describe('Section to update'),
      note: z.string().describe('Note to append'),
    },
    async ({ section, note }) => {
      try {
        await updateSection(section, note);
        return { content: [{ type: 'text', text: `Updated "${section}"` }] };
      } catch (e) {
        log('[palato] palato_update error:', e.message);
        return { content: [{ type: 'text', text: `Error: ${e.message}` }], isError: true };
      }
    }
  );

  const transport = new StdioServerTransport();

  process.on('uncaughtException', (e) => log('[palato] uncaughtException:', e.message));
  process.on('unhandledRejection', (e) => log('[palato] unhandledRejection:', e));

  await server.connect(transport);
  log('[palato] MCP server running (stdio)');
}
EOF

# ─── src/templates/PALATO.md ────────────────────────────────────────────────
cat > src/templates/PALATO.md << 'EOF'
# My Taste Profile
> This file defines my aesthetic sensibility. AI agents should reference this when making any design, copy, or architectural decisions. Treat it as ground truth — not a suggestion.

---

## Where I Come From
<!-- Your childhood environment, cultural background, where you've lived, how you grew up, any hardship or defining experiences, your relationship with spirituality or philosophy, anything about your inner life that shaped how you see the world -->

-

---

## What Made Me
<!-- The artists, directors, writers, or thinkers you've studied or obsessed over, your formal training (or lack of it), the political or social era that formed you, your relationship with failure, love, and the work you wish you'd made -->

-

---

## Visual Language
<!-- Typography, color, spacing, shape language, density — how things should look and feel -->

- Typography:
- Color:
- Spacing / density:
- Shape language:
- Texture / materiality:

---

## Cultural References

### Film & Directors
-

### Art & Design
-

### Music
-

### Places & Architecture
-

### Literature & Writing
-

---

## Anti-Patterns
<!-- Things you never want to see in anything built for you — be ruthless -->

-

---

## Voice & Copy

- Tone:
- What good writing sounds like:
- What I hate in copy:

---

## Code Aesthetic

- I prefer:
- I avoid:
- I refuse:
EOF

# ─── README.md ──────────────────────────────────────────────────────────────
cat > README.md << 'EOF'
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
EOF

echo ""
echo "  ✓ palato project created"
echo ""
echo "  Next:"
echo "    npm install"
echo "    npm link"
echo "    palato init"
echo ""

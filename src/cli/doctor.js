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

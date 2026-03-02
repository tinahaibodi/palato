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

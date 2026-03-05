import fs from 'fs-extra';
import path from 'path';

export async function wireClaude() {
  const cwd = process.cwd();
  const palatoSrc = path.join(cwd, 'palato', 'palato.md');

  // 1. Symlink palato/palato.md into .claude/skills/ so Claude Code loads it as a skill
  const skillsDir = path.join(cwd, '.claude', 'skills');
  await fs.ensureDir(skillsDir);
  const skillDest = path.join(skillsDir, 'palato.md');

  if (!fs.existsSync(skillDest)) {
    await fs.symlink(path.relative(skillsDir, palatoSrc), skillDest);
  }

  // 2. Create /palato slash command so the user can type /palato [name]
  const commandsDir = path.join(cwd, '.claude', 'commands');
  await fs.ensureDir(commandsDir);
  const commandDest = path.join(commandsDir, 'palato.md');

  if (!fs.existsSync(commandDest)) {
    const commandSrc = new URL('../templates/command.md', import.meta.url).pathname;
    await fs.copy(commandSrc, commandDest);
  }
}

import fs from 'fs-extra';
import path from 'path';

export async function wireClaude() {
  const cwd = process.cwd();

  // Symlink palato/palato.md into .claude/skills/ so Claude Code loads it as a skill
  const skillsDir = path.join(cwd, '.claude/skills');
  await fs.ensureDir(skillsDir);

  const dest = path.join(skillsDir, 'palato.md');
  const src = path.join(cwd, 'palato', 'palato.md');

  if (!fs.existsSync(dest)) {
    await fs.symlink(path.relative(skillsDir, src), dest);
  }
}

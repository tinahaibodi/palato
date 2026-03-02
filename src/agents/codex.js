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

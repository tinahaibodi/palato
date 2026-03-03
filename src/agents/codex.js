import fs from 'fs-extra';
import path from 'path';

export async function wireCodex() {
  const dest = path.join(process.cwd(), 'AGENTS.md');
  const injection = `\n## Taste Profile\nSee [palato/palato.md](./palato/palato.md) for design preferences, cultural references, and aesthetic rules. Follow the instructions in that file when making any design or copy decisions.\n`;
  const existing = fs.existsSync(dest) ? fs.readFileSync(dest, 'utf8') : '';

  if (!existing.includes('palato')) {
    await fs.appendFile(dest, injection);
  }
}

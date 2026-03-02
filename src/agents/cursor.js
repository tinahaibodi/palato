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

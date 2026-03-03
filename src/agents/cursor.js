import fs from 'fs-extra';
import path from 'path';

export async function wireCursor() {
  const cwd = process.cwd();
  const rcPath = path.join(cwd, '.cursorrules');
  const injection = `\n# palato \u2014 taste profile\n# See palato/palato.md for full instructions\n@palato/palato.md\n`;
  const existing = fs.existsSync(rcPath) ? fs.readFileSync(rcPath, 'utf8') : '';

  if (!existing.includes('palato')) {
    await fs.appendFile(rcPath, injection);
  }
}

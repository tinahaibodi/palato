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

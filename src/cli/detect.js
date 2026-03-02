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

import chalk from 'chalk';
import fs from 'fs-extra';
import path from 'path';
import { wireClaude } from '../agents/claude.js';
import { wireCursor } from '../agents/cursor.js';
import { wireCodex } from '../agents/codex.js';
import { detectAgents } from './detect.js';

export async function install() {
  console.log(chalk.bold('\n  palato — installing\n'));

  const cwd = process.cwd();
  const palatoDir = path.join(cwd, 'palato');

  // 1. Create palato/ directory
  await fs.ensureDir(palatoDir);

  // 2. Copy skill file template
  const templatePath = new URL('../templates/palato.md', import.meta.url).pathname;
  const dest = path.join(palatoDir, 'palato.md');

  if (!fs.existsSync(dest)) {
    await fs.copy(templatePath, dest);
    console.log(chalk.green('  \u2713 ') + 'palato/palato.md created');
  } else {
    console.log(chalk.dim('  \u00b7 ') + 'palato/palato.md already exists \u2014 skipping');
  }

  // 3. Detect and wire agents
  const detected = await detectAgents();

  for (const agent of detected) {
    try {
      if (agent === 'claude') await wireClaude();
      if (agent === 'cursor') await wireCursor();
      if (agent === 'codex') await wireCodex();
      console.log(chalk.green('  \u2713 ') + `${agent} wired`);
    } catch (e) {
      console.log(chalk.red('  \u2717 ') + `${agent}: ${e.message}`);
    }
  }

  if (detected.length === 0) {
    console.log(chalk.dim('  \u00b7 ') + 'No agents detected \u2014 wire manually or re-run after installing an agent');
  }

  console.log(chalk.bold('\n  Done.') + ' Start with: /palato [your-name]\n');
}

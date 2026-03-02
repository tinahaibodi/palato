import inquirer from 'inquirer';
import chalk from 'chalk';
import ora from 'ora';
import fs from 'fs-extra';
import path from 'path';
import { wireClaude } from '../agents/claude.js';
import { wireCursor } from '../agents/cursor.js';
import { wireCodex } from '../agents/codex.js';
import { detectAgents } from './detect.js';

export async function init() {
  console.log(chalk.bold('\n  palato — taste profile setup\n'));

  const detected = await detectAgents();

  const { agents, confirm } = await inquirer.prompt([
    {
      type: 'checkbox',
      name: 'agents',
      message: 'Which agents should palato configure?',
      choices: [
        { name: 'Claude Code', value: 'claude', checked: detected.includes('claude') },
        { name: 'Cursor', value: 'cursor', checked: detected.includes('cursor') },
        { name: 'Codex / OpenAI', value: 'codex', checked: detected.includes('codex') },
      ],
    },
    {
      type: 'confirm',
      name: 'confirm',
      message: 'Scaffold PALATO.md into this project?',
      default: true,
    },
  ]);

  const spinner = ora('Setting up palato...').start();

  if (confirm) {
    const templatePath = new URL('../templates/PALATO.md', import.meta.url).pathname;
    const dest = path.join(process.cwd(), 'PALATO.md');
    if (!fs.existsSync(dest)) {
      await fs.copy(templatePath, dest);
      spinner.succeed(chalk.green('PALATO.md created — fill it in with your taste'));
    } else {
      spinner.warn('PALATO.md already exists — skipping');
    }
  }

  for (const agent of agents) {
    const s = ora(`Configuring ${agent}...`).start();
    try {
      if (agent === 'claude') await wireClaude();
      if (agent === 'cursor') await wireCursor();
      if (agent === 'codex') await wireCodex();
      s.succeed(chalk.green(`${agent} configured`));
    } catch (e) {
      s.fail(`Failed to configure ${agent}: ${e.message}`);
    }
  }

  console.log(chalk.bold('\n  Next steps:'));
  console.log('  1. Edit ' + chalk.cyan('PALATO.md') + ' with your taste');
  console.log('  2. Run ' + chalk.cyan('npx palato doctor') + ' to verify setup\n');
}

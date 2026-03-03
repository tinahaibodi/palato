#!/usr/bin/env node
import { program } from 'commander';
import { install } from '../src/cli/install.js';

program
  .name('palato')
  .description('Wire your personal taste profile into any AI coding agent')
  .version('0.2.0');

program
  .command('install')
  .description('Install the palato skill file and wire into detected agents')
  .action(install);

await program.parseAsync();

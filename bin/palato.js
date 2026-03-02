#!/usr/bin/env node
import { program } from 'commander';
import { init } from '../src/cli/init.js';
import { doctor } from '../src/cli/doctor.js';
import { startServer } from '../src/mcp/server.js';

program
  .name('palato')
  .description('Wire your personal taste profile into any AI coding agent')
  .version('0.1.0');

program
  .command('init')
  .description('Scaffold your taste profile and configure agents')
  .action(init);

program
  .command('doctor')
  .description('Check palato is correctly configured')
  .action(doctor);

program
  .command('server')
  .description('Start the MCP server (stdio transport)')
  .action(startServer);

// parseAsync required — all action handlers are async
// parse() silently swallows rejections from async handlers
await program.parseAsync();

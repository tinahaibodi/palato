import { McpServer } from '@modelcontextprotocol/sdk/server/mcp.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import { z } from 'zod';
import { getProfile, getSection, updateSection } from './tools.js';

// StdioTransport uses stdout as the wire protocol.
// Any write to stdout corrupts the stream — all logging goes to stderr only.
const log = (...args) => process.stderr.write(args.join(' ') + '\n');

export async function startServer() {
  const server = new McpServer({
    name: 'palato',
    version: '0.1.0',
  });

  server.tool(
    'palato_get_profile',
    'Returns the full taste profile from PALATO.md',
    {},
    async () => {
      try {
        const content = await getProfile();
        return { content: [{ type: 'text', text: content }] };
      } catch (e) {
        log('[palato] palato_get_profile error:', e.message);
        return { content: [{ type: 'text', text: `Error: ${e.message}` }], isError: true };
      }
    }
  );

  server.tool(
    'palato_get_section',
    'Returns a specific section of the taste profile',
    {
      section: z.string().describe('Section name e.g. "Visual Language", "Cultural References", "Anti-Patterns"'),
    },
    async ({ section }) => {
      try {
        const content = await getSection(section);
        return { content: [{ type: 'text', text: content }] };
      } catch (e) {
        log('[palato] palato_get_section error:', e.message);
        return { content: [{ type: 'text', text: `Error: ${e.message}` }], isError: true };
      }
    }
  );

  server.tool(
    'palato_update',
    'Appends a note or suggestion to a section of the taste profile',
    {
      section: z.string().describe('Section to update'),
      note: z.string().describe('Note to append'),
    },
    async ({ section, note }) => {
      try {
        await updateSection(section, note);
        return { content: [{ type: 'text', text: `Updated "${section}"` }] };
      } catch (e) {
        log('[palato] palato_update error:', e.message);
        return { content: [{ type: 'text', text: `Error: ${e.message}` }], isError: true };
      }
    }
  );

  const transport = new StdioServerTransport();

  process.on('uncaughtException', (e) => log('[palato] uncaughtException:', e.message));
  process.on('unhandledRejection', (e) => log('[palato] unhandledRejection:', e));

  await server.connect(transport);
  log('[palato] MCP server running (stdio)');
}

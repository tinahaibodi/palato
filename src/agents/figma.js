import fs from 'fs-extra';
import path from 'path';
import os from 'os';

export async function wireFigma() {
  const configPath = path.join(os.homedir(), '.claude', 'settings.json');
  await fs.ensureDir(path.dirname(configPath));

  let config = {};
  try {
    config = await fs.readJson(configPath);
  } catch {}

  if (!config.mcpServers) config.mcpServers = {};

  if (!config.mcpServers['figma']) {
    config.mcpServers['figma'] = {
      command: 'npx',
      args: ['-y', 'figma-developer-mcp', '--figma-api-key=REPLACE_WITH_YOUR_FIGMA_API_KEY'],
      note: 'Get your Figma API key at figma.com/settings → Personal access tokens',
    };
    await fs.writeJson(configPath, config, { spaces: 2 });
  }
}

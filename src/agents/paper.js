import fs from 'fs-extra';
import path from 'path';
import os from 'os';

export async function wirePaper() {
  const configPath = path.join(os.homedir(), '.claude', 'settings.json');
  await fs.ensureDir(path.dirname(configPath));

  let config = {};
  try {
    config = await fs.readJson(configPath);
  } catch {}

  if (!config.mcpServers) config.mcpServers = {};

  if (!config.mcpServers['paper']) {
    config.mcpServers['paper'] = {
      type: 'url',
      url: 'REPLACE_WITH_YOUR_PAPER_MCP_URL',
      note: 'Open Paper desktop → Settings → MCP to find your URL',
    };
    await fs.writeJson(configPath, config, { spaces: 2 });
  }
}

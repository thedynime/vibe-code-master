#!/usr/bin/env node

/**
 * Vibe Code Master — Automated Agentic Customizations Sync Engine
 * Synchronizes and catalogs all agentic skills, plugins, MCP servers,
 * and universal rules from Antigravity, Claude, Codex, Cursor & VS Code.
 *
 * Copyright (c) 2026 Dynime LLC (Dynime Group). All rights reserved.
 */

const fs = require("fs");
const path = require("path");

const REPO_ROOT = path.resolve(__dirname, "..");
const HOME = process.env.HOME;

// Confidential Blocklist: Internal proprietary assets that must NEVER be published
const CONFIDENTIAL_BLOCKLIST = [
  "dynime-os-master-architecture",
  "dynime-os",
];

function isConfidential(name) {
  if (!name) return false;
  const lower = name.toLowerCase();
  return (
    CONFIDENTIAL_BLOCKLIST.some((blocked) => lower === blocked.toLowerCase()) ||
    lower.startsWith("dynime-os") ||
    lower.includes("dynime-os-master")
  );
}

const SOURCE_SKILLS = path.join(HOME, ".gemini/config/skills");
const SOURCE_PLUGINS = path.join(HOME, ".gemini/config/plugins");
const SOURCE_MCP_CONFIG = path.join(HOME, ".gemini/config/mcp_config.json");
const SOURCE_MCP_SCHEMAS = path.join(HOME, ".gemini/antigravity/mcp");
const SOURCE_RULES = path.join(HOME, ".gemini/config/GEMINI.md");
const SOURCE_SCRIPTS = path.join(HOME, ".gemini/config/scripts");

const DEST_SKILLS = path.join(REPO_ROOT, "skills");
const DEST_PLUGINS = path.join(REPO_ROOT, "plugins");
const DEST_MCP = path.join(REPO_ROOT, "mcp");
const DEST_RULES = path.join(REPO_ROOT, "rules");
const DEST_SCRIPTS = path.join(REPO_ROOT, "scripts");

console.log("⚡ [Vibe Code Master] Starting full agentic workspace sync...");

// Ensure directories exist
[DEST_SKILLS, DEST_PLUGINS, DEST_MCP, DEST_RULES, DEST_SCRIPTS].forEach((dir) => {
  if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true });
});

// 1. Sync Skills (Dereferenced Standalone)
console.log("📦 Syncing skills from ~/.gemini/config/skills/ ...");
let syncedSkills = 0;
const skillCatalog = [];

if (fs.existsSync(SOURCE_SKILLS)) {
  const items = fs.readdirSync(SOURCE_SKILLS);
  for (const item of items) {
    if (item === ".repos" || item === ".git" || item === ".DS_Store") continue;
    if (isConfidential(item)) {
      console.log(`🔒 [CONFIDENTIAL SHIELD] Skipped proprietary asset: ${item}`);
      continue;
    }
    const itemPath = path.join(SOURCE_SKILLS, item);
    let realPath = itemPath;
    try {
      realPath = fs.realpathSync(itemPath);
    } catch (e) {
      continue;
    }

    const smPath = path.join(realPath, "SKILL.md");
    if (!fs.existsSync(smPath)) continue;

    const destDir = path.join(DEST_SKILLS, item);
    if (fs.existsSync(destDir)) {
      fs.rmSync(destDir, { recursive: true, force: true });
    }

    // Copy dereferenced
    fs.cpSync(realPath, destDir, { recursive: true, dereference: true });

    // Read metadata for catalog
    const content = fs.readFileSync(path.join(destDir, "SKILL.md"), "utf-8");
    const nameMatch = content.match(/name:\s*([^\r\n]+)/);
    const descMatch = content.match(/description:\s*(?:>-?|\|)?\s*([^\r\n]+)/i);

    const name = nameMatch ? nameMatch[1].trim() : item;
    let desc = descMatch ? descMatch[1].replace(/["']/g, "").trim() : "Custom agentic skill.";

    skillCatalog.push({ name, dir: item, desc });
    syncedSkills++;
  }
}
console.log(`✅ Synced ${syncedSkills} standalone skills.`);

// 2. Sync Plugins
console.log("🔌 Syncing plugins from ~/.gemini/config/plugins/ ...");
let syncedPlugins = 0;
if (fs.existsSync(SOURCE_PLUGINS)) {
  const plugins = fs.readdirSync(SOURCE_PLUGINS);
  for (const p of plugins) {
    if (p.startsWith(".")) continue;
    if (isConfidential(p)) {
      console.log(`🔒 [CONFIDENTIAL SHIELD] Skipped proprietary plugin: ${p}`);
      continue;
    }
    const pPath = path.join(SOURCE_PLUGINS, p);
    if (!fs.statSync(pPath).isDirectory()) continue;

    const destDir = path.join(DEST_PLUGINS, p);
    if (fs.existsSync(destDir)) {
      fs.rmSync(destDir, { recursive: true, force: true });
    }

    // Copy excluding node_modules and .git
    fs.cpSync(pPath, destDir, {
      recursive: true,
      filter: (src) => !src.includes("node_modules") && !src.includes(".git"),
    });
    syncedPlugins++;
  }
}
console.log(`✅ Synced ${syncedPlugins} plugins.`);

// 3. Sync MCP Configuration & Tool Schemas
console.log("🌐 Syncing MCP configurations and tool definitions...");
if (fs.existsSync(SOURCE_MCP_CONFIG)) {
  try {
    const raw = fs.readFileSync(SOURCE_MCP_CONFIG, "utf-8");
    const parsed = JSON.parse(raw);

    // Sanitize and redact private secrets
    if (parsed.mcpServers) {
      for (const [key, server] of Object.entries(parsed.mcpServers)) {
        if (server.headers) {
          if (server.headers.Authorization) {
            server.headers.Authorization = "Bearer ${RESEND_API_KEY}";
          }
          if (server.headers["x-api-key"]) {
            server.headers["x-api-key"] = "${API_KEY_21ST}";
          }
        }
        if (server.command && server.command.includes("/Users/")) {
          // make command portable
          server.command = path.basename(server.command);
        }
      }
    }

    fs.writeFileSync(
      path.join(DEST_MCP, "mcp_config.json"),
      JSON.stringify(parsed, null, 4),
      "utf-8"
    );
  } catch (err) {
    console.warn("Could not sanitize mcp_config.json:", err.message);
  }
}

// Sync tool schemas from ~/.gemini/antigravity/mcp if present
const destSchemas = path.join(DEST_MCP, "schemas");
if (fs.existsSync(SOURCE_MCP_SCHEMAS)) {
  if (!fs.existsSync(destSchemas)) fs.mkdirSync(destSchemas, { recursive: true });
  const mcpDirs = fs.readdirSync(SOURCE_MCP_SCHEMAS);
  for (const m of mcpDirs) {
    if (m.startsWith(".")) continue;
    const sPath = path.join(SOURCE_MCP_SCHEMAS, m);
    if (fs.statSync(sPath).isDirectory()) {
      fs.cpSync(sPath, path.join(destSchemas, m), {
        recursive: true,
        filter: (src) => !src.includes("node_modules") && !src.includes(".git"),
      });
    }
  }
}
console.log("✅ MCP configurations & tool schemas synced.");

// 4. Sync Global Rules & Instruction Standards
console.log("📜 Syncing universal rules & guidelines...");
if (fs.existsSync(SOURCE_RULES)) {
  const rulesContent = fs.readFileSync(SOURCE_RULES, "utf-8");
  fs.writeFileSync(path.join(DEST_RULES, "GEMINI.md"), rulesContent, "utf-8");
  fs.writeFileSync(path.join(DEST_RULES, "AGENTS.md"), rulesContent, "utf-8");
  fs.writeFileSync(path.join(DEST_RULES, "CLAUDE.md"), rulesContent, "utf-8");
  fs.writeFileSync(path.join(DEST_RULES, ".cursorrules"), rulesContent, "utf-8");
}
console.log("✅ Universal rules (GEMINI.md, AGENTS.md, CLAUDE.md, .cursorrules) synced.");

// 5. Sync Asset Handlers and Utilities
if (fs.existsSync(SOURCE_SCRIPTS)) {
  fs.cpSync(SOURCE_SCRIPTS, DEST_SCRIPTS, {
    recursive: true,
    filter: (src) => !src.includes("node_modules") && !src.includes(".git"),
  });
}
console.log("✅ Helper scripts synced.");

console.log(`\n🎉 [Vibe Code Master] Sync completed successfully!`);
console.log(`- Standalone Skills: ${syncedSkills}`);
console.log(`- Plugins: ${syncedPlugins}`);
console.log(`- MCP Servers: Configured & Redacted`);
console.log(`- Rules: GEMINI / AGENTS / CLAUDE / Cursor synced`);

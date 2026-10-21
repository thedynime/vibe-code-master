# Model Context Protocol (MCP) Configuration & Tool Catalog

This directory contains production-ready Model Context Protocol (MCP) server definitions, tool schemas, and environment integrations for **Claude Desktop, Cursor AI, VS Code (Cline/Roo-Code), Antigravity, and OpenAI Codex**.

---

## 🛠️ Included MCP Servers

| Server | Category | Description | Integration Type |
| :--- | :--- | :--- | :--- |
| **`resend`** | Communication | Email sending, domain verification, batch delivery & transactional alerts | HTTP SSE (`https://mcp.resend.com/mcp`) |
| **`21st`** | UI & Video | 21st.dev component generation, design inspiration & visual studio | HTTP API (`https://21st.dev/api/mcp`) |
| **`motion` / `motion-plus`** | UI & Animation | Motion (Framer Motion) animation documentation & component generation | HTTP SSE (`https://mcp.motion.dev`) |
| **`geo-optimizer`** | Search & GEO | Generative Engine Optimization, citations, schema audits for AI search engines | Stdio CLI (`geo-mcp`) |
| **`mcp-search-console`** | Analytics | Google Search Console analytics, sitemaps, indexation monitoring | Stdio CLI (`uvx mcp-search-console`) |
| **`magnific`** | Creative AI | High-resolution image/video upscaling, relighting & asset generation | Remote Tunnel (`mcp-remote`) |
| **`hostinger`** | Infrastructure | Cloud deployment, VPS management & DNS routing | Stdio (`@hostinger/mcp`) |
| **`openseo`** | SEO Diagnostics | Complete crawler, SERP analysis & backlink metrics | HTTP API (`https://app.openseo.so/mcp`) |

---

## 🚀 Setup Guides

### 1. Claude Desktop (`claude_desktop_config.json`)
Copy the contents of [`mcp_config.json`](./mcp_config.json) into:
- **macOS**: `~/Library/Application Support/Claude/claude_desktop_config.json`
- **Windows**: `%APPDATA%\Claude\claude_desktop_config.json`

### 2. Cursor AI (`.cursor/mcp.json`)
Create or edit `.cursor/mcp.json` in your workspace root using the JSON configuration in this directory.

### 3. Antigravity / Gemini CLI
Place `mcp_config.json` in `~/.gemini/config/mcp_config.json`. Antigravity will automatically load and expose all eagerly-loaded and lazy MCP tools.

---

## 🔒 Security & Secrets
Never commit private API keys. Set the following environment variables on your system:
- `RESEND_API_KEY`: API token from resend.com
- `API_KEY_21ST`: API key from 21st.dev

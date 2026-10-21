---
name: open-seo
description: "OpenSEO suite — open-source alternative to Ahrefs and Semrush."
---

# OpenSEO

> Open source alternative to Semrush and Ahrefs for you and your AI agent.

OpenSEO connects your agent to real SEO data, rankings, search volume, competitor footprints, and backlink data.

## OpenSEO MCP Endpoint

Hosted remote MCP server:
```
https://app.openseo.so/mcp
```
Configure in `~/.gemini/config/mcp_config.json`:
```json
{
  "mcpServers": {
    "openseo": {
      "serverUrl": "https://app.openseo.so/mcp"
    }
  }
}
```

## Available Sub-Skills

| Skill | Focus |
|-------|-------|
| `keyword-research` | Discover keyword opportunities, analyze volume, CPC, competition, and SERP intents. |
| `keyword-clustering` | Group keywords into clusters based on SERP overlap and searcher intent. |
| `competitor-analysis` | Analyze a competitor domain or URL footprint, top pages, ranking keywords, and backlink profile. |
| `competitive-landscape` | Map market leaders across search themes, discover keyword coverage gaps and backlink gaps. |
| `link-prospecting` | Discover relevant link acquisition targets, authority metrics, and outreach points. |
| `local-seo` | Audit Google Business Profile, compare against local 3-pack competitors, analyze geo-grid rankings. |
| `openseo-audit` | Data-backed site audit focusing on the highest-leverage traffic growth levers. |
| `seo-coach` | Interactive coach mode guiding you step-by-step through SEO projects and MCP tools. |
| `seo-project-setup` | Initialize shared SEO context (target domain, competitors, brand positioning, key URLs). |
| `seo-report` | Compile findings into a self-contained, client-ready interactive HTML report. |
| `deslop` | Strip predictable AI writing tropes and fluff from SEO articles and documentation. |

## Self-Hosting & API Options

OpenSEO can run using:
1. **Hosted OpenSEO**: Sign in at [openseo.so](https://openseo.so) and authenticate via OAuth or API key.
2. **Self-Hosted (Cloudflare / Docker)**: Connect your own DataForSEO API key with zero markup.

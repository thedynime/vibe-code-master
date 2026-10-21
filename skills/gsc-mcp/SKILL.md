---
name: gsc-mcp
description: "Google Search Console MCP server integration and analytics suite."
---

# Google Search Console (GSC) MCP

The **GSC MCP** integration connects Google Search Console directly to your AI workflow, allowing autonomous search performance analysis, URL inspection, sitemap monitoring, and ranking optimization.

## Quick Start & Execution

The MCP server runs via `uvx`:
```bash
uvx mcp-search-console
```
Or directly using Python in the repository:
```bash
python ~/.gemini/config/skills/.repos/mcp-gsc/gsc_server.py
```

### Credentials & Environment Setup

GSC MCP supports two authentication methods:
1. **OAuth 2.0 (User Account)**:
   - Create OAuth 2.0 Client ID (Desktop App) in Google Cloud Console.
   - Download client secret JSON and set:
     ```bash
     export GSC_OAUTH_CLIENT_SECRETS_FILE="/path/to/client_secrets.json"
     ```
2. **Service Account (Headless / Automated)**:
   - Create a Service Account in GCP and grant it permission in Search Console.
   - Download JSON key and set:
     ```bash
     export GSC_CREDENTIALS_PATH="/path/to/service_account.json"
     ```
3. **Data Freshness**:
   - `export GSC_DATA_STATE="all"` (includes unfinalized fresh data) or `"final"`

## MCP Tools Available

| Tool | Purpose |
|------|---------|
| `list_properties` | List all verified domains/properties in your Google Search Console account. |
| `get_search_analytics` | Query clicks, impressions, CTR, and average position grouped by date, query, page, country, device, or searchAppearance. |
| `get_advanced_search_analytics` | Multi-dimensional breakdown with custom filters, regex, and dimension combinations. |
| `inspect_url` | Run Google URL Inspection API to check index status, crawl time, mobile usability, and rich results. |
| `list_sitemaps` | View submitted sitemaps, last download date, error counts, and indexing status. |
| `submit_sitemap` | Submit a sitemap or sitemap index URL to Google Search Console. |

## Sub-Workflows & Skills

The following dedicated sub-skills are installed and directly accessible:
- `cannibalization-check`: Identify queries where multiple pages compete against each other for rankings.
- `content-opportunities`: Discover quick-win targets (high impressions, low CTR, ranking positions 11-20).
- `indexing-audit`: Audit URL crawlability, canonicals, and indexation state using Google URL Inspection.
- `seo-weekly-report`: Generate structured weekly performance updates and trend comparisons.

# AI Coding Token Optimization & Context Rules

Universal token efficiency and project mapping rules applied across all projects and coding sessions.

## 1. Entry Point Budget (≤ 8 KB / ~2,000 Tokens)

- Keep always-loaded instruction files (`AGENTS.md`, `CLAUDE.md`, `GEMINI.md`) compact (under ~8 KB).
- **What stays in the entry point:**
  - Project identity and core architecture overview.
  - Hard safety, security, and behavioral rules.
  - Essential build, test, and run commands.
  - Reflexes ("When about to X, do Y").
  - The Project map summary and upkeep rules.
- **What moves out of the entry point:**
  - Detailed file trees, exhaustive directory listings, and file-by-file inventories.
  - Complete environment variable catalogs (keep only secret/config names).
  - CI/CD workflow walkthroughs and deployment scripts.
  - Extensive gotcha lists, style guides, and historical changelogs.
  - Move these into `docs/guides/<topic>.md` or `docs/map/` routers.

## 2. Router-First Navigation (Minimal Rediscovery)

- When approaching any feature, bug fix, or refactor:
  - Check the project map (`docs/map/PRODUCT.md` or local `src/<module>/README.md`) first to locate authoritative files.
  - Do not run wide, unconstrained directory searches or bulk-read dozens of files when a targeted router exists.
  - Open and read only the files directly required for the current task.

## 3. Keep Navigation Maps Synchronized

- Whenever a task creates, moves, renames, or deletes files or routes:
  - Update the corresponding table in `docs/map/` or the area's `README.md` within the same change.
  - Ensure all relative Markdown links in routers resolve accurately.

## 4. Proactive Token Optimization

- When working in a project where `AGENTS.md` or `CLAUDE.md` has grown beyond ~8 KB, or where no navigation map exists:
  - Proactively offer or apply the `ai-coding-token-optimizer` skill to slim the entry point and establish lightweight task routers.

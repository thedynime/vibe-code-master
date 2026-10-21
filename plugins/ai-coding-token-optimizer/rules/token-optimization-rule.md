---
description: Universal token optimization and project-mapping rule for all coding tasks across all projects.
trigger: always_on
---

# Universal Token Optimization Rule

Always enforce token efficiency, context slimming, and router-first navigation in every project and prompt:

1. **Keep Entry Points Under 8 KB**: Ensure `AGENTS.md`, `CLAUDE.md`, and `GEMINI.md` contain only essential task-binding rules, commands, and reflexes. Move reference material (file trees, env catalogs, CI steps) behind routers.
2. **Consult Maps Before Scanning**: Look for `docs/map/PRODUCT.md`, `docs/map/OPERATIONS.md`, or area `README.md` files first to pinpoint files rather than performing wide directory scans.
3. **Selective Reading**: Read only the specific lines or files needed for the task at hand.
4. **Synchronize On Edits**: Keep router tables up-to-date whenever files or routes are added, relocated, or removed.
5. **Suggest Optimization**: If an entry point exceeds 8 KB or a repository lacks maps, recommend or run `ai-coding-token-optimizer`.

---
name: agentic-awesome-skills
description: "Catalog and installer for 2,445+ agentic skills and AAS Core workflows."
---

# Agentic Awesome Skills (AAS)

Access to a community-curated catalog of 2,445+ specialized AI agent skills across programming languages, design systems, debugging tools, architectures, and domain-specific workflows.

## Using the CLI

`agentic-awesome-skills` (or `aas`) is installed globally and can be invoked from any terminal:

### Previewing & Installing Skills to Antigravity
To install a specific skill into the current workspace (`.agents/skills/`):
```bash
agentic-awesome-skills --path .agents/skills --skills <skill-name>
```

To install globally into Antigravity (`~/.gemini/config/skills/`):
```bash
agentic-awesome-skills --path ~/.gemini/config/skills --skills <skill-name>
```

To dry-run or preview an installation:
```bash
agentic-awesome-skills --path .agents/skills --skills <skill-name> --dry-run
```

### Filtering by Category or Tags
```bash
agentic-awesome-skills --path .agents/skills --category development,backend --risk safe,none
```

## Hosted Catalog & Discovery
Browse the complete catalog, inspect full instruction files, and check declared risks online at:
- **Catalog**: [https://sickn33.github.io/agentic-awesome-skills/](https://sickn33.github.io/agentic-awesome-skills/)
- **Repository**: [https://github.com/sickn33/agentic-awesome-skills](https://github.com/sickn33/agentic-awesome-skills)

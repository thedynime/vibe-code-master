---
name: magnific
description: "Find, generate, upscale, and integrate images, videos, and visual assets into projects using the Magnific MCP server (mcp.magnific.com)."
---

# Magnific Visual Generation & Asset Integration

This skill guides finding, generating, upscaling, and downloading visual assets from **Magnific** (`mcp.magnific.com`) directly into project codebases.

## Capabilities

1. **Text-to-Image Generation**: Generate high-fidelity visual assets, illustrations, photorealistic photos, and UI graphics using Magnific's model suite (Flux, Recraft, SDXL, etc.).
2. **Upscaling & Enhancement**: Upscale existing project images up to 16x with Creative or Precision modes.
3. **Asset History Search**: Search past generations and creative assets in your Magnific library.
4. **Project Asset Ingestion**: Save generated URLs/files directly to the project's public or asset directories (`public/images/`, `src/assets/`, etc.).

## Workflow

### 1. Generating or Finding Assets
- When generating: Craft detailed prompts specifying style, lighting, composition, aspect ratio, and color palette.
- When searching history: Query Magnific's asset library for matching tags, prompts, or previous generation IDs.

### 2. Saving to Project
- Download the generated high-resolution asset into the local project directory:
  ```bash
  curl -L "<magnific-asset-url>" -o "<project-root>/public/images/<filename>.png"
  ```
- Reference the local image in the code/markup (e.g. `<img src="/images/hero.png" alt="..." />`).

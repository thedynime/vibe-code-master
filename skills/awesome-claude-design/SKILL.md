---
name: awesome-claude-design
description: "Design system intelligence and DESIGN.md specification framework based on VoltAgent/awesome-claude-design."
---

# Awesome Claude Design (`DESIGN.md` Framework)

A comprehensive design intelligence skill powered by [VoltAgent/awesome-claude-design](https://github.com/VoltAgent/awesome-claude-design) and [getdesign.md](https://getdesign.md/). It allows coding agents to scaffold complete design systems, CSS token variables, typography scales, preview cards, and production-ready UI kits from a single `DESIGN.md` specification.

## Core Concepts

### What is `DESIGN.md`?
`DESIGN.md` is a single plain-text markdown file that describes a brand's visual language in a structured format that AI coding and design agents can reliably parse and act on.
- **The Core Rule**: Keep **token, rule, and rationale** in the same file.
- **Token**: exact values (hex, rem, timing).
- **Rule**: when and where to use each token.
- **Rationale**: *why* the choice was made so the agent stays on-system even when encountering novel UI components.

| File | Read By | Role |
| :--- | :--- | :--- |
| `AGENTS.md` | Coding Agents | How to build, test, and run the project |
| `DESIGN.md` | Design & Frontend Agents | How the project should look, feel, move, and respond |

## Standard `DESIGN.md` Structure

When generating or editing a `DESIGN.md` file, adhere to this structure:

```markdown
# [Brand/Product Name] Design System

## 1. Brand Identity & Vibe
- **Core Aesthetic**: (e.g. Void-black canvas, emerald accent, terminal-native)
- **Voice & Tone**: (e.g. Precise, minimalist, engineer-first)

## 2. Color Tokens (Semantic & Hex)
- Primary, Background, Surface, Card, Muted, Border, Accent, Destructive
- Contrast ratios verified (4.5:1 minimum for body text)

## 3. Typography Scale & Font Pairings
- Headings font (Display/Mono/Serif)
- Body text font (Readable Sans)
- Modular scale (xs, sm, base, lg, xl, 2xl, 3xl)

## 4. Spacing, Borders & Radius
- 4px/8px base spacing grid
- Border radius tokens (--radius-sm, --radius-md, --radius-lg)
- Elevation & shadows (or flat/sharp borders)

## 5. Motion & Micro-Interactions
- Transition durations (150ms-250ms)
- Easing curves
- prefers-reduced-motion fallbacks

## 6. Component Guidelines
- Buttons (Primary, Secondary, Ghost, Outline)
- Inputs & Form fields
- Cards & Bento containers
- Navigation & Modals
```

## Available Curated Brand Design Systems

Access the full local reference catalog in [`references/README.md`](./references/README.md) or query [getdesign.md](https://getdesign.md/):
- **AI Platforms**: Claude, Cohere, ElevenLabs, Minimax, Mistral AI, Ollama, OpenCode AI, Replicate, RunwayML, Together AI, VoltAgent, xAI
- **Developer Tools**: Cursor, GitHub, Vercel, Supabase, Linear, Raycast, Docker, Postman
- **Consumer & Enterprise**: Apple, Stripe, Airbnb, Notion, Figma, Spotify, Arc

# Hallmark Design & Anti-Slop Always-Active Rules

These design standards and Floor checks are always active across all projects, sessions, UI developments, and prompt runs.

## 1. Always-Active Floor Invariants

Whenever generating, modifying, or reviewing websites, web applications, landing pages, or UI components:

1. **Tokens Over Literals**: Every colour and font must route through a design token declared at `:root` (or scoped theme block). Never use raw literal colors or ad-hoc `font-family` declarations past the token block.
2. **Animation Discipline**: Never use `transition: all`. Never animate layout-triggering properties (`width`, `height`, `top`, `left`). All animations must include a `@media (prefers-reduced-motion: reduce)` override. Content must remain visible with scripting disabled.
3. **Typography Integrity**: Never put a single italicized word inside a roman heading. Never use eyebrows above headings. Never format labels, captions, table headers, or navigation items in tracked capitals or small-caps.
4. **Layout & Overflow**: Enforce `overflow-x: clip` on both `html` and `body` (never `hidden`, never `100vw`). Use `minmax(0, 1fr)` for image-bearing grid tracks, and apply `overflow-wrap: break-word; min-width: 0` to display headings.
5. **Accessibility**: Every interactive element must display an immediate, high-contrast `:focus-visible` ring. Target WCAG 2.2 AA standards.
6. **Zero AI Visual Slop**:
   - Never use purple-to-blue gradients, glowing neon orbs, or glassmorphic blur stacks.
   - Never nest cards inside cards.
   - Never use emojis as iconography; use clean inline SVGs.
   - Never build fake hand-drawn browser or OS frames.
   - Never join meta details with centered bullet dots (`·`), glue arrows directly to link text, or use decorative status pills.
7. **Authentic Content**: Never invent testimonials, client quotes, fake partner logos, or fabricated metrics. Real content only; use clearly labeled placeholders when material is absent.
8. **Above-the-Fold Viewport Check**: At 1280×800 viewport, the primary headline, 1-sentence value statement, and primary CTA action must be fully visible without scrolling.
9. **Automated Verification**: When Node.js is available, run `node /Users/jitkumarsaha/.gemini/config/skills/hallmark/scripts/sloplint.mjs <file>` on generated HTML/CSS files to verify zero Floor fails.

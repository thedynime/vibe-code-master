# Cloudflare Kumo Design Always-Active Rules

These UI design invariants and precision rules are always active across all projects, sessions, and frontend prompt runs.

## 1. Typography & Hierarchy
- **14px Content Standard (`content-text-size`)**: All content text (body, buttons, table data, interactables) must be 14px. Sizes 16px and above are strictly reserved for headings.
- **Sentence-Case Headings (`heading-case`)**: Always sentence-case headings (never ALL CAPS, never Title Case, except registered product names).
- **Default Tracking (`font-tracking`)**: Never use `tracking-*` classes to artificially alter character spacing.
- **Weight Discipline (`font-weight`)**: Never use `font-bold`. Use `font-semibold` for headings and `font-medium` for strong inline text.
- **Inline Monospace Scale (`inline-monospace-size`)**: Reduce inline monospaced code to ~0.9em (`text-[0.9em] font-mono`) when embedded in prose.

## 2. Spacing & Spatial Relationships
- **Proximity Hierarchy (`related-text-spacing`)**: Group related title + description tighter (e.g. `gap-1.5`) than surrounding action buttons or cards (`gap-6`).
- **Optical Line-Height Alignment (`text-spacing`)**: Vertical container padding should be slightly smaller than horizontal (`px-5 py-4` instead of uniform `p-5`) to compensate for line height.
- **First-Line Icon Alignment (`icon-alignment`)**: Inline icons must align optically with the first line of text using `h-lh flex items-center`.

## 3. Borders, Surfaces & Radii
- **Concentric Radii (`concentric-border-radius`)**: When borders/rings are <= 8px apart, corner radii must be concentric: `outer radius = inner radius + padding`.
- **Shadows vs Borders (`shadow-borders`)**: Never combine raw borders with drop shadows. Use `ring ring-kumo-line` for clean, crisp edges with elevation.
- **Sticky Surface Separation (`sticky-borders`)**: Always separate sticky headers/toolbars from scrolling content with an explicit border (`sticky top-0 border-b border-kumo-line`).
- **Zero Card Nesting (`layer-card-nesting`)**: Never stack or nest cards/LayerCards inside each other.

## 4. Interaction & Motion
- **Instant Hover States (`hover-color-transitions`)**: Never transition hover colors (`transition-colors duration-300`). Color changes on hover must trigger immediately to prevent sluggish feel.
- **Stable Collapsible Geometry (`collapse-content-size`)**: Collapsible panels must maintain fixed content width inside animated wrappers to prevent text squishing during transitions.
- **Non-Conditional Dialogs (`dialog-rendering`)**: Never conditionally mount dialogs (`{open && <Dialog>}`). Always pass controlled `open={open}` to preserve enter/exit animations.

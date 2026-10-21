---
name: vite
description: "Next-generation frontend tooling and bundler guide for Vite."
---

# Vite Frontend Tooling & Development Server

Expert guidance for project initialization, rapid HMR development, static asset bundling, and production optimization using Vite.

## Quick Project Initialization

```bash
# Vanilla JS / TS
npm create vite@latest my-app -- --template vanilla
npm create vite@latest my-app -- --template vanilla-ts

# React
npm create vite@latest my-app -- --template react
npm create vite@latest my-app -- --template react-ts
```

## Essential Vite + Three.js / 3D Asset Configuration

Install Three.js and optional GLSL shader support:
```bash
npm install three
npm install -D vite-plugin-glsl
```

### `vite.config.js` Example for Three.js & Shaders:
```javascript
import { defineConfig } from 'vite';
import glsl from 'vite-plugin-glsl';

export default defineConfig({
  plugins: [glsl()],
  assetsInclude: ['**/*.glb', '**/*.gltf', '**/*.hdr'],
  server: {
    port: 3000,
    open: true,
    host: true
  },
  build: {
    target: 'esnext',
    chunkSizeWarningLimit: 1500
  }
});
```

## Static Asset Handling in Vite
- **`public/` directory**: Place raw 3D assets (`.glb`, `.gltf`, textures, `.hdr` environment maps) in `public/models/` or `public/textures/`. They are served directly from the root URL (e.g. `/models/robot.glb`).
- **Importing assets**: Alternatively, import assets directly in JS:
  ```javascript
  import modelUrl from './assets/models/character.glb?url';
  gltfLoader.load(modelUrl, (gltf) => { ... });
  ```

## Development & Production Commands
- `npm run dev`: Start lightning-fast local development server with instant HMR.
- `npm run build`: Build production bundle with Rollup tree-shaking into `dist/`.
- `npm run preview`: Locally preview production build before deploying.

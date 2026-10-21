---
name: bulletproof-build-integrity
description: "Enforce zero-breakage production builds: prevent CSS/Tailwind design destruction, guarantee complete cache invalidation (HTML no-cache vs chunk contenthashing), and..."
---

# Bulletproof Build Integrity: Design Preservation, Cache-Busting & Backend Safety

This skillset guarantees that web applications ship to production **without visual breakage**, **without users getting stuck on stale cached assets**, and **without breaking backend connections or API contracts**.

---

## The Three Pillars of Build Safety

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│ 1. DESIGN & CSS INTEGRITY                                                   │
│    • Protect dynamic Tailwind/CSS classes from aggressive tree-shaking      │
│    • Prevent SSR/Client hydration layout shifts & unstyled flashes (FOUC)   │
│    • Guarantee relative/CDN asset & font URL resolution                     │
├─────────────────────────────────────────────────────────────────────────────┤
│ 2. AGGRESSIVE CACHE-BUSTING & FRESH ASSET SERVING                           │
│    • Pre-build clean: Wipe stale build artifacts (.next, dist, .vite)       │
│    • Two-Tier Caching: index.html (no-store) vs Hashed chunks (immutable)   │
│    • Self-healing client: Catch ChunkLoadError & auto-refresh gracefully    │
│    • Service Worker & PWA eviction: Immediate claim (skipWaiting)           │
├─────────────────────────────────────────────────────────────────────────────┤
│ 3. BACKEND & API CONTRACT STABILITY                                         │
│    • Build-time Environment Variable validation (no undefined / localhost)  │
│    • CORS & Origin parity across build domains                              │
│    • Non-breaking, additive API payloads during rolling deployments        │
│    • Automated pre-flight & healthcheck verification                        │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 1. Design & CSS Protection (Never Break Layouts in Production)

### A. Tailwind CSS & Dynamic Class Safelisting
**The Bug**: During development, all Tailwind classes exist. In production, PostCSS / Tailwind purges any class string not explicitly found as a complete literal in template files. Constructing dynamic strings like ``className={`bg-${color}-500`}`` breaks in production!

**The Golden Rules**:
1. **Always use complete class literals**:
   ```javascript
   // ❌ DANGEROUS: Purged in production build!
   const colorClass = `text-${color}-600`;

   // ✅ SAFE: Full literals recognized by the scanner
   const colorMap = {
     red: 'text-red-600',
     blue: 'text-blue-600',
     emerald: 'text-emerald-600',
   };
   const colorClass = colorMap[color];
   ```
2. **Configure `safelist` in `tailwind.config.js`** when dynamic classes are unavoidable:
   ```javascript
   module.exports = {
     content: ['./src/**/*.{js,ts,jsx,tsx,html}'],
     safelist: [
       {
         pattern: /(bg|text|border)-(red|blue|emerald|amber)-(500|600)/,
         variants: ['hover', 'focus', 'dark'],
       },
     ],
   };
   ```
3. **Verify `content` paths**: Ensure all component directories, shared packages, or markdown renderer files are included in the `content` array.

### B. Hydration Mismatches & Flash of Unstyled Content (FOUC)
**The Bug**: Server renders DOM tree A, but browser renders tree B due to window checks, random IDs, or locale timestamps. React throws hydration warnings and wipes or scrambles styling.

**Protections**:
- **Client-only rendering wrapper**:
  ```tsx
  import { useEffect, useState } from 'react';

  export function ClientOnly({ children, fallback = null }: { children: React.ReactNode; fallback?: React.ReactNode }) {
    const [mounted, setMounted] = useState(false);
    useEffect(() => setMounted(true), []);
    return mounted ? <>{children}</> : <>{fallback}</>;
  }
  ```
- Suppress hydration warning on known dynamic attributes: `suppressHydrationWarning`.
- For CSS-in-JS (Styled Components, Emotion), configure SSR style collectors in your document wrapper.

### C. Base Asset URL & Font Resolution
**The Bug**: CSS references `/fonts/inter.woff2` or `url('/images/bg.png')`. In production or subpath deployments (`https://domain.com/app/`), assets return 404, breaking typography and icons.

**Protections**:
- **Vite (`vite.config.ts`)**:
  ```typescript
  export default defineConfig({
    base: process.env.BASE_URL || '/',
    build: {
      assetsDir: 'assets',
      cssCodeSplit: true,
    }
  });
  ```
- **Next.js (`next.config.js`)**:
  ```javascript
  module.exports = {
    assetPrefix: process.env.ASSET_PREFIX || undefined,
    trailingSlash: false,
  };
  ```

---

## 2. Aggressive Cache Invalidation (Always Deliver Updated Code)

### A. Pre-Build Artifact Cleaning
Always purge leftover artifacts before bundling to prevent zombie chunks from contaminating the build manifest.
```bash
# Clean script in package.json
"prebuild": "rm -rf dist .next .vite out node_modules/.cache"
```

### B. The Two-Tier Caching Architecture (Critical!)
Browsers MUST never cache `index.html`. Browsers MUST permanently cache hashed assets.

| Resource Type | Cache-Control Header | Reason |
|---------------|----------------------|--------|
| **HTML / Entrypoints** (`index.html`, `/`) | `no-cache, no-store, must-revalidate` | Ensures browser checks server every time and gets the latest asset hash pointers. |
| **Hashed Bundles** (`/assets/*.js`, `*.css`) | `public, max-age=31536000, immutable` | Instant load from disk cache; automatically busted when filename hash changes. |
| **Static Images/Favicons** (`/favicon.ico`) | `public, max-age=86400, must-revalidate` | Short cache with ETag revalidation. |

#### Platform Configurations:

#### Nginx Configuration:
```nginx
server {
    root /var/www/my-app/dist;
    index index.html;

    # 1. HTML entrypoint: NEVER cache
    location ~* \.html$ {
        add_header Cache-Control "no-store, no-cache, must-revalidate, proxy-revalidate, max-age=0";
        expires -1;
    }

    # 2. Immutable hashed assets
    location ~* \.(js|css|webp|png|jpg|jpeg|gif|ico|svg|woff2|woff)$ {
        add_header Cache-Control "public, max-age=31536000, immutable";
    }

    # 3. SPA Fallback
    location / {
        try_files $uri $uri/ /index.html;
        add_header Cache-Control "no-store, no-cache, must-revalidate";
    }
}
```

#### Vercel (`vercel.json`):
```json
{
  "headers": [
    {
      "source": "/(.*\\.html|/)",
      "headers": [
        { "key": "Cache-Control", "value": "no-cache, no-store, must-revalidate" }
      ]
    },
    {
      "source": "/assets/(.*)",
      "headers": [
        { "key": "Cache-Control", "value": "public, max-age=31536000, immutable" }
      ]
    }
  ]
}
```

### C. Self-Healing Client (Handling `ChunkLoadError`)
When you deploy a new build, old chunk hashes on the server disappear. Users with the old page open will crash when clicking a lazy-loaded route (`ChunkLoadError: Loading chunk failed`).

**Add this Global Error Boundary / Listener in your client entrypoint (`main.tsx` or `_app.tsx`)**:
```typescript
// Auto-reload once if dynamic chunk loading fails due to a fresh deployment
window.addEventListener('error', (event) => {
  const isChunkError = /Loading chunk [\d]+ failed|Failed to fetch dynamically imported module/i.test(
    event.message || ''
  );
  if (isChunkError) {
    const lastReload = sessionStorage.getItem('chunk_reload_ts');
    const now = Date.now();
    // Prevent infinite reload loop (limit to 1 reload per 15 seconds)
    if (!lastReload || now - parseInt(lastReload, 10) > 15000) {
      sessionStorage.setItem('chunk_reload_ts', now.toString());
      window.location.reload();
    }
  }
});
```

### D. Service Worker & PWA Instant Eviction
If a Service Worker is active, it will hijack requests unless instructed to release control immediately:
```javascript
// Inside sw.js / service-worker.js
self.addEventListener('install', (event) => {
  // Activate immediately without waiting for existing tabs to close
  self.skipWaiting();
});

self.addEventListener('activate', (event) => {
  // Claim all open clients immediately
  event.waitUntil(self.clients.claim());
});
```

---

## 3. Backend & API Contract Stability (Zero Backend Breakage)

### A. Build-Time Environment Variable Verification
**The Bug**: Building for production when `VITE_API_URL` or `NEXT_PUBLIC_BACKEND_URL` is unset causes the build to bake in `undefined` or fallback to `http://localhost:5000`.

**Add a Pre-Build Schema Validation (`scripts/validate-env.ts` or `src/env.ts`)**:
```typescript
import { z } from 'zod';

const envSchema = z.object({
  NODE_ENV: z.enum(['development', 'production', 'test']),
  VITE_API_URL: z.string().url('VITE_API_URL must be a valid production URL'),
});

const result = envSchema.safeParse(process.env);
if (!result.success) {
  console.error('❌ CRITICAL BUILD ERROR: Invalid or missing Environment Variables:');
  console.error(result.error.format());
  process.exit(1);
}
```

### B. CORS & Allowed Origins Parity
Ensure your backend configures CORS to accept both the production domain and preview URLs:
- Allow required headers: `Authorization`, `Content-Type`, `X-Requested-With`, `sentry-trace`.
- Allow credentials if using cookies: `credentials: true`.
- Handle preflight `OPTIONS` requests with status `204 No Content` or `200 OK`.

### C. Safe Rolling Deployments & Additive Changes
When releasing updates:
1. **Never drop or rename API fields** that the currently active client sessions rely on.
2. **Deploy sequence**:
   - Step 1: Deploy backwards-compatible Backend changes (handles both old and new payload shapes).
   - Step 2: Run Database migrations (non-destructive, default values for new columns).
   - Step 3: Deploy Frontend build.
   - Step 4: Deprecate old fields only after 100% of user sessions have migrated.

---

## Pre-Flight Build Checklist

Before deploying any production build, run this verification checklist:

| Check | Command / Verification | Goal |
|-------|------------------------|------|
| **1. Clean Build** | `rm -rf dist .next .vite && npm run build` | Zero cached zombie chunks. |
| **2. CSS Verification** | Inspect output `.css` in `dist/assets/` | File size > 0, key utility classes present. |
| **3. Asset Hashes** | Check filenames in output | All `.js` and `.css` have contenthashes (e.g. `index.d8a7c2.js`). |
| **4. No Localhost Leak** | `grep -rn "localhost:" dist/` | Ensure no local dev endpoints were bundled into prod. |
| **5. No Undefined URLs** | `grep -rn "undefined/api" dist/` | Ensure all API prefixes resolved. |
| **6. Healthcheck** | `curl -f -I https://api.yourdomain.com/health` | Backend responds with 200 OK before frontend cutover. |

---

## Ready-to-Use `package.json` Scripts

Add these verified commands to your project's `package.json`:

```json
{
  "scripts": {
    "clean": "rimraf dist .next .vite out node_modules/.cache",
    "prebuild": "npm run clean",
    "build": "vite build",
    "postbuild": "node -e \"const fs = require('fs'); const html = fs.readFileSync('dist/index.html', 'utf8'); if (!html.includes('.js')) throw new Error('Build corrupted: no scripts in index.html'); console.log('✅ Build verified.');\"",
    "check:env": "node -e \"if (!process.env.VITE_API_URL) console.warn('⚠️ Warning: VITE_API_URL not set in environment.');\""
  }
}
```

# Backend Stability & API Contract Safety During Deployments

A frontend release must never crash due to broken API endpoints, mismatched CORS headers, or unhandled response changes.

---

## 1. Environment Variable Integrity

### The Hazard
In client-side frameworks (Vite, Next.js client, CRA), environment variables are **baked into the static JavaScript at build time**.
- If `VITE_API_URL` is undefined when running `npm run build`, your production bundle will literally contain `fetch("undefined/api/users")`!
- The app appears to compile successfully, but immediately crashes at runtime in production.

### The Remedy: Strict Schema Validation
Create `src/env.ts` (or `scripts/check-env.js`) and import it at your application's entrypoint:

```typescript
// src/env.ts
import { z } from 'zod';

const clientEnvSchema = z.object({
  VITE_API_BASE_URL: z
    .string()
    .url('VITE_API_BASE_URL must be a valid HTTPS/HTTP URL')
    .refine((url) => !url.includes('localhost'), {
      message: 'CRITICAL: VITE_API_BASE_URL must not point to localhost in production!',
    }),
  VITE_APP_ENV: z.enum(['development', 'staging', 'production']),
});

// Validate process.env / import.meta.env
export const env = clientEnvSchema.parse({
  VITE_API_BASE_URL: import.meta.env.VITE_API_BASE_URL,
  VITE_APP_ENV: import.meta.env.VITE_APP_ENV || 'production',
});
```

---

## 2. CORS & Preflight Configuration

When deploying a new frontend (or preview branch), ensure your backend accepts requests from the new origin:

### Express.js Example:
```javascript
const allowedOrigins = [
  'https://my-app.com',
  'https://staging.my-app.com',
  /\.vercel\.app$/, // Allow Vercel preview deployments
];

app.use(
  cors({
    origin: (origin, callback) => {
      // Allow requests with no origin (mobile apps, curl)
      if (!origin) return callback(null, true);
      const isAllowed = allowedOrigins.some((allowed) =>
        allowed instanceof RegExp ? allowed.test(origin) : allowed === origin
      );
      if (isAllowed) return callback(null, true);
      return callback(new Error(`CORS Error: Origin ${origin} not allowed`));
    },
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With', 'sentry-trace'],
  })
);
```

---

## 3. Safe Rolling Deployments & Additive Changes

During rolling deployments or when users haven't refreshed their browser tab:
1. **Old frontend clients are still hitting your backend.**
2. If the backend drops an old field or abruptly changes a payload structure, old active sessions will crash with `TypeError: Cannot read properties of undefined`.

### The Expand-and-Contract Rule:
- **Phase 1 (Expand)**: Add new database columns with `NULL` or default values. Backend returns *both* old and new fields.
- **Phase 2 (Frontend Deploy)**: Deploy new frontend build that reads new fields with fallback to old fields.
- **Phase 3 (Contract)**: After 24–48 hours (when all client sessions are updated), safely remove the deprecated fields from backend responses.

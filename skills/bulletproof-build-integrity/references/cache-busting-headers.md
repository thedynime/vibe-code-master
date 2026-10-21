# Cache-Busting Headers & CDN Invalidation Guide

This reference provides exact server and CDN headers to enforce **Zero Stale Assets** while maximizing performance.

---

## 1. The Core Cache Invalidation Rule

- **HTML Entrypoint (`index.html`)**: Must NEVER be cached on disk without revalidation. If a browser caches HTML for 1 year, the user will never see your latest deployment until they manually hard-refresh (`Ctrl+F5`).
- **Hashed Assets (`/assets/*.[hash].js|css`)**: Safe to cache forever (`immutable`). When you change 1 line of code, the bundler generates a new hash, and the fresh `index.html` points to the new file name.

---

## 2. Server Configuration Snippets

### A. Nginx (`/etc/nginx/sites-available/default`)

```nginx
server {
    listen 80;
    listen 443 ssl http2;
    server_name example.com;
    root /var/www/my-app/dist;
    index index.html;

    # 1. HTML Entrypoints & Service Workers: Zero Cache
    location ~* (\.html|service-worker\.js|sw\.js|manifest\.json)$ {
        add_header Cache-Control "no-store, no-cache, must-revalidate, proxy-revalidate, max-age=0" always;
        expires -1;
    }

    # 2. Bundled & Hashed Assets: Infinite Cache
    location ~* ^/assets/.*\.(js|css|webp|png|jpg|jpeg|gif|ico|svg|woff2|woff)$ {
        add_header Cache-Control "public, max-age=31536000, immutable" always;
        access_log off;
    }

    # 3. Static Media (Unversioned): 1 Day Cache with ETag revalidation
    location ~* \.(jpg|jpeg|png|gif|ico|svg)$ {
        add_header Cache-Control "public, max-age=86400, must-revalidate" always;
    }

    # 4. Single Page Application (SPA) Routing Fallback
    location / {
        try_files $uri $uri/ /index.html;
        add_header Cache-Control "no-store, no-cache, must-revalidate" always;
    }
}
```

---

### B. Vercel (`vercel.json`)

```json
{
  "headers": [
    {
      "source": "/(.*\\.html|/|sw\\.js)",
      "headers": [
        {
          "key": "Cache-Control",
          "value": "no-cache, no-store, must-revalidate"
        }
      ]
    },
    {
      "source": "/assets/(.*)",
      "headers": [
        {
          "key": "Cache-Control",
          "value": "public, max-age=31536000, immutable"
        }
      ]
    }
  ]
}
```

---

### C. Cloudflare Page Rules / Cache Rules

When routing through Cloudflare:
1. **Rule 1 (HTML Entrypoint)**:
   - Field: `URI Path` equals `/` OR `URI Path` ends with `.html`
   - Cache Eligibility: **Bypass Cache**
   - Edge Cache TTL: **Respect Origin**
2. **Rule 2 (Hashed Assets)**:
   - Field: `URI Path` starts with `/assets/`
   - Cache Eligibility: **Cache Everything**
   - Edge Cache TTL: **1 Month** (or 1 Year)
   - Browser Cache TTL: **1 Year**

---

### D. Dockerfile SPA (Multi-Stage Build with Clean Nginx)

```dockerfile
# Stage 1: Build
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
# Clean cache before build
RUN rm -rf dist .next .vite
RUN npm run build

# Stage 2: Serve
FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

# Deployment Guide (Hostinger & Static Hosting)

## Step 0: The Hostinger Connector & Static Hosting Setup
- Hostinger static deploy uses token or API connectors to publish a single folder (`index.html` + `assets/`).
- Free temporary subdomains or custom domains with SSL can be provisioned.

## Deployment Flow
1. Verify `index.html` exists and references all assets relatively (`assets/...`).
2. Ensure no raw `.mp4` video files or large uncompressed PNGs are left inside `assets/`.
3. Zip the contents of the project folder:
   ```bash
   zip -r site-deploy.zip index.html assets/
   ```
4. Deploy to Hostinger or your chosen static hosting platform (Vercel, Netlify, GitHub Pages, Cloudflare Pages).
5. Verify live URL and measure Core Web Vitals (LCP < 2.5s, CLS < 0.1).

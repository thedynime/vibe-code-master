---
name: pause-deploy
description: "Pause and freeze all live deployments, remote git pushes, and production releases."
---

# Pause Deploy (/pause-deploy)

Enforces **Local Verification Mode** by pausing all live production deployments, remote git pushes, and hosting release commands. This decouples local development and testing from live releases so you can thoroughly test changes locally before publishing to production.

---

## 1. When Invoked (`/pause-deploy`)

When the user calls `/pause-deploy`, immediately execute these actions:

1. **Activate Deployment Quarantine**:
   - Set internal session flag: `DEPLOYMENT_PAUSED = true`.
   - Create a lock marker file in the repository root if in a git project:
     ```bash
     touch .deploy-pause
     ```
   - (Ensure `.deploy-pause` is ignored in `.gitignore` if appropriate).
2. **Acknowledge Mode Change**:
   - Inform the user:
     > 🛑 **Deployment Paused**: Live deployments and remote git pushes are now frozen. All changes will be developed and tested strictly on localhost. Deployments to live servers will only trigger when you explicitly say **"deploy to live"**, **"push to via"**, **"push to prod"**, or **"redeploy"**. (Use `/open-deploy` to return to continuous automatic deployment).

---

## 2. Hard Deployment Quarantine (Banned While Paused)

While in paused mode, the agent is **STRICTLY PROHIBITED** from executing any of the following without an explicit release command:

| Category | Banned Commands / Actions |
| :--- | :--- |
| **Git Push** | `git push`, `git push origin main`, `git push --tags`, pushing to any remote branch |
| **Vercel** | `vercel --prod`, `vercel deploy`, `vercel link --yes` with remote push |
| **Firebase** | `firebase deploy`, `firebase deploy --only hosting` |
| **Cloudflare / Fly / Railway** | `wrangler deploy`, `wrangler publish`, `fly deploy`, `railway up` |
| **Static / Rsync / SSH** | `rsync` to production server, `ssh` remote deploy scripts, `ftp` uploads |
| **Package Registries** | `npm publish`, `twine upload`, publishing release tags |
| **CI/CD Triggers** | Triggering remote GitHub Actions release pipelines or auto-deploy webhooks |

> [!CAUTION]
> Even if a project's `AGENTS.md` or system reflex says *"always stage, commit, and push updates to origin main"*, the `/pause-deploy` lockdown **OVERRIDES** that reflex. Do NOT push to remote repositories.

---

## 3. Local Development & Testing Workflow

All work during `/pause-deploy` must focus on local execution:

1. **Make Edits**: Modify files and assets as requested.
2. **Verify Locally**:
   - Check types and builds: `npm run build` (or `tsc -b`, `pnpm build`, `vite build`).
   - Run dev server: `npm run dev` (or `yarn dev`, `next dev`).
   - Run local linters / unit tests: `npm test`, `npm run lint`.
3. **Present Local Verification to User**:
   - Report local test results.
   - Provide the local test URL (e.g., `http://localhost:5173`, `http://localhost:3000`).
   - Ask the user to verify the changes in their local browser.

---

## 4. Approval Disambiguation ("It's OK" Rule)

Users frequently give positive feedback during local testing. **You must NEVER treat casual praise or local approval as a trigger to deploy.**

### ❌ These DO NOT mean "Deploy":
- *"it's ok"*
- *"it's good"*
- *"looks good"* / *"looks great"*
- *"nice"* / *"cool"* / *"awesome"*
- *"continue"* / *"proceed"*
- *"fixed"* / *"done"* / *"thanks"*

**Agent Response to Casual Approval:**
> *"Glad the local changes look good! Deployment is still paused. What would you like to test or adjust next? (Whenever you are ready to publish to production, simply say **'deploy to live'** or **'push to prod'**)."*

---

## 5. Explicit Release Gate (How to Deploy)

Live deployment is unlocked **ONLY** when the user provides an unequivocal, deliberate release instruction containing one of these trigger keywords:

### ✅ Valid Deployment Triggers:
- `"deploy to live"` / `"deploy live"`
- `"push to via"` / `"push to origin main"` / `"push to prod"` / `"push to production"`
- `"redeploy"` / `"redeploy to live"`
- `"publish to live server"`
- `"ship to production"`
- `"release now"`

### Pre-Flight Release Checklist:
When an explicit deployment command is received, execute this sequence:

1. **Check Status**: `git status` and `git diff --stat` to review changed files.
2. **Build Sanity Check**: Run `npm run build` (or project build command) to verify zero build errors.
3. **Stage & Commit**:
   ```bash
   git add .
   git commit -m "<type>(scope): description of verified changes"
   ```
4. **Push / Deploy**:
   ```bash
   git push origin main
   # or project-specific deploy command (e.g., vercel --prod, npm run deploy)
   ```
5. **Report Outcome**: Output the deployment status, commit hash, and live URL.
6. **Remain Paused**: Remind the user that deployment remains paused for future edits unless they call `/open-deploy`.

---

## 6. How to Deactivate

To turn off `/pause-deploy` and restore default continuous single-prompt deployment, the user calls:
```
/open-deploy
```
This removes the `.deploy-pause` lock file and re-enables direct edit-and-deploy workflows.

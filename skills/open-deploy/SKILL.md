---
name: open-deploy
description: "Unpause and restore standard live deployment behavior, deactivating /pause-deploy mode."
---

# Open Deploy (/open-deploy)

Deactivates **Local Verification Mode** established by `/pause-deploy` and restores the standard deployment workflow.

---

## 1. When Invoked (`/open-deploy`)

When the user calls `/open-deploy`, immediately execute these actions:

1. **Remove Deployment Lock**:
   - Set internal session flag: `DEPLOYMENT_PAUSED = false`.
   - Remove the lock file if present:
     ```bash
     rm -f .deploy-pause
     ```
2. **Acknowledge Mode Change**:
   - Inform the user:
     > 🟢 **Deployments Open**: The deployment pause lock has been removed. Standard single-prompt edit-and-deploy / continuous git sync workflows are now active. Changes can be deployed or pushed directly upon prompt completion if requested or configured by project rules.

---

## 2. Restored Behavior

Once `/open-deploy` is executed:
- The agent is no longer constrained by the deployment freeze.
- Single-prompt edit-and-deploy requests (e.g. "update header and deploy", "fix CSS and push to github") will execute both the local modification and the push/deploy step.
- Project-level continuous sync reflexes (such as committing and pushing to `origin main` upon task completion) resume normal operation.

---

## 3. Switching Back to Local-Only Testing

To pause live deployments again at any point in the future, simply invoke:
```
/pause-deploy
```

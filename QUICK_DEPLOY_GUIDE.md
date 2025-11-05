# ⚡ Quick Deploy Guide - VulHub Leaderboard to Heroku

**For**: lafintiger  
**Date**: November 5, 2025  
**Time to Complete**: 15-20 minutes

---

## ✅ What's Already Done

I've updated your codebase for Heroku deployment:
- ✅ Fixed `Procfile` for proper API startup
- ✅ Added `heroku-postbuild` script to `package.json`
- ✅ GitHub Actions workflow is configured
- ✅ Created detailed deployment guide

---

## 🚀 Quick Start (3 Steps)

### Step 1: Add GitHub Secrets (2 minutes)

Go to: https://github.com/lafintiger/VulHub-LeaderBoard-Web/settings/secrets/actions

Click **"New repository secret"** and add these 3 secrets:

1. **HEROKU_API_KEY**
   ```
   Your-Heroku-API-Key-From-Account-Settings
   ```
   (Find this in Heroku Dashboard → Account Settings → API Key)

2. **HEROKU_APP_NAME**
   ```
   vulhub-leaderboard-api
   ```
   (or whatever name you choose for your Heroku app)

3. **HEROKU_EMAIL**
   ```
   your-heroku-account-email@example.com
   ```
   (the email you use to login to Heroku)

---

### Step 2: Create Heroku App & Add PostgreSQL (5 minutes)

**Using Heroku Dashboard:**
1. Go to https://dashboard.heroku.com/apps
2. Click **"New"** → **"Create new app"**
3. Name: `vulhub-leaderboard-api` (must match GitHub secret!)
4. Region: **United States**
5. Click **"Create app"**

**Add PostgreSQL:**
1. Go to **Resources** tab
2. Search for "Heroku Postgres" in Add-ons
3. Select **"Essential-0"** plan ($7/month)
4. Click **"Submit Order Form"**

**Add Config Vars (Important!):**
1. Go to **Settings** → **Config Vars** → **Reveal Config Vars**
2. Add these manually:

| Key | Value |
|-----|-------|
| `NODE_ENV` | `production` |
| `JWT_SECRET` | Run `openssl rand -base64 32` in terminal and paste result |
| `JWT_REFRESH_SECRET` | Run `openssl rand -base64 32` again (different value!) |
| `CORS_ORIGIN` | `https://vulhub-leaderboard.vercel.app` (update after deploying frontend) |

**Note:** `DATABASE_URL` is automatically set by the PostgreSQL addon.

---

### Step 3: Deploy via GitHub (3 minutes)

```bash
# Make sure you're on main branch
git checkout main

# Commit the changes I made
git add Procfile package.json
git commit -m "Configure for Heroku deployment"

# Push to GitHub - this triggers automatic deployment!
git push origin main
```

**Monitor deployment:**
1. Go to https://github.com/lafintiger/VulHub-LeaderBoard-Web/actions
2. Click on the latest "Deploy to Heroku" workflow
3. Watch it complete (takes ~3-5 minutes)
4. ✅ All steps should turn green

---

## ✅ Verify It Works

### Test the API:

```bash
# Replace with your actual app name
curl https://vulhub-leaderboard-api.herokuapp.com/health
```

**Expected response:**
```json
{
  "status": "ok",
  "timestamp": "2025-11-05T...",
  "uptime": 123.45,
  "message": "API is running successfully!",
  "version": "1.0.0",
  "environment": "production"
}
```

### Check Logs:

```bash
heroku logs --tail -a vulhub-leaderboard-api
```

Look for:
- ✅ "Application is running on..."
- ✅ No error messages

---

## 📱 Next: Deploy Frontend to Vercel (Optional)

The frontend (Next.js app) works best on Vercel (it's free!):

1. **Go to**: https://vercel.com/new
2. **Import**: Your GitHub repository
3. **Root Directory**: Select `apps/web`
4. **Environment Variable**: Add one variable:
   - Name: `NEXT_PUBLIC_API_URL`
   - Value: `https://vulhub-leaderboard-api.herokuapp.com/api/v1`
5. **Deploy!**

**After deploying frontend:**
Update CORS_ORIGIN on Heroku:
```bash
heroku config:set CORS_ORIGIN="https://your-vercel-url.vercel.app" -a vulhub-leaderboard-api
```

---

## 🆘 Troubleshooting

### "Application Error" on Heroku?

```bash
# Check logs
heroku logs --tail -a vulhub-leaderboard-api

# Look for errors about:
# - Missing DATABASE_URL → Add PostgreSQL addon
# - Missing JWT_SECRET → Add config var
# - Port binding → Should auto-set
```

### GitHub Actions fails?

1. **Check secrets**: Settings → Secrets → Actions
   - All 3 secrets must be present
   - No typos in secret names
   - Values are correct

2. **Check Heroku app name**: Must match `HEROKU_APP_NAME` secret exactly

### CORS errors in browser?

```bash
# Update CORS_ORIGIN with your frontend URL
heroku config:set CORS_ORIGIN="https://your-frontend-url.com" -a vulhub-leaderboard-api
```

---

## 💰 Cost Summary

| Service | Plan | Cost/Month |
|---------|------|-----------|
| Heroku Eco Dyno | Always-on server | $5 |
| PostgreSQL Essential-0 | 500MB database | $7 |
| Vercel (Frontend) | Free tier | $0 |
| **Total** | | **$12/month** |

Optional:
- Heroku Redis Mini: +$3/month (or use free Upstash)

---

## 📚 Full Documentation

For detailed information, see:
- **HEROKU_DEPLOYMENT_INSTRUCTIONS.md** - Comprehensive guide
- **docs/HEROKU_DEPLOYMENT_GUIDE.md** - Original deployment docs
- **docs/HEROKU_QUICK_REFERENCE.md** - Command reference

---

## 🎯 Summary

**Your deployment URLs will be:**
- **API**: `https://vulhub-leaderboard-api.herokuapp.com`
- **API Health**: `https://vulhub-leaderboard-api.herokuapp.com/health`
- **API Docs**: `https://vulhub-leaderboard-api.herokuapp.com/api/docs`
- **Frontend** (after Vercel): `https://vulhub-leaderboard.vercel.app`

---

**Questions? Issues?** Check the logs first: `heroku logs --tail -a vulhub-leaderboard-api`

**Good luck! 🚀**


# 🚀 Heroku Deployment Instructions - VulHub Leaderboard

**Last Updated**: November 5, 2025  
**Status**: ✅ Ready to Deploy  
**Your Heroku API Key**: (stored in GitHub Secrets)

---

## 📋 Quick Overview

This guide will deploy the **VulHub Leaderboard API** (NestJS backend) to Heroku. The frontend (Next.js) should be deployed separately to Vercel for optimal performance.

**What's Being Deployed:**
- ✅ API (NestJS) → Heroku
- 📦 Database (PostgreSQL) → Heroku PostgreSQL addon
- 🔴 Redis (Optional) → Heroku Redis addon or skip

---

## 🎯 Step 1: Create Heroku App

### Option A: Using Heroku Dashboard (Easiest)
1. Go to https://dashboard.heroku.com/apps
2. Click **"New"** → **"Create new app"**
3. Enter app name: `vulhub-leaderboard-api` (or your choice)
4. Choose region: **United States**
5. Click **"Create app"**

### Option B: Using Heroku CLI
```bash
# Install Heroku CLI if not installed
# macOS: brew tap heroku/brew && brew install heroku
# Windows: Download from https://devcenter.heroku.com/articles/heroku-cli

# Login to Heroku
heroku login

# Create new app
heroku create vulhub-leaderboard-api

# Note: Replace 'vulhub-leaderboard-api' with your preferred name
```

**✅ Save your app name:** `_______________________________`

---

## 🗄️ Step 2: Add PostgreSQL Database

### Add the Heroku PostgreSQL addon:

```bash
# Option 1: Using Heroku CLI
heroku addons:create heroku-postgresql:essential-0 -a vulhub-leaderboard-api

# Option 2: Using Dashboard
# Go to your app → Resources tab → Add-ons → Search "Heroku Postgres"
# Select "Essential-0" plan ($7/month)
```

**Cost**: $7/month for Essential-0 plan (500MB storage, 20 connections)

✅ **This automatically sets the `DATABASE_URL` environment variable**

---

## 🔴 Step 3: Add Redis (Optional)

Redis is optional - the app has in-memory fallback.

```bash
# Option 1: Skip Redis (app will work fine)
# No action needed

# Option 2: Add Heroku Redis addon
heroku addons:create heroku-redis:mini -a vulhub-leaderboard-api
# Cost: $3/month

# Option 3: Use Upstash Redis (Free alternative)
# 1. Create free account at https://upstash.com
# 2. Create Redis database
# 3. Copy the REDIS_URL and add as config var (see Step 4)
```

---

## 🔐 Step 4: Set Environment Variables

### Required Config Vars

Run these commands or add them via the Heroku Dashboard:

```bash
# Set the app name variable for convenience
APP_NAME=vulhub-leaderboard-api

# Required variables
heroku config:set NODE_ENV=production -a $APP_NAME
heroku config:set JWT_SECRET="$(openssl rand -base64 32)" -a $APP_NAME
heroku config:set JWT_REFRESH_SECRET="$(openssl rand -base64 32)" -a $APP_NAME
heroku config:set CORS_ORIGIN="https://your-frontend-url.vercel.app" -a $APP_NAME

# Optional: If not using Redis addon, you can skip these
# If you added Heroku Redis addon, these are auto-set
# If using external Redis (like Upstash):
heroku config:set REDIS_HOST="your-redis-host.upstash.io" -a $APP_NAME
heroku config:set REDIS_PORT="your-redis-port" -a $APP_NAME
heroku config:set REDIS_PASSWORD="your-redis-password" -a $APP_NAME
```

### Via Heroku Dashboard:
1. Go to your app → **Settings** → **Config Vars** → **Reveal Config Vars**
2. Add these variables:

| Config Var | Value | Notes |
|------------|-------|-------|
| `NODE_ENV` | `production` | Required |
| `DATABASE_URL` | (Auto-set by PostgreSQL addon) | Don't modify |
| `JWT_SECRET` | Generate 32+ char random string | Required - use `openssl rand -base64 32` |
| `JWT_REFRESH_SECRET` | Generate different 32+ char string | Required |
| `CORS_ORIGIN` | `https://your-frontend.vercel.app` | Replace with actual frontend URL |
| `REDIS_HOST` | Auto-set if using addon | Optional |
| `REDIS_PORT` | Auto-set if using addon | Optional |
| `REDIS_PASSWORD` | Auto-set if using addon | Optional |

---

## 🔧 Step 5: Configure GitHub for Deployment

### Add GitHub Secrets

1. Go to your GitHub repository: https://github.com/lafintiger/VulHub-LeaderBoard-Web
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **"New repository secret"** and add these 3 secrets:

| Secret Name | Value | Where to find it |
|-------------|-------|------------------|
| `HEROKU_API_KEY` | Your Heroku API key | Find in Heroku Account Settings → API Key |
| `HEROKU_APP_NAME` | `vulhub-leaderboard-api` | Your app name from Step 1 |
| `HEROKU_EMAIL` | Your Heroku account email | The email you use to login to Heroku |

**⚠️ Important**: Make sure to enter the secrets EXACTLY as shown, no extra spaces!

---

## 🚀 Step 6: Deploy to Heroku

### Method 1: Automatic Deployment via GitHub Actions (Recommended)

The repository already has GitHub Actions configured (`.github/workflows/deploy.yml`).

**To trigger deployment:**

```bash
# Make sure you're on the main branch
git checkout main

# Make a small change and commit (or just push if you have changes)
git add .
git commit -m "Deploy to Heroku"
git push origin main
```

**This will automatically:**
1. ✅ Build the application
2. ✅ Deploy to Heroku
3. ✅ Run database migrations
4. ✅ Show logs

**Monitor deployment:**
1. Go to GitHub → Your repository → **Actions** tab
2. Click on the latest "Deploy to Heroku" workflow run
3. Watch the progress (takes ~3-5 minutes)

### Method 2: Manual Deployment via Heroku CLI

```bash
# Login to Heroku
heroku login

# Add Heroku remote
heroku git:remote -a vulhub-leaderboard-api

# Deploy main branch
git push heroku main

# Run database migrations
heroku run "cd apps/api && pnpm prisma migrate deploy" -a vulhub-leaderboard-api

# Check logs
heroku logs --tail -a vulhub-leaderboard-api
```

---

## 🔍 Step 7: Verify Deployment

### Check API Health

```bash
# Replace with your actual app name
APP_URL=https://vulhub-leaderboard-api.herokuapp.com

# Test health endpoint
curl $APP_URL/health

# Expected response:
# {"status":"ok","timestamp":"2025-11-05T...","uptime":123.45,...}

# Test API endpoint
curl $APP_URL/api/v1/health

# Test with browser
# Open: https://vulhub-leaderboard-api.herokuapp.com/health
```

### Check Logs

```bash
heroku logs --tail -a vulhub-leaderboard-api
```

**Look for:**
- ✅ "Application is running on: http://0.0.0.0:[PORT]"
- ✅ "API Documentation: http://..."
- ✅ "Health Check: http://..."
- ❌ No errors about missing DATABASE_URL
- ❌ No errors about missing JWT_SECRET

---

## 📊 Step 8: Run Database Setup

### Run migrations and seed data:

```bash
APP_NAME=vulhub-leaderboard-api

# Run Prisma migrations
heroku run "cd apps/api && pnpm prisma migrate deploy" -a $APP_NAME

# Generate Prisma client (if needed)
heroku run "cd apps/api && pnpm prisma generate" -a $APP_NAME

# Optional: Seed database with test data
heroku run "cd apps/api && pnpm db:seed" -a $APP_NAME
```

---

## 🌐 Step 9: Deploy Frontend to Vercel (Recommended)

The frontend (Next.js) should be deployed to Vercel for best performance.

### Quick Vercel Deployment:

1. **Sign up at Vercel**: https://vercel.com/signup
2. **Import your GitHub repository**
3. **Configure environment variables**:
   - `NEXT_PUBLIC_API_URL` = `https://vulhub-leaderboard-api.herokuapp.com/api/v1`
4. **Deploy**

**Or use Vercel CLI:**

```bash
# Install Vercel CLI
npm install -g vercel

# Login
vercel login

# Deploy from the web app directory
cd apps/web
vercel --prod

# Set environment variable
vercel env add NEXT_PUBLIC_API_URL
# Enter: https://vulhub-leaderboard-api.herokuapp.com/api/v1
```

### Update CORS_ORIGIN

After deploying to Vercel, update the API's CORS settings:

```bash
# Get your Vercel URL (e.g., vulhub-leaderboard.vercel.app)
heroku config:set CORS_ORIGIN="https://vulhub-leaderboard.vercel.app" -a vulhub-leaderboard-api
```

---

## ✅ Deployment Checklist

- [ ] Heroku app created (`vulhub-leaderboard-api`)
- [ ] PostgreSQL addon added (Essential-0, $7/month)
- [ ] Redis addon added OR skipped (optional)
- [ ] All config vars set (NODE_ENV, JWT_SECRET, JWT_REFRESH_SECRET, CORS_ORIGIN)
- [ ] GitHub secrets added (HEROKU_API_KEY, HEROKU_APP_NAME, HEROKU_EMAIL)
- [ ] Code pushed to GitHub main branch
- [ ] GitHub Actions deployment completed successfully
- [ ] Health endpoint returns 200 OK
- [ ] Database migrations completed
- [ ] (Optional) Database seeded with test data
- [ ] Frontend deployed to Vercel
- [ ] CORS_ORIGIN updated with Vercel URL
- [ ] Test login/authentication works

---

## 🚨 Troubleshooting

### Issue: "Application Error" on Heroku

**Check logs:**
```bash
heroku logs --tail -a vulhub-leaderboard-api
```

**Common fixes:**
1. Missing `DATABASE_URL` → Add PostgreSQL addon
2. Missing `JWT_SECRET` → Set config var
3. Build failed → Check `heroku-postbuild` script
4. Port binding issue → Heroku sets PORT automatically

### Issue: CORS Errors

**Fix:**
```bash
heroku config:set CORS_ORIGIN="https://your-frontend-url.vercel.app,https://another-domain.com" -a vulhub-leaderboard-api
```

### Issue: Database Connection Error

**Check DATABASE_URL:**
```bash
heroku config:get DATABASE_URL -a vulhub-leaderboard-api
```

**Should start with:** `postgresql://...`

### Issue: Build Takes Too Long / Fails

**Restart build:**
```bash
heroku builds:cancel -a vulhub-leaderboard-api
git commit --allow-empty -m "Trigger rebuild"
git push heroku main
```

### Issue: "No web processes running"

**Scale up the dyno:**
```bash
heroku ps:scale web=1 -a vulhub-leaderboard-api
```

---

## 💰 Monthly Cost Estimate

| Service | Plan | Cost |
|---------|------|------|
| **Heroku Dyno** | Eco | $5/month |
| **PostgreSQL** | Essential-0 | $7/month |
| **Redis** (optional) | Mini | $3/month |
| **Vercel** (frontend) | Free | $0 |
| **Total** | | **$12-15/month** |

---

## 📚 Useful Commands

```bash
# View logs
heroku logs --tail -a vulhub-leaderboard-api

# Restart app
heroku restart -a vulhub-leaderboard-api

# Run bash in Heroku
heroku run bash -a vulhub-leaderboard-api

# Check dyno status
heroku ps -a vulhub-leaderboard-api

# View config vars
heroku config -a vulhub-leaderboard-api

# Open app in browser
heroku open -a vulhub-leaderboard-api

# View app info
heroku info -a vulhub-leaderboard-api

# Scale dynos
heroku ps:scale web=1 -a vulhub-leaderboard-api
```

---

## 🎉 Success!

Your API should now be live at:
- **API Base URL**: `https://vulhub-leaderboard-api.herokuapp.com/api/v1`
- **Health Check**: `https://vulhub-leaderboard-api.herokuapp.com/health`
- **API Docs**: `https://vulhub-leaderboard-api.herokuapp.com/api/docs`

### Test Authentication

```bash
# Test registration
curl -X POST https://vulhub-leaderboard-api.herokuapp.com/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "testpassword123",
    "name": "Test User"
  }'

# Test login
curl -X POST https://vulhub-leaderboard-api.herokuapp.com/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "testpassword123"
  }'
```

---

## 🆘 Need Help?

1. **Check GitHub Actions logs**: Repository → Actions → Latest run
2. **Check Heroku logs**: `heroku logs --tail -a vulhub-leaderboard-api`
3. **Verify config vars**: `heroku config -a vulhub-leaderboard-api`
4. **Restart app**: `heroku restart -a vulhub-leaderboard-api`

---

**Made with ❤️ for VulHub Leaderboard**


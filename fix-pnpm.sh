#!/bin/bash

cd VulHub-LeaderBoard-Web

echo "🔧 Switching to pnpm-compatible buildpack..."

# Clear existing buildpacks and add pnpm-specific one
heroku buildpacks:clear --app vulhub-leaderboard
heroku buildpacks:add https://github.com/timanovsky/subdir-heroku-buildpack --app vulhub-leaderboard
heroku buildpacks:add https://github.com/Unlimited/heroku-buildpack-pnpm --app vulhub-leaderboard

# Confirm the buildpacks
echo ""
echo "✅ Current buildpacks:"
heroku buildpacks --app vulhub-leaderboard

# Push again
echo ""
echo "🚀 Deploying with pnpm support..."
git push heroku main

echo ""
echo "✅ Deployment attempted. Check the logs above."


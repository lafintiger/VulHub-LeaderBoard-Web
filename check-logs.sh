#!/bin/bash

cd VulHub-LeaderBoard-Web

echo "📋 Fetching Heroku logs to diagnose the 500 error..."
echo ""

# Get the last 500 lines of logs
heroku logs --tail --num 500 --app vulhub-leaderboard



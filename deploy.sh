#!/bin/bash

# Navigate into the cloned repository
cd VulHub-LeaderBoard-Web

# Step 1: Connect to your Heroku app (if not already connected)
echo "🔗 Connecting to Heroku app..."
heroku git:remote -a vulhub-leaderboard

# Step 2: Backup the original package.json
echo "💾 Backing up package.json..."
cp apps/web/package.json apps/web/package.json.backup

# Step 3: Update package.json with packageManager and engines
echo "✏️  Updating apps/web/package.json..."
python3 << 'EOF'
import json

with open('apps/web/package.json', 'r') as f:
    package_data = json.load(f)

package_data['packageManager'] = 'pnpm@8.10.0'

if 'engines' not in package_data:
    package_data['engines'] = {}
package_data['engines']['node'] = '>=18.0.0'

with open('apps/web/package.json', 'w') as f:
    json.dump(package_data, f, indent=2)
    f.write('\n')

print("✅ Updated apps/web/package.json")
EOF

# Step 4: Show what changed
echo ""
echo "📝 Changes made:"
git diff apps/web/package.json

# Step 5: Commit changes
echo ""
echo "💾 Committing changes..."
git add apps/web/package.json
git commit -m "Configure pnpm for Heroku deployment"

# Step 6: Push to Heroku
echo ""
echo "🚀 Deploying to Heroku..."
git push heroku main

echo ""
echo "✅ Done! Watch the deployment above."


#!/bin/bash

cd VulHub-LeaderBoard-Web

echo "🔧 Fixing workspace dependencies..."

# Switch back to standard Node.js buildpack
heroku buildpacks:clear --app vulhub-leaderboard
heroku buildpacks:add https://github.com/timanovsky/subdir-heroku-buildpack --app vulhub-leaderboard
heroku buildpacks:add heroku/nodejs --app vulhub-leaderboard

# Backup package.json
cp apps/web/package.json apps/web/package.json.backup

# Remove workspace:* dependencies using Python
python3 << 'EOF'
import json
import re

with open('apps/web/package.json', 'r') as f:
    package_data = json.load(f)

# Function to replace workspace:* with file: paths
def fix_workspace_deps(deps):
    if not deps:
        return deps
    fixed = {}
    for key, value in deps.items():
        if isinstance(value, str) and value.startswith('workspace:'):
            # Convert workspace:* to file:../../packages/package-name
            package_name = key.split('/')[-1] if '/' in key else key
            fixed[key] = f"file:../../packages/{package_name}"
            print(f"  ✏️  Changed {key}: {value} -> {fixed[key]}")
        else:
            fixed[key] = value
    return fixed

# Fix dependencies
if 'dependencies' in package_data:
    package_data['dependencies'] = fix_workspace_deps(package_data['dependencies'])

if 'devDependencies' in package_data:
    package_data['devDependencies'] = fix_workspace_deps(package_data['devDependencies'])

# Add packageManager
package_data['packageManager'] = 'npm@11.6.2'

# Add engines
if 'engines' not in package_data:
    package_data['engines'] = {}
package_data['engines']['node'] = '18.x'

# Write back
with open('apps/web/package.json', 'w') as f:
    json.dump(package_data, f, indent=2)
    f.write('\n')

print("\n✅ Fixed workspace dependencies in apps/web/package.json")
EOF

# Show changes
echo ""
echo "📝 Changes made:"
git diff apps/web/package.json

# Commit
echo ""
git add apps/web/package.json
git commit -m "Remove workspace dependencies for Heroku compatibility"

# Push
echo ""
echo "🚀 Deploying..."
git push heroku main

echo ""
echo "✅ Done!"


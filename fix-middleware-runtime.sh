#!/bin/bash

cd VulHub-LeaderBoard-Web

echo "🔧 Forcing middleware to use Node.js runtime..."

# Add explicit runtime config to middleware
python3 << 'EOF'
import os

middleware_path = 'apps/web/src/middleware.ts'

if os.path.exists(middleware_path):
    with open(middleware_path, 'r') as f:
        content = f.read()
    
    # Check if runtime config already exists
    if "export const config" not in content or "runtime: 'nodejs'" not in content:
        # Add Node.js runtime config at the end of the file
        runtime_config = '''

// Force middleware to run in Node.js runtime (not Edge)
export const config = {
  runtime: 'nodejs',
  unstable_allowDynamic: [
    '/node_modules/**',
  ],
}
'''
        # Remove any existing edge config first
        content = content.replace("export const config = {\n  runtime: 'edge',\n}", "")
        content = content.replace('export const config = {\n  runtime: "edge",\n}', "")
        
        # Add the new config
        content = content.rstrip() + runtime_config
    
    with open(middleware_path, 'w') as f:
        f.write(content)
    
    print("✅ Configured middleware to use Node.js runtime")
else:
    print("⚠️  middleware.ts not found")
EOF

# Show changes
echo ""
echo "📝 Changes to middleware:"
git diff apps/web/src/middleware.ts

# Commit
echo ""
git add apps/web/src/middleware.ts
git commit -m "Force middleware to use Node.js runtime instead of Edge"

# Push
echo ""
echo "🚀 Deploying to Heroku..."
git push heroku main

echo ""
echo "✅ Done! Check your app now."



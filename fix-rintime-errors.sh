#!/bin/bash

cd VulHub-LeaderBoard-Web

echo "🔧 Fixing Edge runtime and middleware issues..."

# Fix 1: Update middleware to use Node.js runtime instead of Edge
python3 << 'EOF'
import os

middleware_path = 'apps/web/src/middleware.ts'

if os.path.exists(middleware_path):
    with open(middleware_path, 'r') as f:
        content = f.read()
    
    # Remove edge runtime export if it exists
    if "export const config" in content:
        # Comment out or remove edge runtime config
        content = content.replace(
            "export const config = {\n  runtime: 'edge',\n}",
            "// export const config = {\n//   runtime: 'edge',\n// }"
        )
        content = content.replace(
            "export const config = {\n  runtime: \"edge\",\n}",
            "// export const config = {\n//   runtime: \"edge\",\n// }"
        )
    
    with open(middleware_path, 'w') as f:
        f.write(content)
    
    print("✅ Updated middleware.ts to use Node.js runtime")
else:
    print("⚠️  middleware.ts not found")
EOF

# Fix 2: Move viewport from metadata to separate export in layout
python3 << 'EOF'
import os
import re

layout_path = 'apps/web/src/app/layout.tsx'

if os.path.exists(layout_path):
    with open(layout_path, 'r') as f:
        content = f.read()
    
    # Check if viewport is in metadata
    if 'viewport' in content and 'export const metadata' in content:
        # Add viewport export at the top after imports
        viewport_export = '''
export const viewport = {
  width: 'device-width',
  initialScale: 1,
  maximumScale: 1,
}

'''
        
        # Find the last import statement
        import_pattern = r'(import .+\n)(?!import)'
        match = list(re.finditer(import_pattern, content))
        if match:
            insert_pos = match[-1].end()
            content = content[:insert_pos] + viewport_export + content[insert_pos:]
        
        # Remove viewport from metadata object
        content = re.sub(r',?\s*viewport:\s*\{[^}]+\},?', '', content)
        
        with open(layout_path, 'w') as f:
            f.write(content)
        
        print("✅ Moved viewport from metadata to separate export in layout.tsx")
    else:
        print("ℹ️  No viewport config found in metadata")
else:
    print("⚠️  layout.tsx not found")
EOF

# Show changes
echo ""
echo "📝 Changes made:"
git diff apps/web/src/middleware.ts apps/web/src/app/layout.tsx

# Commit
echo ""
git add apps/web/src/middleware.ts apps/web/src/app/layout.tsx
git commit -m "Fix Edge runtime error and move viewport to separate export"

# Push
echo ""
echo "🚀 Deploying fixes to Heroku..."
git push heroku main

echo ""
echo "✅ Done! The app should work now."


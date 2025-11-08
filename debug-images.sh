#!/bin/bash

echo "🔍 Debugging image issue..."
echo "================================"

# Check current directory structure
echo "📁 Current directory structure:"
tree /workspaces/bagvanth-family 2>/dev/null || ls -la /workspaces/bagvanth-family

echo ""
echo "📁 Images directory contents:"
ls -la /workspaces/bagvanth-family/images/ 2>/dev/null || echo "Images directory doesn't exist or is empty"

echo ""
echo "🔍 Searching for WhatsApp images in entire workspace:"
find /workspaces -name "*WhatsApp*" -type f 2>/dev/null | head -20

echo ""
echo "🔍 Searching for any image files (.jpg, .jpeg, .png):"
find /workspaces -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" 2>/dev/null | head -20

echo ""
echo "📋 Please provide the exact image paths if found above, or we'll create test images."

# Create test images using ImageMagick or simple colored rectangles
echo ""
echo "🎨 Creating test images..."

# Install ImageMagick if available
if command -v convert >/dev/null 2>&1; then
    echo "Using ImageMagick to create test images..."
    convert -size 350x300 xc:'#667eea' -pointsize 40 -fill white -gravity center -annotate +0+0 'Bagvanth' /workspaces/bagvanth-family/images/bagvanth.jpeg
    convert -size 350x300 xc:'#764ba2' -pointsize 40 -fill white -gravity center -annotate +0+0 'Toxic' /workspaces/bagvanth-family/images/toxic.jpeg
else
    echo "Creating simple test images with wget..."
    mkdir -p /workspaces/bagvanth-family/images
    
    # Download colored placeholder images
    wget -O /workspaces/bagvanth-family/images/bagvanth.jpeg "https://dummyimage.com/350x300/667eea/ffffff&text=Bagvanth" 2>/dev/null || echo "Wget failed, trying curl..."
    
    if [ ! -f "/workspaces/bagvanth-family/images/bagvanth.jpeg" ]; then
        curl -o /workspaces/bagvanth-family/images/bagvanth.jpeg "https://dummyimage.com/350x300/667eea/ffffff&text=Bagvanth" 2>/dev/null || echo "Curl also failed"
    fi
    
    wget -O /workspaces/bagvanth-family/images/toxic.jpeg "https://dummyimage.com/350x300/764ba2/ffffff&text=Toxic" 2>/dev/null || echo "Wget failed, trying curl..."
    
    if [ ! -f "/workspaces/bagvanth-family/images/toxic.jpeg" ]; then
        curl -o /workspaces/bagvanth-family/images/toxic.jpeg "https://dummyimage.com/350x300/764ba2/ffffff&text=Toxic" 2>/dev/null || echo "Curl also failed"
    fi
fi

echo ""
echo "✅ Final check - Images created:"
ls -la /workspaces/bagvanth-family/images/

echo ""
echo "🔧 If you have the actual WhatsApp images, please copy them manually:"
echo "cp 'path/to/WhatsApp Image 2025-11-08 at 21.30.25.jpeg' /workspaces/bagvanth-family/images/bagvanth.jpeg"
echo "cp 'path/to/WhatsApp Image 2025-11-06 at 23.15.41.jpeg' /workspaces/bagvanth-family/images/toxic.jpeg"

# Restart the container to pick up new images
echo ""
echo "🔄 Restarting container with new images..."
cd /workspaces/bagvanth-family
docker-compose down 2>/dev/null
docker-compose up -d

sleep 2
echo ""
echo "🌐 Opening website..."
"$BROWSER" http://localhost:8080

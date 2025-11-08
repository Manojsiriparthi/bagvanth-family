#!/bin/bash

echo "📸 Copying your actual images..."

# Create images directory
mkdir -p /workspaces/bagvanth-family/images

# Copy Bagvanth image
echo "Copying Bagvanth image..."
cp "/Users/manojsiriparthi/Downloads/WhatsApp Image 2025-11-08 at 21.30.25.jpeg" /workspaces/bagvanth-family/images/bagvanth.jpeg

# Copy Toxic image  
echo "Copying Toxic image..."
cp "/Users/manojsiriparthi/Downloads/WhatsApp Image 2025-11-06 at 23.15.41.jpeg" /workspaces/bagvanth-family/images/toxic.jpeg

# Verify images were copied
echo ""
echo "✅ Checking copied images:"
ls -la /workspaces/bagvanth-family/images/

# Set proper permissions
chmod 644 /workspaces/bagvanth-family/images/*.jpeg

# Restart Docker container to pick up new images
echo ""
echo "🔄 Restarting container with your actual images..."
cd /workspaces/bagvanth-family
docker-compose down
docker-compose up -d

# Wait for container to start
sleep 3

echo ""
echo "🌐 Opening website with your actual photos..."
"$BROWSER" http://localhost:8080

echo ""
echo "✅ Done! Your website now shows:"
echo "   - Bagvanth: WhatsApp Image 2025-11-08 at 21.30.25.jpeg"
echo "   - Toxic: WhatsApp Image 2025-11-06 at 23.15.41.jpeg"

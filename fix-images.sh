#!/bin/bash

echo "🔧 Fixing image loading issues..."
echo "================================="

# Check current working directory
echo "📍 Current directory: $(pwd)"

# Check if images exist
echo ""
echo "📁 Checking images directory:"
ls -la /workspaces/bagvanth-family/images/

# Check file permissions
echo ""
echo "🔐 Checking file permissions:"
if [ -f "/workspaces/bagvanth-family/images/bagvanth.jpeg" ]; then
    echo "✅ bagvanth.jpeg exists"
    ls -la /workspaces/bagvanth-family/images/bagvanth.jpeg
else
    echo "❌ bagvanth.jpeg not found"
fi

if [ -f "/workspaces/bagvanth-family/images/toxic.jpeg" ]; then
    echo "✅ toxic.jpeg exists"
    ls -la /workspaces/bagvanth-family/images/toxic.jpeg
else
    echo "❌ toxic.jpeg not found"
fi

# Test if images are valid
echo ""
echo "🖼️ Testing image validity:"
file /workspaces/bagvanth-family/images/*.jpeg 2>/dev/null || echo "No JPEG files found or file command not available"

# Fix permissions
echo ""
echo "🔧 Setting proper permissions:"
chmod 755 /workspaces/bagvanth-family/images/
chmod 644 /workspaces/bagvanth-family/images/*.jpeg 2>/dev/null

# Check Docker container status
echo ""
echo "🐳 Checking Docker container:"
docker ps | grep bagvanth || echo "Container not running"

# Restart container with proper volume mounting
echo ""
echo "🔄 Restarting Docker container with fresh image mounting..."
cd /workspaces/bagvanth-family
docker-compose down

# Update docker-compose to ensure proper volume mounting
cat > docker-compose.yml << 'EOF'
version: '3.8'
services:
  bagvanth-family:
    build: .
    container_name: bagvanth-family-web
    ports:
      - "8080:80"
    restart: unless-stopped
    volumes:
      - ./index.html:/usr/share/nginx/html/index.html:ro
      - ./images:/usr/share/nginx/html/images:ro
EOF

# Build and start
docker-compose build --no-cache
docker-compose up -d

# Wait for container to start
sleep 5

# Test image accessibility via HTTP
echo ""
echo "🌐 Testing image URLs:"
curl -I http://localhost:8080/images/bagvanth.jpeg 2>/dev/null | head -1 || echo "Could not access bagvanth.jpeg via HTTP"
curl -I http://localhost:8080/images/toxic.jpeg 2>/dev/null | head -1 || echo "Could not access toxic.jpeg via HTTP"

# Show container logs
echo ""
echo "📋 Container logs:"
docker logs bagvanth-family-web --tail 10

echo ""
echo "✅ Fix complete! Opening website..."
"$BROWSER" http://localhost:8080

echo ""
echo "🔍 If images still don't load, check:"
echo "1. Browser developer tools (F12) for network errors"
echo "2. Try accessing images directly: http://localhost:8080/images/bagvanth.jpeg"
echo "3. Check container logs: docker logs bagvanth-family-web"

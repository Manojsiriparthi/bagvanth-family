#!/bin/bash

echo "Setting up Bagvanth Family website..."

# Stop and remove existing containers
echo "Stopping and removing existing containers..."
docker ps -a | grep bagvanth | awk '{print $1}' | xargs -r docker stop
docker ps -a | grep bagvanth | awk '{print $1}' | xargs -r docker rm

# Remove existing images
echo "Removing existing Docker images..."
docker images | grep bagvanth | awk '{print $3}' | xargs -r docker rmi -f

# Clean up Docker system
echo "Cleaning up Docker system..."
docker system prune -f

# Create images directory
mkdir -p /workspaces/bagvanth-family/images

# Search for the images
echo "Looking for WhatsApp images..."
find /workspaces -name "*WhatsApp*" -type f 2>/dev/null | while read file; do
    echo "Found: $file"
    if [[ "$file" == *"2025-11-08"* ]]; then
        cp "$file" /workspaces/bagvanth-family/images/bagvanth.jpeg
        echo "✓ Copied Bagvanth image"
    elif [[ "$file" == *"2025-11-06"* ]]; then
        cp "$file" /workspaces/bagvanth-family/images/toxic.jpeg
        echo "✓ Copied Toxic image"
    fi
done

# Alternative search in common directories
if [ ! -f "/workspaces/bagvanth-family/images/bagvanth.jpeg" ] || [ ! -f "/workspaces/bagvanth-family/images/toxic.jpeg" ]; then
    echo "Searching in additional locations..."
    
    # Search in Downloads
    find ~/Downloads -name "*WhatsApp*" -type f 2>/dev/null | while read file; do
        echo "Found in Downloads: $file"
        if [[ "$file" == *"2025-11-08"* ]]; then
            cp "$file" /workspaces/bagvanth-family/images/bagvanth.jpeg
            echo "✓ Copied Bagvanth image from Downloads"
        elif [[ "$file" == *"2025-11-06"* ]]; then
            cp "$file" /workspaces/bagvanth-family/images/toxic.jpeg
            echo "✓ Copied Toxic image from Downloads"
        fi
    done
    
    # Search in root directory
    find / -name "*WhatsApp*" -type f -path "*/bagvanth*" 2>/dev/null | head -10 | while read file; do
        echo "Found in system: $file"
        if [[ "$file" == *"2025-11-08"* ]]; then
            cp "$file" /workspaces/bagvanth-family/images/bagvanth.jpeg
            echo "✓ Copied Bagvanth image from system"
        elif [[ "$file" == *"2025-11-06"* ]]; then
            cp "$file" /workspaces/bagvanth-family/images/toxic.jpeg
            echo "✓ Copied Toxic image from system"
        fi
    done
fi

# Create Dockerfile
echo "Creating Dockerfile..."
cat > /workspaces/bagvanth-family/Dockerfile << 'EOF'
FROM nginx:alpine

# Copy website files to nginx html directory
COPY index.html /usr/share/nginx/html/
COPY images/ /usr/share/nginx/html/images/

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
EOF

# Create docker-compose.yml
echo "Creating docker-compose.yml..."
cat > /workspaces/bagvanth-family/docker-compose.yml << 'EOF'
version: '3.8'
services:
  bagvanth-family:
    build: .
    container_name: bagvanth-family-web
    ports:
      - "8080:80"
    restart: unless-stopped
    volumes:
      - ./index.html:/usr/share/nginx/html/index.html
      - ./images:/usr/share/nginx/html/images
EOF

# Check results
echo "Images in directory:"
ls -la /workspaces/bagvanth-family/images/

# Create placeholder images if originals not found
if [ ! -f "/workspaces/bagvanth-family/images/bagvanth.jpeg" ]; then
    echo "Creating placeholder for Bagvanth image..."
    wget -O /workspaces/bagvanth-family/images/bagvanth.jpeg "https://via.placeholder.com/350x300/667eea/ffffff?text=Bagvanth" 2>/dev/null || echo "Could not create placeholder"
fi

if [ ! -f "/workspaces/bagvanth-family/images/toxic.jpeg" ]; then
    echo "Creating placeholder for Toxic image..."
    wget -O /workspaces/bagvanth-family/images/toxic.jpeg "https://via.placeholder.com/350x300/764ba2/ffffff?text=Toxic" 2>/dev/null || echo "Could not create placeholder"
fi

# Build and run new Docker container
echo "Building new Docker image..."
cd /workspaces/bagvanth-family
docker-compose build

echo "Starting new container..."
docker-compose up -d

# Wait for container to start
sleep 3

# Check if container is running
if docker ps | grep -q bagvanth-family-web; then
    echo "✓ Container is running successfully!"
    echo "Website available at: http://localhost:8080"
    
    # Open the website in browser
    echo "Opening website in browser..."
    "$BROWSER" http://localhost:8080
else
    echo "❌ Container failed to start. Checking logs..."
    docker-compose logs
    
    # Fallback: open local file
    echo "Opening local file as fallback..."
    "$BROWSER" file:///workspaces/bagvanth-family/index.html
fi

echo ""
echo "Setup complete!"
echo "===================="
echo "Website URL: http://localhost:8080"
echo "Local file: file:///workspaces/bagvanth-family/index.html"
echo ""
echo "To manage the container:"
echo "  Stop:    docker-compose down"
echo "  Start:   docker-compose up -d"
echo "  Rebuild: docker-compose build"
echo "  Logs:    docker-compose logs -f"

#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
IMAGE_NAME="bagvanth-family"
CONTAINER_NAME="bagvanth-family-app"
HOST_PORT="3000"
CONTAINER_PORT="80"

echo -e "${BLUE}=== Bagvanth Family Docker Setup Script ===${NC}"

# Function to check if Docker is installed
check_docker() {
    if command -v docker &> /dev/null; then
        echo -e "${GREEN}✓ Docker is already installed${NC}"
        docker --version
        return 0
    else
        echo -e "${YELLOW}⚠ Docker not found. Installing Docker...${NC}"
        return 1
    fi
}

# Function to install Docker (for Ubuntu/Debian)
install_docker() {
    echo -e "${BLUE}Installing Docker...${NC}"
    
    # Update package index
    sudo apt-get update
    
    # Install required packages
    sudo apt-get install -y \
        ca-certificates \
        curl \
        gnupg \
        lsb-release
    
    # Add Docker's GPG key
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    
    # Add Docker repository
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # Update package index again
    sudo apt-get update
    
    # Install Docker Engine
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    
    # Add current user to docker group
    sudo usermod -aG docker $USER
    
    echo -e "${GREEN}✓ Docker installed successfully${NC}"
    echo -e "${YELLOW}Note: You may need to log out and log back in for group changes to take effect${NC}"
}

# Function to build Docker image
build_image() {
    echo -e "${BLUE}Building Docker image: ${IMAGE_NAME}${NC}"
    
    if docker build -t $IMAGE_NAME .; then
        echo -e "${GREEN}✓ Image built successfully${NC}"
        return 0
    else
        echo -e "${RED}✗ Failed to build image${NC}"
        return 1
    fi
}

# Function to stop and remove existing container
cleanup_container() {
    if docker ps -q -f name=$CONTAINER_NAME | grep -q .; then
        echo -e "${YELLOW}Stopping existing container: ${CONTAINER_NAME}${NC}"
        docker stop $CONTAINER_NAME
    fi
    
    if docker ps -aq -f name=$CONTAINER_NAME | grep -q .; then
        echo -e "${YELLOW}Removing existing container: ${CONTAINER_NAME}${NC}"
        docker rm $CONTAINER_NAME
    fi
}

# Function to create and run container
run_container() {
    echo -e "${BLUE}Creating and running container: ${CONTAINER_NAME}${NC}"
    
    cleanup_container
    
    if docker run -d \
        --name $CONTAINER_NAME \
        -p $HOST_PORT:$CONTAINER_PORT \
        --restart unless-stopped \
        $IMAGE_NAME; then
        echo -e "${GREEN}✓ Container created and started successfully${NC}"
        echo -e "${GREEN}✓ Application available at: http://localhost:${HOST_PORT}${NC}"
        return 0
    else
        echo -e "${RED}✗ Failed to create/run container${NC}"
        return 1
    fi
}

# Function to check container status
check_container() {
    echo -e "${BLUE}Checking container status...${NC}"
    echo ""
    
    # Show all containers
    docker ps -a --filter name=$CONTAINER_NAME
    echo ""
    
    # Check if container is running
    if docker ps -q -f name=$CONTAINER_NAME | grep -q .; then
        echo -e "${GREEN}✓ Container is running successfully${NC}"
        
        # Show container logs (last 10 lines)
        echo -e "${BLUE}Recent container logs:${NC}"
        docker logs --tail 10 $CONTAINER_NAME
    else
        echo -e "${RED}✗ Container is not running${NC}"
        
        # Show logs if container exists but not running
        if docker ps -aq -f name=$CONTAINER_NAME | grep -q .; then
            echo -e "${YELLOW}Container logs:${NC}"
            docker logs $CONTAINER_NAME
        fi
    fi
}

# Main execution
main() {
    # Check if Docker is installed, install if not
    if ! check_docker; then
        install_docker
        
        # Start Docker service
        sudo systemctl start docker
        sudo systemctl enable docker
    fi
    
    # Build the image
    if build_image; then
        # Run the container
        if run_container; then
            # Check container status
            sleep 2
            check_container
            
            echo ""
            echo -e "${GREEN}=== Setup Complete! ===${NC}"
            echo -e "${GREEN}Access your application at: http://localhost:${HOST_PORT}${NC}"
            echo ""
            echo -e "${BLUE}Useful commands:${NC}"
            echo -e "  View logs: ${YELLOW}docker logs ${CONTAINER_NAME}${NC}"
            echo -e "  Stop container: ${YELLOW}docker stop ${CONTAINER_NAME}${NC}"
            echo -e "  Start container: ${YELLOW}docker start ${CONTAINER_NAME}${NC}"
            echo -e "  Remove container: ${YELLOW}docker rm ${CONTAINER_NAME}${NC}"
        fi
    fi
}

# Run main function
main

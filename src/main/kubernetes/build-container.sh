#!/bin/bash

# Todo Demo App Container Build Script
# This script builds and pushes the container image to the workshop registry

# These placeholder values MUST be changed before running
PARTICIPANT="CHANGE_ME_TO_YOUR_NAME"

# Registry settings
REGISTRY="registry.hacknight043.coffeesprout.dev"
IMAGE_NAME="todo-demo-app"
IMAGE_TAG="latest"

# Check if variables have been changed from placeholder values
if [[ "$PARTICIPANT" == "CHANGE_ME_TO_YOUR_NAME" ]]; then
  echo "ERROR: You must edit this script to set your participant name!"
  echo "Open build-container.sh in a text editor and change the PARTICIPANT variable."
  exit 1
fi

# Determine container build tool (podman or docker)
if command -v podman &> /dev/null; then
  CONTAINER_TOOL="podman"
elif command -v docker &> /dev/null; then
  CONTAINER_TOOL="docker"
else
  echo "ERROR: Neither podman nor docker found. Please install one of these container tools."
  exit 1
fi

echo "Using $CONTAINER_TOOL for container operations"

# Check if we're in the project root directory
if [[ ! -f "pom.xml" ]]; then
  echo "ERROR: This script must be run from the project root directory (where pom.xml is located)"
  echo "Current directory: $(pwd)"
  echo "Please change to the project root directory and try again."
  exit 1
fi

# Login to registry
echo "Logging in to registry $REGISTRY..."
read -p "Registry username: " REG_USER
read -s -p "Registry password: " REG_PASS
echo ""

$CONTAINER_TOOL login --username "$REG_USER" --password "$REG_PASS" $REGISTRY
if [ $? -ne 0 ]; then
  echo "ERROR: Failed to log in to registry. Please check your credentials and try again."
  exit 1
fi

# Build the container image
echo "Building container image..."
echo "This may take a few minutes..."

# Determine platform - ARM for Apple Silicon, AMD64 for most other systems
if [[ "$(uname -m)" == "arm64" ]]; then
  PLATFORM="linux/amd64"
  echo "Detected ARM architecture (Apple Silicon). Building for $PLATFORM..."
  
  if [[ "$CONTAINER_TOOL" == "docker" ]]; then
    # Docker with buildx for multi-architecture builds
    docker buildx build --platform=$PLATFORM \
      -f src/main/docker/Dockerfile.jvm \
      -t $REGISTRY/$PARTICIPANT/$IMAGE_NAME:$IMAGE_TAG \
      .
  else
    # Podman with platform flag
    podman build --platform=$PLATFORM \
      -f src/main/docker/Dockerfile.jvm \
      -t $REGISTRY/$PARTICIPANT/$IMAGE_NAME:$IMAGE_TAG \
      .
  fi
else
  # Regular build for AMD64 architecture
  $CONTAINER_TOOL build \
    -f src/main/docker/Dockerfile.jvm \
    -t $REGISTRY/$PARTICIPANT/$IMAGE_NAME:$IMAGE_TAG \
    .
fi

if [ $? -ne 0 ]; then
  echo "ERROR: Container build failed!"
  exit 1
fi

echo "Container image built successfully!"

# Push the image to the registry
echo "Pushing image to $REGISTRY/$PARTICIPANT/$IMAGE_NAME:$IMAGE_TAG..."
$CONTAINER_TOOL push $REGISTRY/$PARTICIPANT/$IMAGE_NAME:$IMAGE_TAG

if [ $? -ne 0 ]; then
  echo "ERROR: Failed to push image to registry!"
  exit 1
fi

echo "✅ Image successfully pushed to $REGISTRY/$PARTICIPANT/$IMAGE_NAME:$IMAGE_TAG"
echo ""
echo "Next steps:"
echo "1. Deploy your application with:"
echo "   cd src/main/kubernetes"
echo "   ./deploy.sh"
echo ""
echo "Remember to update the PARTICIPANT and NAMESPACE variables in deploy.sh!"
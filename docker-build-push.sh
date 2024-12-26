#!/bin/bash

show_usage() {
    echo "Usage: ./docker-build.sh <version-tag> [dockerfile-path]"
    echo "Example: ./docker-build.sh 1.0.0"
    echo "Example with custom Dockerfile: ./docker-build.sh 1.0.0 docker/Dockerfile.standalone"
}

# Check if version tag is provided
if [ -z "$1" ]
then
    echo "Error: Please provide a version tag"
    show_usage
    exit 1
fi

# Variables
VERSION=$1
DOCKERFILE=${2:-"Dockerfile"}  # Use second parameter if provided, otherwise default to "Dockerfile"
USERNAME="dockerdemo786"  # Replace with your Docker Hub username
IMAGE_NAME="greetings-frontend"
FULL_IMAGE_NAME="$USERNAME/$IMAGE_NAME"

# Check if specified Dockerfile exists
if [ ! -f "$DOCKERFILE" ]; then
    echo "Error: Dockerfile not found at path: $DOCKERFILE"
    exit 1
fi

echo "🚀 Building and pushing $FULL_IMAGE_NAME:$VERSION"

# Build the image with specified Dockerfile
echo "📦 Building Docker image..."
docker build --platform linux/amd64 \
    --build-arg "VITE_IS_STATIC=true" \
    -f "$DOCKERFILE" \
    -t $IMAGE_NAME \
    --no-cache .

# Tag the image with version and latest
echo "🏷️ Tagging images..."
docker tag $IMAGE_NAME:latest $FULL_IMAGE_NAME:$VERSION
docker tag $IMAGE_NAME:latest $FULL_IMAGE_NAME:latest

# Push the images
echo "⬆️ Pushing images to Docker Hub..."
docker push $FULL_IMAGE_NAME:$VERSION
docker push $FULL_IMAGE_NAME:latest

echo "✅ Successfully built and pushed $FULL_IMAGE_NAME:$VERSION and $FULL_IMAGE_NAME:latest"

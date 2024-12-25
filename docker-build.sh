#!/bin/bash

# Check if version tag is provided
if [ -z "$1" ]
then
    echo "Error: Please provide a version tag"
    echo "Usage: ./docker-build.sh <version-tag>"
    echo "Example: ./docker-build.sh 1.0.0"
    exit 1
fi

# Variables
VERSION=$1
USERNAME="dockerdemo786"  # Replace with your Docker Hub username
IMAGE_NAME="greetings-frontend"
FULL_IMAGE_NAME="$USERNAME/$IMAGE_NAME"

echo "🚀 Building and pushing $FULL_IMAGE_NAME:$VERSION"

# Build the image
echo "📦 Building Docker image..."
docker build --platform linux/amd64 --build-arg "VITE_IS_STATIC=false" -t $IMAGE_NAME --no-cache .

# Tag the image with version and latest
echo "🏷️ Tagging images..."
docker tag $IMAGE_NAME:latest $FULL_IMAGE_NAME:$VERSION
docker tag $IMAGE_NAME:latest $FULL_IMAGE_NAME:latest

# Push the images
echo "⬆️ Pushing images to Docker Hub..."
docker push $FULL_IMAGE_NAME:$VERSION
docker push $FULL_IMAGE_NAME:latest

echo "✅ Successfully built and pushed $FULL_IMAGE_NAME:$VERSION and $FULL_IMAGE_NAME:latest"

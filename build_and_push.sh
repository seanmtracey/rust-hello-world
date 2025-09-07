#!/bin/bash

# Multi-architecture build and push script for Podman
# Usage: ./build-and-push.sh <image-name> <registry-user>
# Example: ./build-and-push.sh hello-world-rust seanmtracey

set -e  # Exit on any error

# Check arguments
if [ $# -ne 2 ]; then
    echo "Usage: $0 <image-name> <registry-user>"
    echo "Example: $0 hello-world-rust seanmtracey"
    exit 1
fi

IMAGE_NAME=$1
REGISTRY_USER=$2
REGISTRY_PATH="docker.io/${REGISTRY_USER}/${IMAGE_NAME}"

echo "🧹 Cleaning up existing images..."
# Clean up existing images (ignore errors if they don't exist)
podman rmi localhost/${IMAGE_NAME}-amd64 2>/dev/null || true
podman rmi localhost/${IMAGE_NAME}-arm64 2>/dev/null || true
podman rmi localhost/${IMAGE_NAME} 2>/dev/null || true
podman manifest rm ${IMAGE_NAME} 2>/dev/null || true

echo "🏗️  Building AMD64 image..."
podman build --platform linux/amd64 -t ${IMAGE_NAME}-amd64 .

echo "🏗️  Building ARM64 image..."
podman build --platform linux/arm64 -t ${IMAGE_NAME}-arm64 .

echo "📋 Checking built images..."
podman images | grep ${IMAGE_NAME}

echo "📦 Creating manifest..."
podman manifest create ${IMAGE_NAME}

echo "➕ Adding AMD64 image to manifest..."
podman manifest add ${IMAGE_NAME} ${IMAGE_NAME}-amd64

echo "➕ Adding ARM64 image to manifest..."
podman manifest add ${IMAGE_NAME} ${IMAGE_NAME}-arm64

echo "🔍 Inspecting manifest..."
podman manifest inspect ${IMAGE_NAME}

echo "🚀 Pushing to ${REGISTRY_PATH}..."
podman manifest push ${IMAGE_NAME} ${REGISTRY_PATH}

echo "✅ Successfully pushed ${REGISTRY_PATH} with multi-architecture support!"
echo "Users can now pull with: docker pull ${REGISTRY_PATH}"
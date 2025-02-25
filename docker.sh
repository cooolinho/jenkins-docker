#!/bin/bash
set -euo pipefail

DOCKER_USER="cooolinho"
DOCKER_REPOSITORY="jenkins-docker"
DOCKER_REPOSITORY_URL="https://hub.docker.com/repository/docker/$DOCKER_USER/$DOCKER_REPOSITORY/"

echo ">>> DOCKER IMAGE CREATOR <<<"
read -p "How to TAG your image? ($DOCKER_REPOSITORY:<TAG>) [latest] " TAG
TAG=${TAG:-latest}

# Build image with error handling
echo "Building Docker image..."
if ! docker build -t "$DOCKER_REPOSITORY" .; then
    echo "Error: Docker build failed!" >&2
    exit 1
fi

echo "Tagging Docker image..."
if ! docker tag "$DOCKER_REPOSITORY" "$DOCKER_USER/$DOCKER_REPOSITORY:$TAG"; then
    echo "Error: Docker tag failed!" >&2
    exit 1
fi

echo ">>> Image Created: $DOCKER_USER/$DOCKER_REPOSITORY:$TAG"
read -p "Upload image to Docker Hub (y/n)? " UPLOAD
if [[ "$UPLOAD" == "y" ]]; then
    echo "Uploading Docker image..."
    if ! docker push "$DOCKER_USER/$DOCKER_REPOSITORY:$TAG"; then
        echo "Error: Docker push failed!" >&2
        exit 1
    fi
    echo ">>> Image Uploaded: $DOCKER_USER/$DOCKER_REPOSITORY:$TAG"
    echo ">>> $DOCKER_REPOSITORY_URL"
fi

read -p "Run Image and execute it via bash (y/n)? " RUN
if [[ "$RUN" == "y" ]]; then
    echo "Running Docker container..."
    if ! docker run --rm --name "$DOCKER_REPOSITORY" -i -t "$DOCKER_USER/$DOCKER_REPOSITORY:$TAG" /bin/bash; then
        echo "Error: Docker run failed!" >&2
        exit 1
    fi
fi

#!/bin/bash
echo "Preparing Task Manager application..."

# Create Docker network
docker network create tasknet || echo "Network already exists"

# Create database volume
docker volume create pgdata

# Build Flask backend image
echo "Building Flask application image..."
docker-compose build

echo "Application resources prepared successfully!"



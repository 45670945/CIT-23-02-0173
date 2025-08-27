#!/bin/bash

echo "Removing all Task Manager application resources..."

# Stop and remove containers
docker stop task-manager-app postgres-db 2>/dev/null
docker rm task-manager-app postgres-db 2>/dev/null

# Remove custom image
docker rmi task-manager-app:latest 2>/dev/null

# Remove network
docker network rm task-manager-network 2>/dev/null

# Remove volume (this will delete all data!)
echo "⚠️  WARNING: This will permanently delete all task data!"
read -p "Are you sure you want to continue? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    docker volume rm postgres-data 2>/dev/null
    echo "🗑️  All application resources have been removed."
else
    echo "Volume preserved. Data is still available."
fi

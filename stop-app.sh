#!/bin/bash

echo "Stopping Task Manager application..."

# Stop containers but preserve data
docker stop task-manager-app postgres-db 2>/dev/null || echo "Containers already stopped"

echo "✅ Application stopped successfully!"
echo "💾 All data has been preserved and will be available when you restart."

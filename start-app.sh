#!/bin/bash

echo "Starting Task Manager application..."

# Start PostgreSQL database container
echo "Starting PostgreSQL database..."
docker run -d \
    --name postgres-db \
    --network task-manager-network \
    --restart unless-stopped \
    -e POSTGRES_DB=taskdb \
    -e POSTGRES_USER=postgres \
    -e POSTGRES_PASSWORD=password123 \
    -v postgres-data:/var/lib/postgresql/data \
    -p 5432:5432 \
    postgres:15-alpine

# Wait for database to be ready
echo "Waiting for database to be ready..."
sleep 10

# Start Flask application container
echo "Starting Flask application..."
docker run -d \
    --name task-manager-app \
    --network task-manager-network \
    --restart unless-stopped \
    -e DB_HOST=postgres-db \
    -e DB_PORT=5432 \
    -e DB_NAME=taskdb \
    -e DB_USER=postgres \
    -e DB_PASSWORD=password123 \
    -p 5000:5000 \
    task-manager-app:latest

# Wait for application to start
sleep 5

echo ""
echo "🚀 Task Manager application is now running!"
echo "📱 Access the application at: http://localhost:5000"
echo ""
echo "Container Status:"
docker ps --filter "name=postgres-db" --filter "name=task-manager-app" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

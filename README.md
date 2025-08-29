# Flask Task Manager App:Docker-Based Web Application 
Through a lightweight, containerized Task Manager API, this project aims to demonstrate clear service separation, reproducible environments, and persistent data using Docker. It combines a Flask backend and a PostgreSQL database into distinct containers that are connected by a private Docker network.

## Application Description

- **Create** new task items
- **Mark** taks as complete/incomplete
- **Delete** task items
- **Responsive** modern UI design with user-friendliy
- **Persistent** data storage using PostgreSQL
- Uses **Docker** for containerization, networking, and persistence

The application consists of two main services:

1. **Flask Web Application** - Serves the web interface and handle task cerations,deletion.
2. **PostgreSQL Database** - Stores tasks data persistently

## Deployment Requirements

- **Docker** (28.3.3 ,build 980b856) → should be installed.
- **Docker Compose** (version v2.39.1)
- **Bash** shell (on Windows)
- **Git** (for cloning the repository)

## System Requirements

- **RAM**: Minimum 2GB available
- **Disk Space**: At least 1GB free space
- **Ports**: Port 5000 must be available
- **OS**: Linux, macOS, or Windows with WSL

## Installation Verification

```bash
# Check Docker version
docker --version

# Check Docker Compose version
docker compose version

# Check if Docker daemon is running
docker info

# Check if port 5000 is available
netstat -an | grep :5000
```

## Architecture Overview

### Network and Volume Details

#### Custom Docker Network
- **Name**: `tasknet`
- **Type**: Bridge network
- **Purpose**: Enables secure communication between Flask and PostgreSQL containers
- **Isolation**: Containers can communicate using service names as hostnames

#### Named Volume
- **Name**: `postgres-db`
- **Purpose**: Persistent storage for PostgreSQL database
- **Location**: Managed by Docker (typically `/var/lib/postgresql/data`)
- **Persistence**: Data survives container restarts and updates

### Container Configuration

#### 1. PostgreSQL Database Container
- **Image**: `postgres:13-alpine`
- **Container Name**: `postgres-db`
- **Internal Port**: 5432:5432
- **Environment Variables**:
  - `POSTGRES_USER: postgres`
  - `POSTGRES_PASSWORD: postgres`
  - `POSTGRES_DB: tasks`
- **Volumes**: 
  - `pgdata:/var/lib/postgresql/data`(persistent data)
  - `./database/schema.sql:/docker-entrypoint-initdb.d/schema.sql`(initialization)

#### 2. Flask Web Application Container

- **Image**: `task-manager-web` (custom built)
- **Container Name**: `task-manager-web`
- **Exposed Port**: `5000:5000`
- **Dependencies**: Waits for PostgreSQL to be healthy
- **Initializes schema from database/init-db.sql**

## Container List

| Container Name | Role | Base Image | Ports | Dependencies |
|----------------|------|------------|-------|--------------|
| task-manager-web  | Web app | task-manager-web (custom) |  5000:5000 | db |
|postgres-db   | Database | postgres:13-alpine | 5432:5432 | None |


##  Instructions

### Preparation

1. **Clone or download** all project files to a directory
2. **Make scripts executable**:
   ```bash
   chmod +x *.sh
   ```
3. **Ensure Docker is running**:
   ```bash
   docker info
   ```

Before running the application, ensure Docker is installed and running on your system.

### Create application resources

``` bash
./prepare-app.sh
```
This script will:

- Build the custom Flask web application image
- Create the custom Docker network
- Create the named volume for persistent storage
- Pull required base images from Docker Hub

### How to Run the Application

```bash
Start all services
./start-app.sh
```
This script will:

- Start the PostgreSQL database container
- Wait for the database to be ready
- Start the Flask web application container
- Display the access URL

### How to Access the Application

Once started, access the application via web browser at:
**http://localhost:5000**

Available endpoints:

- / - Main task management interface
- /api/tasks - REST API for tasks (GET, POST)
- /api/tasks/<id> - Individual task operations (GET, PUT, DELETE)

### How to Pause the Application

```bash
Stop all services (preserves data)
./stop-app.sh
```

This script will:

- Gracefully stop all running containers
- Preserve all persistent data
- Keep network and volume configurations intact

### How to Delete the Application

```bash
Remove all application resources
./remove-app.sh
```

This script will:

- Stop and remove all containers
- Remove the custom network
- Remove the persistent volume (This deletes all data)
- Remove custom built images.

##  Example Workflow

Here's a complete example of using the application:

### Create application resources

./prepare-app.sh
Preparing app...
- Building custom web application image...
- Creating network 'task-network'...
- Creating volume 'postgres-data'...
- Application prepared successfully!

### Run the application

./start-app.sh
Running app...
- Starting database container...
- Waiting for database to be ready...
- Starting web application container...
- The app is available at http://localhost:5000

#### Open web browser and navigate to http://localhost:5000

#### Create some tasks, mark them as complete, test the functionality

### Pause the application

./stop-app.sh
Stopping app...
- Stooping web application...
- Stopping database...
- Application stopped. Data preserved.

### Restart the application (data persists)

./start-app.sh
Running app...
- Starting database container...
- Starting web application container...
- The app is available at **http://localhost:5000**

### Delete all application resources

./remove-app.sh
Removing app...
- Stopping containers...
- Removing containers...
- Removing network...
- Removing volume...
- Removing images...
- Application completely removed.

## Troubleshooting

### Common Issues

#### 1.Port 5000 already in use

- Solution: Stop other services using port 5000 or modify the port in start-app.sh

#### 2.Database connection failed

- Solution: Ensure the database container is fully started before the web container
- Check: 
```docker logs postgres-db for database logs```

#### 3.Permission denied on scripts

- Solution: Run ```chmod +x *.sh``` to make scripts executable

#### 4.Docker daemon not running

- Solution: Start Docker service: 

```sudo systemctl start docker```

## Logs and Debugging

### View container logs:

#### Web application logs
```docker logs task-manager-web```

#### Database logs
```docker logs postgres-db```

#### Follow logs in real-time
```docker logs -f postgres-db```

## Documentation Links

- [Flask Documentation](https://flask.palletsprojects.com/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Docker](https://docs.docker.com/get-docker/) 
- [Docker Compose Documentation](https://docs.docker.com/compose/)

## Learning Resources

- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [Flask Best Practices](https://flask.palletsprojects.com/en/2.3.x/patterns/)
- [PostgreSQL Best Practices](https://wiki.postgresql.org/wiki/Don%27t_Do_This)

##  Contributing

This project is for educational purposes. Feel free to:
-  Report generation
-  Docker knowlegde improvements
-  Submit pull requests
-  Improve documentation

##  License

This project is created for docker and container practical purposes as part of CCS3308 Virtualization and Containers course.

---

**Author**: S.A.Thilani Dilmani

**Registration Number**: CIT-23-02-0173

**Course**: CCS3308 - Virtualization and Containers 

**Date**: 30/08/2025
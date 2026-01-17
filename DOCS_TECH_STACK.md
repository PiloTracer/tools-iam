# Tools IAM - Technology Stack

## Core Components

### Identity & Access Management
- **Keycloak 23.0**: Open Source Identity and Access Management
- **PostgreSQL 15**: Dedicated database for Keycloak persistence

### Infrastructure
- **Docker & Docker Compose**: Containerization and orchestration
- **Bash**: Management scripts (`bin/start.sh`)

## Implementation Details

### Backend (Future/Planned)
- **FastAPI**: Python web framework for custom extensions/APIs
- **Python 3.x**: Scripting and API logic

### Database
- **PostgreSQL**: Primary data store
- **Redis**: Caching layer (if needed for API/Keycloak)

## Development Environment
- **VS Code**: Recommended IDE
- **.env**: Configuration management

## Architecture Patterns
- **Containerized Microservices**: Service isolation via Docker
- **Infrastructure as Code**: Configuration via docker-compose

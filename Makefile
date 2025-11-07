.PHONY: help build start stop restart logs clean validate init reset backup restore

# Default target
help:
	@echo "Apache Superset - Available Commands"
	@echo "===================================="
	@echo ""
	@echo "Setup commands:"
	@echo "  make validate    - Validate configuration files"
	@echo "  make build       - Build Docker images"
	@echo "  make init        - Initialize database and create admin user"
	@echo ""
	@echo "Service management:"
	@echo "  make start       - Start all services"
	@echo "  make stop        - Stop all services"
	@echo "  make restart     - Restart all services"
	@echo "  make logs        - Show logs (press Ctrl+C to exit)"
	@echo "  make status      - Show service status"
	@echo ""
	@echo "Maintenance:"
	@echo "  make clean       - Stop services and remove containers"
	@echo "  make reset       - Clean everything and start fresh (DELETES DATA!)"
	@echo "  make backup      - Backup database"
	@echo "  make shell       - Open shell in Superset container"
	@echo ""
	@echo "Quick start:"
	@echo "  make validate && make build && make start"
	@echo ""

# Validate configuration
validate:
	@echo "Validating configuration..."
	@python3 validate_config.py
	@docker-compose config > /dev/null && echo "✓ Docker Compose configuration is valid"

# Build Docker images
build:
	@echo "Building Docker images..."
	@docker-compose build

# Initialize Superset
init:
	@echo "Initializing Superset database..."
	@docker-compose run --rm superset-init

# Start services
start:
	@echo "Starting services..."
	@docker-compose up -d
	@echo ""
	@echo "Services started! Access Superset at: http://localhost:8088"
	@echo "Default credentials: admin / admin"

# Stop services
stop:
	@echo "Stopping services..."
	@docker-compose down

# Restart services
restart:
	@echo "Restarting services..."
	@docker-compose restart

# Show logs
logs:
	@docker-compose logs -f

# Show status
status:
	@docker-compose ps

# Clean up (remove containers but keep volumes)
clean:
	@echo "Cleaning up..."
	@docker-compose down
	@echo "Containers removed. Data volumes preserved."

# Reset everything (WARNING: DELETES ALL DATA)
reset:
	@echo "⚠️  WARNING: This will delete ALL data!"
	@read -p "Are you sure? (yes/NO): " confirm && [ "$$confirm" = "yes" ] || exit 1
	@docker-compose down -v
	@echo "All data removed. Run 'make build && make start' to start fresh."

# Backup database
backup:
	@echo "Creating database backup..."
	@mkdir -p backups
	@docker-compose exec -T postgres pg_dump -U superset superset > backups/superset_backup_$$(date +%Y%m%d_%H%M%S).sql
	@echo "Backup created in backups/ directory"

# Restore database from backup
restore:
	@echo "Available backups:"
	@ls -1 backups/*.sql 2>/dev/null || echo "No backups found"
	@echo ""
	@read -p "Enter backup filename: " backup && \
	docker-compose exec -T postgres psql -U superset superset < "$$backup"

# Open shell in Superset container
shell:
	@docker-compose exec superset bash

# Open Python shell in Superset
python-shell:
	@docker-compose exec superset superset shell

# Create a new admin user
create-admin:
	@docker-compose exec superset superset fab create-admin

# Run database upgrade
db-upgrade:
	@docker-compose exec superset superset db upgrade

# Export requirements
export-requirements:
	@docker-compose exec superset pip freeze > requirements-frozen.txt
	@echo "Requirements exported to requirements-frozen.txt"

# Health check
health:
	@echo "Checking service health..."
	@curl -s http://localhost:8088/health || echo "Superset is not responding"
	@docker-compose exec redis redis-cli ping || echo "Redis is not responding"
	@docker-compose exec postgres pg_isready -U superset || echo "PostgreSQL is not responding"

# Development: Watch logs of specific service
logs-superset:
	@docker-compose logs -f superset

logs-postgres:
	@docker-compose logs -f postgres

logs-redis:
	@docker-compose logs -f redis

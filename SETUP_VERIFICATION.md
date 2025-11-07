# Setup Verification Guide

This document helps verify that your Apache Superset installation is working correctly.

## Pre-flight Checklist

Before starting Superset, verify:

- [ ] Docker is installed (`docker --version`)
- [ ] Docker Compose is installed (`docker-compose --version` or `docker compose version`)
- [ ] `.env` file exists and SECRET_KEY is set
- [ ] Configuration file is valid (`python3 validate_config.py`)
- [ ] No other services are using ports 8088, 5432, or 6379

## Installation Verification Steps

### 1. Check Configuration Files

```bash
# Verify all required files exist
ls -l superset_config.py docker-compose.yml .env Dockerfile requirements.txt

# Validate Python configuration
python3 validate_config.py

# Validate Docker Compose configuration
docker-compose config
```

### 2. Build Docker Images

```bash
# Build the Superset image
docker-compose build

# Verify the image was created
docker images | grep superset
```

### 3. Start Services

```bash
# Start all services
docker-compose up -d

# Check that all containers are running
docker-compose ps

# Expected output: 3 containers (superset, postgres, redis) should be "Up"
```

### 4. Monitor Initialization

```bash
# Watch the initialization logs
docker-compose logs -f superset-init

# Wait for "Superset initialization complete!" message
# Then watch the main Superset service
docker-compose logs -f superset
```

### 5. Verify Service Health

```bash
# Check PostgreSQL
docker-compose exec postgres pg_isready -U superset

# Check Redis
docker-compose exec redis redis-cli ping

# Check Superset (wait 30-60 seconds after startup)
curl http://localhost:8088/health
# Should return: {"status": "ok"}
```

### 6. Access Web Interface

1. Open browser: `http://localhost:8088`
2. You should see the Superset login page
3. Login with credentials:
   - Username: `admin`
   - Password: `admin`
4. Change password immediately after first login

### 7. Test Basic Functionality

Once logged in:

1. **Navigate Dashboard**
   - Click on "Dashboards" in the top menu
   - Verify you can see the dashboard list (may be empty)

2. **Check Database Connections**
   - Go to Settings → Database Connections
   - Verify the metadata database connection exists

3. **Test SQL Lab**
   - Click on "SQL Lab" → "SQL Editor"
   - Try a simple query: `SELECT 1 as test;`
   - Verify the query executes successfully

4. **Check Settings**
   - Go to Settings → List Users
   - Verify admin user is listed

## Common Issues and Solutions

### Port Already in Use

```bash
# Check what's using the ports
lsof -i :8088
lsof -i :5432
lsof -i :6379

# Solution: Stop the conflicting service or change ports in docker-compose.yml
```

### Database Connection Failed

```bash
# Check PostgreSQL logs
docker-compose logs postgres

# Restart PostgreSQL
docker-compose restart postgres

# Wait and restart Superset
docker-compose restart superset
```

### Superset Won't Start

```bash
# View detailed logs
docker-compose logs --tail=100 superset

# Common causes:
# 1. Database not ready - wait longer or check postgres health
# 2. Secret key issues - verify .env file
# 3. Permission issues - check volume permissions
```

### Can't Login

```bash
# Reset admin password
docker-compose exec superset superset fab create-admin \
  --username admin \
  --firstname Admin \
  --lastname User \
  --email admin@example.com \
  --password newpassword
```

### Services Keep Restarting

```bash
# Check resource usage
docker stats

# Superset requires at least 4GB RAM
# Increase Docker's memory allocation if needed
```

## Performance Verification

### Response Time Test

```bash
# Time the home page load
time curl -s http://localhost:8088/ > /dev/null

# Should complete in < 2 seconds after warmup
```

### Cache Test

```bash
# Check Redis connection
docker-compose exec superset python3 -c "
import redis
r = redis.from_url('redis://redis:6379/0')
r.set('test', 'hello')
print('Redis test:', r.get('test'))
"
```

### Database Performance

```bash
# Check database size
docker-compose exec postgres psql -U superset -c "
SELECT pg_size_pretty(pg_database_size('superset')) as size;
"

# Check table count
docker-compose exec postgres psql -U superset -c "
SELECT count(*) FROM information_schema.tables 
WHERE table_schema = 'public';
"
```

## Cleanup (if needed)

```bash
# Stop all services
docker-compose down

# Remove volumes (WARNING: This deletes all data!)
docker-compose down -v

# Remove images
docker rmi $(docker images | grep superset | awk '{print $3}')

# Start fresh
docker-compose up -d
```

## Verification Checklist

After completing setup, verify:

- [ ] All containers are running (`docker-compose ps`)
- [ ] Health endpoint responds (`curl http://localhost:8088/health`)
- [ ] Web interface is accessible
- [ ] Can login with admin credentials
- [ ] SQL Lab is functional
- [ ] No errors in logs (`docker-compose logs`)
- [ ] Admin password has been changed
- [ ] `.env` has a secure SECRET_KEY

## Next Steps

Once verification is complete:

1. Configure additional database connections
2. Import or create dashboards
3. Set up user access and roles
4. Configure email for alerts
5. Review security settings
6. Set up backups
7. Configure monitoring

## Support

If you encounter issues not covered here:

1. Check logs: `docker-compose logs`
2. Review README.md for configuration options
3. Consult Apache Superset documentation
4. Check GitHub issues: https://github.com/apache/superset/issues

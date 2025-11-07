# Apache Superset - Configuration Fixes

This repository contains configuration files and setup for Apache Superset, a modern data exploration and visualization platform.

## Overview

Apache Superset is a data exploration and visualization platform that allows users to create interactive dashboards and visualizations. This repository provides a complete setup with Docker Compose for easy deployment.

## Features

- 🐳 Docker-based deployment with Docker Compose
- 🔧 Pre-configured Superset settings
- 🗄️ PostgreSQL database support
- 💾 Redis caching integration
- 🔒 Security configurations
- 🌍 Multi-language support (including Polish)
- 📊 Ready for production use

## Quick Start

### Prerequisites

- Docker Engine 20.10+
- Docker Compose 2.0+
- At least 4GB of RAM

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/SciSoftwareSlawomirCichy/superset-fixes.git
   cd superset-fixes
   ```

2. **Configure environment variables**
   ```bash
   cp .env.example .env
   ```
   
   Edit `.env` and set at least the `SECRET_KEY`:
   ```bash
   # Generate a secret key
   openssl rand -base64 42
   ```

3. **Start the services**
   ```bash
   # Build and start all services
   docker-compose up -d
   
   # Wait for initialization to complete (check logs)
   docker-compose logs -f superset-init
   ```

4. **Access Superset**
   
   Open your browser and navigate to: `http://localhost:8088`
   
   Default credentials:
   - Username: `admin`
   - Password: `admin`
   
   **⚠️ Important:** Change the admin password immediately after first login!

## Configuration

### Main Configuration File

The main Superset configuration is in `superset_config.py`. Key settings include:

- **Database**: Connection to PostgreSQL/MySQL/SQLite
- **Cache**: Redis configuration for better performance
- **Security**: CORS, CSRF, and authentication settings
- **Features**: Enable/disable Superset features
- **Email**: SMTP configuration for alerts and reports

### Environment Variables

All sensitive configuration should be done via environment variables in the `.env` file:

- `SECRET_KEY`: Application secret key (required)
- `DATABASE_URL`: Database connection string
- `REDIS_URL`: Redis connection string
- `CORS_ORIGINS`: Allowed CORS origins
- `SMTP_*`: Email server configuration
- `MAPBOX_API_KEY`: For map visualizations (optional)

## Services

The Docker Compose setup includes:

- **superset**: Main Superset application (port 8088)
- **postgres**: PostgreSQL database (port 5432)
- **redis**: Redis cache (port 6379)
- **superset-init**: One-time initialization container

## Database Drivers

Additional database drivers can be installed by uncommenting the relevant lines in `requirements.txt`:

- PostgreSQL (included by default)
- MySQL/MariaDB
- Microsoft SQL Server
- Oracle
- Google BigQuery
- Snowflake
- Presto/Trino
- Elasticsearch

## Management Commands

### Starting Services
```bash
docker-compose up -d
```

### Stopping Services
```bash
docker-compose down
```

### Viewing Logs
```bash
docker-compose logs -f superset
```

### Database Upgrade
```bash
docker-compose exec superset superset db upgrade
```

### Creating a New Admin User
```bash
docker-compose exec superset superset fab create-admin \
  --username <username> \
  --firstname <firstname> \
  --lastname <lastname> \
  --email <email> \
  --password <password>
```

### Backup Database
```bash
# PostgreSQL backup
docker-compose exec postgres pg_dump -U superset superset > backup.sql
```

### Restore Database
```bash
# PostgreSQL restore
docker-compose exec -T postgres psql -U superset superset < backup.sql
```

## Customization

### Adding Custom Visualizations

Custom visualizations can be added by:
1. Creating a custom Docker image extending the base Superset image
2. Installing additional Python packages via `requirements.txt`
3. Updating the `Dockerfile` to include custom plugins

### Configuring Authentication

Superset supports multiple authentication methods:
- Database authentication (default)
- LDAP
- OAuth (Google, GitHub, etc.)
- OpenID

Uncomment and configure the relevant sections in `superset_config.py`.

## Troubleshooting

### Port Already in Use
If port 8088, 5432, or 6379 is already in use, modify the port mappings in `docker-compose.yml`.

### Database Connection Issues
Ensure PostgreSQL is fully started before Superset. Check logs:
```bash
docker-compose logs postgres
```

### Permission Denied Errors
Ensure the data volumes have correct permissions:
```bash
docker-compose down -v
docker-compose up -d
```

### Memory Issues
Superset requires at least 4GB of RAM. Increase Docker's memory allocation if needed.

## Production Deployment

For production deployment, consider:

1. **Use strong SECRET_KEY**: Generate with `openssl rand -base64 42`
2. **Use external database**: PostgreSQL or MySQL instead of SQLite
3. **Enable SSL/TLS**: Use a reverse proxy (nginx, traefik)
4. **Configure backups**: Regular database backups
5. **Monitor resources**: Set up monitoring and alerting
6. **Update regularly**: Keep Superset and dependencies up to date
7. **Restrict CORS**: Set specific origins instead of `*`
8. **Use secrets management**: Consider Docker secrets or vault

## Security

- Change default admin password immediately
- Use environment variables for sensitive data
- Enable HTTPS in production
- Regularly update dependencies
- Review and configure CORS settings
- Enable authentication for production use

## Support

For issues and questions:
- Apache Superset Documentation: https://superset.apache.org/docs/intro
- GitHub Issues: https://github.com/apache/superset/issues
- Community Slack: https://apache-superset.slack.com/

## License

This configuration is provided under the Apache License 2.0, same as Apache Superset.

## Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues for bugs and feature requests.
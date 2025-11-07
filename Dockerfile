# Apache Superset Dockerfile
FROM apache/superset:3.1.0

# Switch to root to install dependencies
USER root

# Copy custom configuration
COPY superset_config.py /app/
ENV SUPERSET_CONFIG_PATH /app/superset_config.py

# Copy requirements and install additional packages
COPY requirements.txt /app/requirements-local.txt
RUN pip install --no-cache-dir -r /app/requirements-local.txt

# Create directory for SQLite database
RUN mkdir -p /app/superset_home && \
    chown -R superset:superset /app/superset_home

# Switch back to superset user
USER superset

# Set working directory
WORKDIR /app

# Expose the default port
EXPOSE 8088

# Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8088/health || exit 1

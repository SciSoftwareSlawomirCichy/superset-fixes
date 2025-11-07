#!/bin/bash
# Quick Start Script for Apache Superset
# This script helps you get started quickly with Superset

set -e

echo "╔════════════════════════════════════════════════════════════╗"
echo "║     Apache Superset - Quick Start Script                  ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    echo "   Visit: https://docs.docker.com/get-docker/"
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    echo "   Visit: https://docs.docker.com/compose/install/"
    exit 1
fi

echo "✓ Docker is installed"
echo "✓ Docker Compose is installed"
echo ""

# Check if .env file exists
if [ ! -f .env ]; then
    echo "📝 Creating .env file from template..."
    cp .env.example .env
    
    # Generate a random secret key
    if command -v openssl &> /dev/null; then
        SECRET_KEY=$(openssl rand -base64 42)
        # Use sed to replace the SECRET_KEY in .env file (works on both Linux and macOS)
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' "s|SECRET_KEY=.*|SECRET_KEY=$SECRET_KEY|" .env
        else
            sed -i "s|SECRET_KEY=.*|SECRET_KEY=$SECRET_KEY|" .env
        fi
        echo "✓ Generated secure SECRET_KEY"
    else
        echo "⚠️  Could not generate SECRET_KEY (openssl not found)"
        echo "   Please manually edit .env and set a secure SECRET_KEY"
    fi
    echo ""
else
    echo "✓ .env file already exists"
    echo ""
fi

# Validate configuration
echo "🔍 Validating configuration..."
if command -v python3 &> /dev/null; then
    python3 validate_config.py
    echo ""
else
    echo "⚠️  Python3 not found, skipping validation"
    echo ""
fi

# Ask user if they want to continue
echo "Ready to start Apache Superset!"
echo ""
echo "The following services will be started:"
echo "  - PostgreSQL database (port 5432)"
echo "  - Redis cache (port 6379)"
echo "  - Superset web interface (port 8088)"
echo ""
read -p "Do you want to continue? (y/n) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
fi

# Build and start services
echo ""
echo "🚀 Building and starting services..."
echo "This may take a few minutes on first run..."
echo ""

# Use docker compose or docker-compose depending on what's available
if docker compose version &> /dev/null; then
    DOCKER_COMPOSE="docker compose"
else
    DOCKER_COMPOSE="docker-compose"
fi

$DOCKER_COMPOSE build
echo ""
$DOCKER_COMPOSE up -d

echo ""
echo "⏳ Waiting for services to be ready..."
sleep 10

# Check if services are running
echo ""
echo "📊 Service Status:"
$DOCKER_COMPOSE ps

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║     Apache Superset is now running! 🎉                     ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "🌐 Access Superset at: http://localhost:8088"
echo ""
echo "🔑 Default credentials:"
echo "   Username: admin"
echo "   Password: admin"
echo ""
echo "⚠️  IMPORTANT: Please change the admin password after first login!"
echo ""
echo "📝 Useful commands:"
echo "   View logs:        $DOCKER_COMPOSE logs -f superset"
echo "   Stop services:    $DOCKER_COMPOSE down"
echo "   Restart services: $DOCKER_COMPOSE restart"
echo ""
echo "📖 For more information, see README.md"
echo ""

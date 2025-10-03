#!/bin/bash

set -e

echo "======================================"
echo "  SplitBill Deployment Script"
echo "======================================"
echo ""

DEPLOY_DIR="/opt/splitbill"
BACKUP_DIR="/opt/splitbill-backups"

# Check if we're in the right directory
if [ ! -f "docker-compose.prod.yml" ]; then
    echo "❌ Error: docker-compose.prod.yml not found!"
    echo "Please run this script from /opt/splitbill/deploy directory"
    exit 1
fi

# Check if .env exists
if [ ! -f ".env" ]; then
    echo "❌ Error: .env file not found!"
    echo "Please create .env file in /opt/splitbill/deploy/ first"
    echo "You can copy .env.example and edit it:"
    echo "  cp .env.example .env"
    echo "  nano .env"
    exit 1
fi

# Create backup directory
mkdir -p $BACKUP_DIR

# Create backup
echo "📦 Creating backup..."
timestamp=$(date +%Y%m%d_%H%M%S)
tar -czf "$BACKUP_DIR/backup_$timestamp.tar.gz" \
    -C $DEPLOY_DIR \
    --exclude='node_modules' \
    --exclude='.git' \
    . 2>/dev/null || true

# Stop existing containers
echo "⏸️  Stopping existing containers..."
docker-compose -f docker-compose.prod.yml down 2>/dev/null || true

# Build and start
echo "🔨 Building and starting containers..."
echo "This will take 5-10 minutes on first run..."
docker-compose -f docker-compose.prod.yml up -d --build

# Wait for services
echo "⏳ Waiting for services to start..."
sleep 30

# Check health
echo ""
echo "🏥 Checking service health..."
docker-compose -f docker-compose.prod.yml ps

# Show logs
echo ""
echo "📋 Recent logs:"
docker-compose -f docker-compose.prod.yml logs --tail=20

echo ""
echo "✅ Deployment complete!"
echo ""
echo "🌐 Access your application at:"
echo "   http://$(curl -s ifconfig.me 2>/dev/null || echo 'YOUR_SERVER_IP')"
echo ""
echo "📝 Useful commands:"
echo "   View logs:    docker-compose -f docker-compose.prod.yml logs -f"
echo "   Restart:      docker-compose -f docker-compose.prod.yml restart"
echo "   Stop:         docker-compose -f docker-compose.prod.yml down"
echo "   Status:       docker-compose -f docker-compose.prod.yml ps"
echo ""

# Cleanup old backups (keep last 5)
cd $BACKUP_DIR
ls -t backup_*.tar.gz 2>/dev/null | tail -n +6 | xargs -r rm --

echo "💾 Backup saved to: $BACKUP_DIR/backup_$timestamp.tar.gz"
echo ""
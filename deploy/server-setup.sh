#!/bin/bash

echo "======================================"
echo "  SplitBill Server Setup Script"
echo "  Ubuntu 22.04 LTS"
echo "======================================"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "⚠️  Please run as root or with sudo"
    exit 1
fi

echo "📦 Step 1: Updating system packages..."
apt-get update
apt-get upgrade -y

echo "🐳 Step 2: Installing Docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
rm get-docker.sh

# Start and enable Docker
systemctl enable docker
systemctl start docker

# Add user to docker group
usermod -aG docker cloud_user

echo "🔧 Step 3: Installing Docker Compose..."
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

echo "📚 Step 4: Installing Git and utilities..."
apt-get install -y git curl wget nano htop net-tools

echo "🔥 Step 5: Configuring firewall..."
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw --force enable

echo "📁 Step 6: Creating application directory..."
mkdir -p /opt/splitbill
chown -R cloud_user:cloud_user /opt/splitbill

echo ""
echo "✅ Server setup complete!"
echo ""
echo "⚠️  IMPORTANT NEXT STEPS:"
echo "1. Log out and log back in for docker group changes"
echo "2. Clone your repository to /opt/splitbill"
echo "3. Create .env file in /opt/splitbill/deploy/"
echo "4. Run the deployment script"
echo ""


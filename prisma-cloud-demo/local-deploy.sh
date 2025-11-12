#!/bin/bash

# Local Terraform Deployment Script using MinIO
# This script starts MinIO (S3-compatible storage) and deploys the Terraform configuration locally
# No cloud credentials required - runs entirely with local Docker services

set -e

echo "========================================="
echo "Local Infrastructure Deployment Demo"
echo "Using MinIO and local services"
echo "No cloud credentials required!"
echo "========================================="
echo ""

# Check if docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    echo "   Visit: https://docs.docker.com/get-docker/"
    exit 1
fi

# Check if docker-compose is available
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null 2>&1; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    echo "   Visit: https://docs.docker.com/compose/install/"
    exit 1
fi

# Determine docker-compose command
if command -v docker-compose &> /dev/null; then
    DOCKER_COMPOSE="docker-compose"
else
    DOCKER_COMPOSE="docker compose"
fi

# Check if terraform is installed
if ! command -v terraform &> /dev/null; then
    echo "❌ Terraform is not installed. Please install Terraform first."
    echo "   Visit: https://www.terraform.io/downloads"
    exit 1
fi

echo "✅ Prerequisites check passed!"
echo ""

# Start MinIO
echo "🚀 Starting MinIO (S3-compatible storage)..."
cd ..
$DOCKER_COMPOSE up -d minio

echo "⏳ Waiting for MinIO to be ready..."
sleep 5

# Wait for MinIO health check
MAX_RETRIES=30
RETRY_COUNT=0
while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    if curl -sf http://localhost:9000/minio/health/live > /dev/null 2>&1; then
        echo "✅ MinIO is ready!"
        break
    fi
    RETRY_COUNT=$((RETRY_COUNT + 1))
    echo "   Waiting for MinIO... ($RETRY_COUNT/$MAX_RETRIES)"
    sleep 2
done

if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
    echo "❌ MinIO failed to start properly"
    exit 1
fi

echo ""

# Navigate to terraform directory
cd prisma-cloud-demo/terraform

# Initialize Terraform
echo "📦 Initializing Terraform..."
terraform init

echo ""

# Create terraform.tfvars for MinIO
echo "📝 Creating local configuration..."
cat > terraform.tfvars <<EOF
minio_endpoint  = "localhost:9000"
minio_user      = "minioadmin"
minio_password  = "minioadmin"
bucket_name     = "demo-bucket"
admin_ip_cidr   = "10.0.0.0/8"
EOF

echo ""

# Plan Terraform deployment
echo "📋 Planning Terraform deployment..."
terraform plan -out=tfplan

echo ""

# Apply Terraform deployment
echo "🚀 Deploying resources to local MinIO..."
terraform apply tfplan

echo ""
echo "✅ Deployment completed successfully!"
echo ""
echo "📊 You can now:"
echo "   - View resources: terraform show"
echo "   - Access MinIO Console: http://localhost:9001 (user: minioadmin, password: minioadmin)"
echo "   - List buckets: mc alias set local http://localhost:9000 minioadmin minioadmin && mc ls local"
echo ""
echo "🧹 To clean up:"
echo "   - Run: terraform destroy -auto-approve"
echo "   - Stop MinIO: cd .. && $DOCKER_COMPOSE down"
echo ""

#!/bin/bash

# Local Terraform Deployment Script using LocalStack
# This script starts LocalStack and deploys the Terraform configuration locally

set -e

echo "========================================="
echo "Local Cloud Deployment Demo"
echo "Using LocalStack for AWS emulation"
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

# Start LocalStack
echo "🚀 Starting LocalStack..."
cd ..
$DOCKER_COMPOSE up -d localstack

echo "⏳ Waiting for LocalStack to be ready..."
sleep 10

# Wait for LocalStack health check
MAX_RETRIES=30
RETRY_COUNT=0
while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    if curl -s http://localhost:4566/_localstack/health | grep -q '"s3": "available"'; then
        echo "✅ LocalStack is ready!"
        break
    fi
    RETRY_COUNT=$((RETRY_COUNT + 1))
    echo "   Waiting for LocalStack... ($RETRY_COUNT/$MAX_RETRIES)"
    sleep 2
done

if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
    echo "❌ LocalStack failed to start properly"
    exit 1
fi

echo ""

# Navigate to terraform directory
cd prisma-cloud-demo/terraform

# Initialize Terraform
echo "📦 Initializing Terraform..."
terraform init

echo ""

# Create terraform.tfvars for LocalStack
echo "📝 Creating LocalStack configuration..."
cat > terraform.tfvars <<EOF
use_localstack     = true
localstack_endpoint = "http://localhost:4566"
aws_region         = "us-east-1"
bucket_name        = "local-demo-bucket"
vpc_id             = "vpc-local123"
admin_ip_cidr      = "10.0.0.0/8"
EOF

echo ""

# Plan Terraform deployment
echo "📋 Planning Terraform deployment..."
terraform plan -out=tfplan

echo ""

# Apply Terraform deployment
echo "🚀 Deploying resources to LocalStack..."
terraform apply tfplan

echo ""
echo "✅ Deployment completed successfully!"
echo ""
echo "📊 You can now:"
echo "   - View resources: terraform show"
echo "   - List S3 buckets: aws --endpoint-url=http://localhost:4566 s3 ls"
echo "   - Test with InSpec (if configured)"
echo ""
echo "🧹 To clean up:"
echo "   - Run: terraform destroy -auto-approve"
echo "   - Stop LocalStack: cd .. && $DOCKER_COMPOSE down"
echo ""

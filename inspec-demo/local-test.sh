#!/bin/bash

# InSpec Local Testing Script
# This script runs InSpec compliance tests against MinIO (no cloud credentials needed)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "========================================="
echo "InSpec Local Testing Demo"
echo "Testing Against MinIO Local Storage"
echo "No cloud credentials required!"
echo "========================================="
echo ""

# Check if InSpec is installed
if ! command -v inspec &> /dev/null; then
    echo "⚠️  InSpec is not installed."
    echo "Please install InSpec using one of these methods:"
    echo ""
    echo "  macOS/Linux:"
    echo "    curl https://omnitruck.chef.io/install.sh | sudo bash -s -- -P inspec"
    echo ""
    echo "  Or using Ruby gem:"
    echo "    gem install inspec-bin"
    echo ""
    echo "  Or download from:"
    echo "    https://docs.chef.io/inspec/install/"
    echo ""
    exit 1
fi

echo "✅ InSpec is installed!"
inspec --version
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "⚠️  Docker is not installed."
    echo "Docker is required to run MinIO."
    echo "Please install Docker from: https://docs.docker.com/get-docker/"
    echo ""
    exit 1
fi

echo "✅ Docker is installed!"
echo ""

# Check if MinIO is running
echo "🔍 Checking MinIO status..."
if ! curl -sf http://localhost:9000/minio/health/live > /dev/null 2>&1; then
    echo "⚠️  MinIO is not running."
    echo ""
    echo "Starting MinIO..."
    cd "$PROJECT_ROOT"
    if command -v docker-compose &> /dev/null; then
        docker-compose up -d minio
    else
        docker compose up -d minio
    fi
    
    echo "⏳ Waiting for MinIO to be ready..."
    for i in {1..30}; do
        if curl -sf http://localhost:9000/minio/health/live > /dev/null 2>&1; then
            echo "✅ MinIO is ready!"
            break
        fi
        echo -n "."
        sleep 2
    done
    echo ""
else
    echo "✅ MinIO is already running!"
fi
echo ""

echo "🔧 Local storage endpoint configured:"
echo "   MinIO API: http://localhost:9000"
echo "   MinIO Console: http://localhost:9001"
echo ""

# Deploy test infrastructure if needed
echo "📦 Checking if test infrastructure is deployed..."
cd "$PROJECT_ROOT/prisma-cloud-demo/terraform"

if [ ! -f ".terraform.lock.hcl" ]; then
    echo "🔧 Initializing Terraform..."
    terraform init -upgrade
fi

# Check if infrastructure is already deployed
if terraform show 2>/dev/null | grep -q "# minio_s3_bucket"; then
    echo "✅ Test infrastructure is already deployed!"
else
    echo "🚀 Deploying test infrastructure to MinIO..."
    terraform apply -auto-approve
    echo "✅ Infrastructure deployed!"
fi
echo ""

# Create results directory
mkdir -p "$SCRIPT_DIR/test-results"

# Run InSpec tests against local MinIO
echo "📋 Running InSpec security compliance tests against local storage..."
echo ""

cd "$SCRIPT_DIR"

# Run tests with CLI output
echo "Running tests with CLI output..."
inspec exec profiles/local-baseline/ \
    --input minio_endpoint=http://localhost:9000 \
    --reporter cli

echo ""
echo "---"
echo ""

# Run tests with JSON output
echo "Running tests with JSON output..."
inspec exec profiles/local-baseline/ \
    --input minio_endpoint=http://localhost:9000 \
    --reporter json:test-results/results.json \
    --reporter cli

echo ""
echo "✅ Tests completed!"
echo "📄 Results saved to test-results/results.json"
echo ""
echo "To view detailed JSON results:"
echo "  cat test-results/results.json | jq"
echo ""
echo "To generate HTML report:"
echo "  inspec exec profiles/local-baseline/ --reporter html:test-results/report.html"
echo ""
echo "To clean up:"
echo "  cd $PROJECT_ROOT && ./inspec-demo/local-cleanup.sh"
echo ""

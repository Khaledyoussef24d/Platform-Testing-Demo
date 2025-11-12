#!/bin/bash

# InSpec Local Testing Script
# This script runs InSpec compliance tests against LocalStack (no AWS credentials needed)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "========================================="
echo "InSpec Local Testing Demo"
echo "Testing Against LocalStack"
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
    echo "Docker is required to run LocalStack."
    echo "Please install Docker from: https://docs.docker.com/get-docker/"
    echo ""
    exit 1
fi

echo "✅ Docker is installed!"
echo ""

# Check if LocalStack is running
echo "🔍 Checking LocalStack status..."
if ! curl -s http://localhost:4566/_localstack/health > /dev/null 2>&1; then
    echo "⚠️  LocalStack is not running."
    echo ""
    echo "Starting LocalStack..."
    cd "$PROJECT_ROOT"
    docker-compose up -d localstack
    
    echo "⏳ Waiting for LocalStack to be ready..."
    for i in {1..30}; do
        if curl -s http://localhost:4566/_localstack/health > /dev/null 2>&1; then
            echo "✅ LocalStack is ready!"
            break
        fi
        echo -n "."
        sleep 2
    done
    echo ""
else
    echo "✅ LocalStack is already running!"
fi
echo ""

# Set up environment for LocalStack
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1
export AWS_ENDPOINT_URL=http://localhost:4566

echo "🔧 Environment configured for LocalStack:"
echo "   Endpoint: $AWS_ENDPOINT_URL"
echo "   Region: $AWS_DEFAULT_REGION"
echo ""

# Deploy test infrastructure if needed
echo "📦 Checking if test infrastructure is deployed..."
cd "$PROJECT_ROOT/prisma-cloud-demo/terraform"

if [ ! -f ".terraform.lock.hcl" ]; then
    echo "🔧 Initializing Terraform..."
    terraform init -upgrade
fi

# Check if infrastructure is already deployed
if terraform show 2>/dev/null | grep -q "# aws_s3_bucket"; then
    echo "✅ Test infrastructure is already deployed!"
else
    echo "🚀 Deploying test infrastructure to LocalStack..."
    terraform apply -var="use_localstack=true" -auto-approve
    echo "✅ Infrastructure deployed!"
fi
echo ""

# Create results directory
mkdir -p "$SCRIPT_DIR/test-results"

# Run InSpec tests against LocalStack
echo "📋 Running InSpec security compliance tests against LocalStack..."
echo ""

cd "$SCRIPT_DIR"

# Run tests with CLI output
echo "Running tests with CLI output..."
inspec exec profiles/local-baseline/ \
    -t aws:// \
    --input localstack_endpoint=http://localhost:4566 \
    --reporter cli

echo ""
echo "---"
echo ""

# Run tests with JSON output
echo "Running tests with JSON output..."
inspec exec profiles/local-baseline/ \
    -t aws:// \
    --input localstack_endpoint=http://localhost:4566 \
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
echo "  inspec exec profiles/local-baseline/ -t aws:// --reporter html:test-results/report.html"
echo ""
echo "To clean up:"
echo "  cd $PROJECT_ROOT && ./inspec-demo/local-cleanup.sh"
echo ""

#!/bin/bash

# InSpec Local Testing Cleanup Script
# This script cleans up LocalStack resources and stops the container

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "========================================="
echo "InSpec Local Testing Cleanup"
echo "========================================="
echo ""

# Set up environment for LocalStack
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1
export AWS_ENDPOINT_URL=http://localhost:4566

# Destroy Terraform infrastructure
echo "🗑️  Destroying test infrastructure..."
cd "$PROJECT_ROOT/prisma-cloud-demo/terraform"

if [ -f ".terraform.lock.hcl" ]; then
    terraform destroy -var="use_localstack=true" -auto-approve
    echo "✅ Infrastructure destroyed!"
else
    echo "⚠️  No Terraform state found, skipping destroy."
fi
echo ""

# Stop LocalStack container
echo "🛑 Stopping LocalStack container..."
cd "$PROJECT_ROOT"
docker-compose down

echo ""
echo "✅ Cleanup completed!"
echo ""
echo "To start testing again, run:"
echo "  cd inspec-demo"
echo "  ./local-test.sh"
echo ""

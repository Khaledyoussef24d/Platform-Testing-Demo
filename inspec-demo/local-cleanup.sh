#!/bin/bash

# InSpec Local Testing Cleanup Script
# This script cleans up MinIO resources and stops the container

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "========================================="
echo "InSpec Local Testing Cleanup"
echo "========================================="
echo ""

# Destroy Terraform infrastructure
echo "🗑️  Destroying test infrastructure..."
cd "$PROJECT_ROOT/prisma-cloud-demo/terraform"

if [ -f ".terraform.lock.hcl" ]; then
    terraform destroy -auto-approve
    echo "✅ Infrastructure destroyed!"
else
    echo "⚠️  No Terraform state found, skipping destroy."
fi
echo ""

# Stop MinIO container
echo "🛑 Stopping MinIO container..."
cd "$PROJECT_ROOT"
if command -v docker-compose &> /dev/null; then
    docker-compose down -v
else
    docker compose down -v
fi

echo ""
echo "✅ Cleanup completed!"
echo ""
echo "To start testing again, run:"
echo "  cd inspec-demo"
echo "  ./local-test.sh"
echo ""

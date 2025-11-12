#!/bin/bash

# Local Infrastructure Cleanup Script
# This script destroys Terraform resources and stops MinIO

set -e

echo "========================================="
echo "Local Infrastructure Cleanup"
echo "========================================="
echo ""

cd terraform

# Destroy Terraform resources
if [ -f "terraform.tfstate" ]; then
    echo "🧹 Destroying Terraform resources..."
    terraform destroy -auto-approve || true
    echo "✅ Terraform resources destroyed"
else
    echo "ℹ️  No Terraform state found, skipping destroy"
fi

# Remove generated files
echo "🗑️  Removing generated files..."
rm -f terraform.tfvars tfplan
rm -rf .terraform .terraform.lock.hcl

cd ../..

# Stop MinIO
echo "🛑 Stopping MinIO..."
if command -v docker-compose &> /dev/null; then
    docker-compose down -v
else
    docker compose down -v
fi

echo ""
echo "✅ Cleanup completed!"
echo ""

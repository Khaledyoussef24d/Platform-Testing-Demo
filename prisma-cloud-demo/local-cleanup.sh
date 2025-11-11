#!/bin/bash

# Local Cloud Cleanup Script
# This script destroys Terraform resources and stops LocalStack

set -e

echo "========================================="
echo "Local Cloud Cleanup"
echo "========================================="
echo ""

cd terraform

# Destroy Terraform resources
if [ -f "terraform.tfstate" ]; then
    echo "🧹 Destroying Terraform resources..."
    terraform destroy -auto-approve -var="use_localstack=true" -var="localstack_endpoint=http://localhost:4566" || true
    echo "✅ Terraform resources destroyed"
else
    echo "ℹ️  No Terraform state found, skipping destroy"
fi

# Remove generated files
echo "🗑️  Removing generated files..."
rm -f terraform.tfvars tfplan
rm -rf .terraform .terraform.lock.hcl

cd ../..

# Stop LocalStack
echo "🛑 Stopping LocalStack..."
if command -v docker-compose &> /dev/null; then
    docker-compose down
else
    docker compose down
fi

echo ""
echo "✅ Cleanup completed!"
echo ""

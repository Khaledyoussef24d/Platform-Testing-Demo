#!/bin/bash

# Prisma Cloud Demo - IaC Security Scanning Script
# This script demonstrates how to scan Infrastructure as Code using Prisma Cloud (Checkov)

set -e

echo "========================================="
echo "Prisma Cloud Demo - IaC Security Scanner"
echo "========================================="
echo ""

# Check if checkov is installed
if ! command -v checkov &> /dev/null; then
    echo "⚠️  Checkov (Prisma Cloud CLI) is not installed."
    echo "Installing checkov..."
    pip3 install checkov
    echo "✅ Checkov installed successfully!"
    echo ""
fi

echo "📋 Scanning Terraform configurations..."
echo ""

# Run Checkov scan on Terraform directory
checkov -d terraform/ \
    --framework terraform \
    --output cli \
    --output json \
    --output-file-path scan-results/

echo ""
echo "✅ Scan completed!"
echo "📄 Results saved to scan-results/ directory"
echo ""
echo "To view detailed results:"
echo "  - CLI output: See above"
echo "  - JSON output: cat scan-results/results_json.json | jq"
echo ""

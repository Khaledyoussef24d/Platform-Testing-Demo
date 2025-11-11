#!/bin/bash

# InSpec Demo - Cloud Security Testing Script
# This script demonstrates how to run InSpec compliance tests against AWS

set -e

echo "========================================="
echo "InSpec Demo - Cloud Security Testing"
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

# Check AWS credentials
if [ -z "$AWS_ACCESS_KEY_ID" ] && [ -z "$AWS_PROFILE" ]; then
    echo "⚠️  AWS credentials not found."
    echo "Please set up AWS credentials using one of these methods:"
    echo ""
    echo "  1. Environment variables:"
    echo "     export AWS_ACCESS_KEY_ID=your_access_key"
    echo "     export AWS_SECRET_ACCESS_KEY=your_secret_key"
    echo "     export AWS_REGION=us-east-1"
    echo ""
    echo "  2. AWS Profile:"
    echo "     export AWS_PROFILE=your_profile_name"
    echo ""
    echo "  3. AWS CLI configuration:"
    echo "     aws configure"
    echo ""
    echo "⚠️  Running in check-only mode (will show test structure)"
    echo ""
    
    # Run in check mode only
    echo "📋 Checking InSpec profile structure..."
    inspec check profiles/aws-security-baseline/
    
    exit 0
fi

echo "✅ AWS credentials configured!"
echo ""

# Create results directory
mkdir -p test-results

# Run InSpec tests
echo "📋 Running AWS security compliance tests..."
echo ""

# Option 1: Run with CLI output
echo "Running tests with CLI output..."
inspec exec profiles/aws-security-baseline/ \
    -t aws:// \
    --reporter cli

echo ""
echo "---"
echo ""

# Option 2: Run with JSON output
echo "Running tests with JSON output..."
inspec exec profiles/aws-security-baseline/ \
    -t aws:// \
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
echo "  inspec exec profiles/aws-security-baseline/ -t aws:// --reporter html:test-results/report.html"
echo ""

#!/bin/bash

# Quick Start Script for Platform Testing Demos
# This script helps users choose and run either the Prisma Cloud or InSpec demo

set -e

echo "========================================="
echo "Platform Testing Demos - Quick Start"
echo "========================================="
echo ""
echo "This repository contains two cloud security testing demos:"
echo ""
echo "1. Prisma Cloud Demo (IaC Security Scanning)"
echo "   - Scans Infrastructure as Code for security issues"
echo "   - Uses Checkov CLI"
echo "   - No AWS credentials required"
echo "   - Fast execution (seconds)"
echo ""
echo "2. InSpec Demo (Cloud Compliance Testing)"
echo "   - Tests deployed AWS infrastructure"
echo "   - Uses Chef InSpec"
echo "   - Requires AWS credentials"
echo "   - Runtime depends on AWS API calls"
echo ""
echo "========================================="
echo ""
read -p "Which demo would you like to run? (1 or 2): " choice

case $choice in
    1)
        echo ""
        echo "Starting Prisma Cloud Demo..."
        echo "--------------------------------"
        cd prisma-cloud-demo
        ./scan.sh
        ;;
    2)
        echo ""
        echo "Starting InSpec Demo..."
        echo "--------------------------------"
        cd inspec-demo
        ./run-tests.sh
        ;;
    *)
        echo ""
        echo "❌ Invalid choice. Please run the script again and choose 1 or 2."
        exit 1
        ;;
esac

echo ""
echo "========================================="
echo "Demo completed!"
echo ""
echo "Next steps:"
echo "  - Review the results above"
echo "  - Check the README in the demo directory for more options"
echo "  - Try integrating the tools into your CI/CD pipeline"
echo "========================================="

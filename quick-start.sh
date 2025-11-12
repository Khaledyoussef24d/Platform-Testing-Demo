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
echo "   - Tests deployed infrastructure"
echo "   - Uses Chef InSpec"
echo "   - Can test locally (LocalStack) or against AWS"
echo "   - Runtime depends on API calls"
echo ""
echo "========================================="
echo ""
echo "💡 Tip: For local testing without AWS credentials:"
echo "   - Prisma Cloud: cd prisma-cloud-demo && ./local-deploy.sh"
echo "   - InSpec: cd inspec-demo && ./local-test.sh"
echo ""
read -p "Which demo would you like to run? (1 or 2): " choice

case $choice in
    1)
        echo ""
        read -p "Run with (s)canning only or (l)ocal deployment? (s/l): " subchoice
        case $subchoice in
            s|S)
                echo ""
                echo "Starting Prisma Cloud Scanning Demo..."
                echo "--------------------------------"
                cd prisma-cloud-demo
                ./scan.sh
                ;;
            l|L)
                echo ""
                echo "Starting Prisma Cloud Local Deployment..."
                echo "--------------------------------"
                cd prisma-cloud-demo
                ./local-deploy.sh
                ;;
            *)
                echo ""
                echo "❌ Invalid choice. Defaulting to scan only."
                cd prisma-cloud-demo
                ./scan.sh
                ;;
        esac
        ;;
    2)
        echo ""
        read -p "Test against (l)ocal (LocalStack) or (a)ws? (l/a): " subchoice
        case $subchoice in
            l|L)
                echo ""
                echo "Starting InSpec Local Testing..."
                echo "--------------------------------"
                cd inspec-demo
                ./local-test.sh
                ;;
            a|A)
                echo ""
                echo "Starting InSpec AWS Testing..."
                echo "--------------------------------"
                cd inspec-demo
                ./run-tests.sh
                ;;
            *)
                echo ""
                echo "❌ Invalid choice. Defaulting to local testing."
                cd inspec-demo
                ./local-test.sh
                ;;
        esac
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

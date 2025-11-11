# Prisma Cloud Demo

This demo shows how to use Prisma Cloud (via Checkov CLI) to scan Infrastructure as Code (IaC) for security vulnerabilities and compliance issues.

## What is Prisma Cloud?

Prisma Cloud is a comprehensive cloud security platform that helps organizations secure their cloud infrastructure throughout the development lifecycle. It scans IaC templates (Terraform, CloudFormation, Kubernetes, etc.) for misconfigurations and security vulnerabilities before deployment.

## Prerequisites

### For IaC Scanning (Checkov)
- Python 3.7 or higher
- pip3

### For Local Deployment (Optional)
- Docker and Docker Compose
- Terraform CLI (>= 1.0)
- (Optional) AWS CLI for testing LocalStack resources

## Installation

The scan script will automatically install Checkov if not present, but you can also install it manually:

```bash
pip3 install checkov
```

## Demo Contents

This demo includes:

- **terraform/**: Sample Terraform configurations demonstrating security best practices
  - `main.tf`: AWS resources (S3, Security Groups, IAM) with LocalStack support
  - `variables.tf`: Configuration variables including LocalStack options
  - `outputs.tf`: Output values
- **config/**: Prisma Cloud configuration files
- **scan.sh**: Automated scanning script
- **local-deploy.sh**: Deploy Terraform to LocalStack (no AWS account needed)
- **local-cleanup.sh**: Clean up LocalStack deployment

## Running the Demo

### Option 1: Scan IaC with Checkov (No Cloud Resources Needed)

Simply run the provided script to scan for security issues:

```bash
cd prisma-cloud-demo
./scan.sh
```

This will:
1. Check if Checkov is installed (install if needed)
2. Scan all Terraform files in the terraform/ directory
3. Generate reports in multiple formats
4. Save results to scan-results/ directory

### Option 2: Deploy to LocalStack (Local Testing - **NEW!**)

Test your Terraform deployments locally without AWS credentials:

```bash
cd prisma-cloud-demo
./local-deploy.sh
```

This will:
1. Start LocalStack using Docker Compose
2. Initialize Terraform with LocalStack configuration
3. Deploy all resources to LocalStack (S3, IAM, Security Groups)
4. Show you how to interact with the deployed resources

**Benefits:**
- No AWS account or credentials required
- Free local testing
- Fast deployment and testing cycles
- Safe experimentation without cloud costs

**Cleanup after testing:**
```bash
./local-cleanup.sh
```

### Option 2: Manual Checkov Commands

Scan the Terraform directory:

```bash
checkov -d terraform/ --framework terraform
```

Scan with specific output format:

```bash
checkov -d terraform/ --framework terraform --output json
```

Scan and save results to a file:

```bash
checkov -d terraform/ --framework terraform --output json --output-file-path results.json
```

Scan with specific severity levels:

```bash
checkov -d terraform/ --framework terraform --check CRITICAL,HIGH
```

## Understanding the Results

Checkov will provide:
- **PASSED**: Checks that passed successfully
- **FAILED**: Security issues found
- **SKIPPED**: Checks that were skipped

Each failed check includes:
- Check ID (e.g., CKV_AWS_18)
- Resource name
- Description of the issue
- Severity level
- Remediation guidance

## Common Security Checks

This demo covers common cloud security checks:
- S3 bucket encryption
- S3 bucket versioning
- S3 public access blocking
- Security group rules
- IAM least privilege
- Resource tagging

## LocalStack Deployment Guide

### What is LocalStack?

LocalStack is a fully functional local cloud stack that emulates AWS services on your local machine. It allows you to:
- Test Terraform configurations without AWS credentials
- Develop and test cloud applications locally
- Avoid cloud costs during development
- Speed up your development workflow

### LocalStack Setup

The `local-deploy.sh` script handles everything automatically, but here's what happens:

1. **Start LocalStack**: Docker container starts with S3, EC2, IAM, and STS services
2. **Configure Terraform**: Terraform is configured to use LocalStack endpoints
3. **Deploy Resources**: All resources are created in LocalStack
4. **Verify Deployment**: You can interact with resources using AWS CLI or Terraform

### Manual LocalStack Commands

If you want more control, you can manually deploy:

```bash
# Start LocalStack
docker-compose up -d

# Wait for it to be ready
curl http://localhost:4566/_localstack/health

# Initialize Terraform
cd prisma-cloud-demo/terraform
terraform init

# Deploy with LocalStack
terraform apply -var="use_localstack=true"

# List S3 buckets in LocalStack
aws --endpoint-url=http://localhost:4566 s3 ls

# Destroy resources
terraform destroy -var="use_localstack=true"

# Stop LocalStack
cd ../..
docker-compose down
```

### Using with Real AWS

If you want to deploy to real AWS instead of LocalStack:

```bash
cd prisma-cloud-demo/terraform
terraform init
terraform apply -var="use_localstack=false"
```

Make sure you have AWS credentials configured before deploying to real AWS.

## Remediation

When issues are found:
1. Review the failed check details
2. Update the Terraform configuration
3. Re-run the scan to verify fixes
4. Commit the remediated code

## Integration Options

Checkov can be integrated into:
- **CI/CD Pipelines**: GitHub Actions, GitLab CI, Jenkins
- **Pre-commit Hooks**: Scan before committing code
- **IDE Plugins**: VS Code, IntelliJ
- **Prisma Cloud Platform**: Full enterprise features

## Additional Resources

- [Checkov Documentation](https://www.checkov.io/1.Welcome/What%20is%20Checkov.html)
- [Prisma Cloud Documentation](https://docs.paloaltonetworks.com/prisma/prisma-cloud)
- [Policy Reference](https://docs.bridgecrew.io/docs/aws-policy-index)

## Notes

⚠️ **Important**: This demo uses sample configurations. Do not deploy these resources to production without proper review and customization for your specific security requirements.

The sample Terraform configurations are designed to demonstrate security best practices but may need additional hardening for production use.

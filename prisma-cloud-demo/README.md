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
- No cloud credentials required!

## Installation

The scan script will automatically install Checkov if not present, but you can also install it manually:

```bash
pip3 install checkov
```

## Demo Contents

This demo includes:

- **terraform/**: Sample Terraform configurations demonstrating security best practices
  - `main.tf`: Local infrastructure resources (MinIO S3-compatible storage, simulated IAM and security rules)
  - `variables.tf`: Configuration variables for local services
  - `outputs.tf`: Output values
- **config/**: Prisma Cloud configuration files
- **scan.sh**: Automated scanning script
- **local-deploy.sh**: Deploy Terraform to MinIO (no cloud account needed)
- **local-cleanup.sh**: Clean up local deployment

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

### Option 2: Deploy to Local Services (100% Local Testing)

Test your Terraform deployments locally without any cloud credentials:

```bash
cd prisma-cloud-demo
./local-deploy.sh
```

This will:
1. Start MinIO (S3-compatible storage) using Docker Compose
2. Initialize Terraform with MinIO configuration
3. Deploy all resources to local services (S3 buckets, simulated IAM and security rules)
4. Show you how to interact with the deployed resources

**Benefits:**
- No cloud account or credentials required
- 100% free local testing
- Fast deployment and testing cycles
- Safe experimentation without any cloud costs
- Access MinIO web console to manage buckets

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

## Local Deployment Guide

### What is MinIO?

MinIO is a high-performance, S3-compatible object storage server that runs locally on your machine. It allows you to:
- Test Terraform configurations without any cloud credentials
- Develop and test storage applications locally
- No cloud costs - 100% free local testing
- Fast local development workflow
- Web console for easy bucket management

### Local Setup

The `local-deploy.sh` script handles everything automatically, but here's what happens:

1. **Start MinIO**: Docker container starts with S3-compatible storage
2. **Configure Terraform**: Terraform is configured to use MinIO endpoints
3. **Deploy Resources**: All resources are created in local services
4. **Verify Deployment**: You can interact with resources using MinIO console or Terraform

### Manual Deployment Commands

If you want more control, you can manually deploy:

```bash
# Start MinIO
docker-compose up -d

# Wait for it to be ready
curl http://localhost:9000/minio/health/live

# Initialize Terraform
cd prisma-cloud-demo/terraform
terraform init

# Deploy to local services
terraform apply

# Access MinIO Console
# Open browser to http://localhost:9001
# Login with: minioadmin / minioadmin

# Destroy resources
terraform destroy

# Stop MinIO
cd ../..
docker-compose down
```

### MinIO Console Access

Access the MinIO web console to manage your buckets:
- URL: http://localhost:9001
- Username: minioadmin
- Password: minioadmin

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
- [MinIO Documentation](https://min.io/docs/minio/linux/index.html)
- [Policy Reference](https://docs.bridgecrew.io/docs/aws-policy-index)

## Notes

⚠️ **Important**: This demo uses sample configurations. Do not deploy these resources to production without proper review and customization for your specific security requirements.

The sample Terraform configurations are designed to demonstrate security best practices but may need additional hardening for production use.

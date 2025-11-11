# Prisma Cloud Demo

This demo shows how to use Prisma Cloud (via Checkov CLI) to scan Infrastructure as Code (IaC) for security vulnerabilities and compliance issues.

## What is Prisma Cloud?

Prisma Cloud is a comprehensive cloud security platform that helps organizations secure their cloud infrastructure throughout the development lifecycle. It scans IaC templates (Terraform, CloudFormation, Kubernetes, etc.) for misconfigurations and security vulnerabilities before deployment.

## Prerequisites

- Python 3.7 or higher
- pip3
- (Optional) AWS CLI configured if you plan to deploy the resources

## Installation

The scan script will automatically install Checkov if not present, but you can also install it manually:

```bash
pip3 install checkov
```

## Demo Contents

This demo includes:

- **terraform/**: Sample Terraform configurations demonstrating security best practices
  - `main.tf`: AWS resources (S3, Security Groups, IAM)
  - `variables.tf`: Configuration variables
  - `outputs.tf`: Output values
- **config/**: Prisma Cloud configuration files
- **scan.sh**: Automated scanning script

## Running the Demo

### Option 1: Using the Scan Script (Recommended)

Simply run the provided script:

```bash
cd prisma-cloud-demo
./scan.sh
```

This will:
1. Check if Checkov is installed (install if needed)
2. Scan all Terraform files in the terraform/ directory
3. Generate reports in multiple formats
4. Save results to scan-results/ directory

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

# Platform-Testing-Demo

> 🆕 **NEW!** Now with LocalStack support - Test cloud infrastructure locally without AWS credentials! [Quick Start →](QUICKSTART-LOCAL.md)

This repository contains demo setups for cloud security and compliance testing tools. Each demo is self-contained with its own README and executable samples.

## Demos Included

### 1. Prisma Cloud Demo
Location: `prisma-cloud-demo/`

Demonstrates Infrastructure as Code (IaC) security scanning using Prisma Cloud (Checkov CLI). Scan Terraform configurations for security vulnerabilities and compliance issues before deployment.

**Features:**
- Sample Terraform configurations with security best practices
- Automated scanning script
- Multiple output formats (CLI, JSON)
- **LocalStack support for local deployment without AWS credentials**
- Test Terraform deployments locally using Docker

[📖 Read the Prisma Cloud Demo README](prisma-cloud-demo/README.md)

**Quick Start (Scanning Only):**
```bash
cd prisma-cloud-demo
./scan.sh
```

**Quick Start (Local Deployment):**
```bash
cd prisma-cloud-demo
./local-deploy.sh  # No AWS account needed!
```

### 2. InSpec Demo
Location: `inspec-demo/`

Demonstrates cloud infrastructure testing and compliance auditing using Chef InSpec. Test cloud resources for security and compliance with industry standards.

**Features:**
- Comprehensive security baseline profiles
- S3, IAM, and Security Groups tests
- **LocalStack support for local testing without AWS credentials**
- Automated test execution scripts
- Multiple report formats (CLI, JSON, HTML)

[📖 Read the InSpec Demo README](inspec-demo/README.md)

**Quick Start (Local Testing - No AWS Needed!):**
```bash
cd inspec-demo
./local-test.sh
# See inspec-demo/LOCAL-TESTING.md for detailed guide
```

**Quick Start (AWS Testing):**
```bash
cd inspec-demo
./run-tests.sh
```

## What These Tools Do

### Prisma Cloud (Checkov)
- **Purpose**: Static analysis of Infrastructure as Code
- **When to use**: Before deploying infrastructure (shift-left security)
- **What it tests**: Configuration files (Terraform, CloudFormation, Kubernetes)
- **Output**: Security issues and misconfigurations in your IaC templates

### InSpec
- **Purpose**: Dynamic testing of deployed cloud infrastructure
- **When to use**: After infrastructure is deployed (continuous compliance)
- **What it tests**: Live cloud resources via APIs
- **Output**: Compliance status of your actual cloud environment

## Usage Comparison

| Aspect | Prisma Cloud (Checkov) | InSpec |
|--------|------------------------|---------|
| **Testing Phase** | Pre-deployment (Static) | Post-deployment (Dynamic) |
| **Target** | IaC files | Live infrastructure |
| **Installation** | `pip install checkov` | Platform-specific installer |
| **AWS Credentials** | Not required for scanning | Not required (use LocalStack) |
| **Local Testing** | ✅ Yes (with LocalStack) | ✅ Yes (with LocalStack) |
| **Execution Time** | Fast (seconds) | Moderate (API calls) |
| **Best For** | Catching issues early | Compliance auditing |

## Recommended Workflow

1. **Development Phase**: Use Prisma Cloud to scan IaC templates
2. **Local Testing**: Deploy to LocalStack to test infrastructure locally (no cloud costs!)
3. **Pre-commit**: Integrate Checkov in git hooks or IDE
4. **CI/CD Pipeline**: Run Checkov on pull requests
5. **Post-deployment**: Use InSpec for compliance testing
6. **Continuous Monitoring**: Schedule InSpec tests regularly

## LocalStack - Local Cloud Testing

**NEW:** This repository now supports LocalStack for local cloud testing without requiring AWS credentials!

### What is LocalStack?

LocalStack provides a fully functional local AWS cloud stack, allowing you to:
- Test Terraform configurations locally
- Develop without cloud costs
- Avoid AWS credential requirements
- Speed up development cycles

### Quick Start with LocalStack

```bash
# Start the Prisma Cloud demo with LocalStack
cd prisma-cloud-demo
./local-deploy.sh

# Clean up when done
./local-cleanup.sh
```

### Requirements
- Docker and Docker Compose installed
- Terraform CLI installed
- No AWS account or credentials needed!

## Prerequisites

### For Prisma Cloud Demo
- **For Scanning**: Python 3.7+ and pip3
- **For Local Deployment**: Docker, Docker Compose, and Terraform (no AWS account needed!)

### For InSpec Demo
- **For Local Testing**: InSpec CLI, Docker, Docker Compose, and Terraform (no AWS account needed!)
- **For AWS Testing**: InSpec CLI, AWS credentials configured, and AWS account access

## Getting Started

### 🎯 Quick Start with Local Testing (Recommended - No AWS Needed!)

Want to test immediately without AWS credentials? Start here:

**Prisma Cloud Demo (IaC Security Scanning + Local Deployment):**
```bash
cd prisma-cloud-demo
./local-deploy.sh
```

**InSpec Demo (Infrastructure Testing):**
```bash
cd inspec-demo
./local-test.sh
```

**📖 See [QUICKSTART-LOCAL.md](QUICKSTART-LOCAL.md) for the fastest way to get started!**

**📚 See [LOCAL-TESTING-GUIDE.md](LOCAL-TESTING-GUIDE.md) for comprehensive local testing documentation.**

### Quick Start with Interactive Script

Run the interactive quick-start script:

```bash
./quick-start.sh
```

This will guide you through choosing and running either demo.

### Manual Setup

1. Clone this repository
2. Choose a demo (Prisma Cloud or InSpec)
3. Navigate to the demo directory
4. Read the demo-specific README
5. Run the provided scripts

## Integration Examples

Both tools can be integrated into:
- CI/CD pipelines (GitHub Actions, GitLab CI, Jenkins)
- Pre-commit hooks
- IDE plugins
- Security dashboards

## Additional Resources

- [Prisma Cloud Documentation](https://docs.paloaltonetworks.com/prisma/prisma-cloud)
- [Checkov Documentation](https://www.checkov.io/)
- [InSpec Documentation](https://docs.chef.io/inspec/)
- [AWS Security Best Practices](https://aws.amazon.com/security/best-practices/)

## Contributing

Feel free to add more examples, improve documentation, or extend the test coverage.

## License

This demo repository is provided as-is for educational and testing purposes.

## Notes

⚠️ **Important**: 
- These are demo configurations for learning purposes
- Do not deploy sample configurations to production without review
- InSpec tests are read-only and safe to run
- Always review and customize for your specific requirements
# Platform-Testing-Demo

This repository contains demo setups for cloud security and compliance testing tools. Each demo is self-contained with its own README and executable samples.

## Demos Included

### 1. Prisma Cloud Demo
Location: `prisma-cloud-demo/`

Demonstrates Infrastructure as Code (IaC) security scanning using Prisma Cloud (Checkov CLI). Scan Terraform configurations for security vulnerabilities and compliance issues before deployment.

**Features:**
- Sample Terraform configurations with security best practices
- Automated scanning script
- Multiple output formats (CLI, JSON)
- Configuration examples

[📖 Read the Prisma Cloud Demo README](prisma-cloud-demo/README.md)

**Quick Start:**
```bash
cd prisma-cloud-demo
./scan.sh
```

### 2. InSpec Demo
Location: `inspec-demo/`

Demonstrates cloud infrastructure testing and compliance auditing using Chef InSpec. Test AWS resources for security and compliance with industry standards.

**Features:**
- Comprehensive AWS security baseline profile
- S3, IAM, Security Groups, and CloudTrail tests
- Automated test execution script
- Multiple report formats (CLI, JSON, HTML)

[📖 Read the InSpec Demo README](inspec-demo/README.md)

**Quick Start:**
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
| **AWS Credentials** | Not required | Required |
| **Execution Time** | Fast (seconds) | Moderate (API calls) |
| **Best For** | Catching issues early | Compliance auditing |

## Recommended Workflow

1. **Development Phase**: Use Prisma Cloud to scan IaC templates
2. **Pre-commit**: Integrate Checkov in git hooks or IDE
3. **CI/CD Pipeline**: Run Checkov on pull requests
4. **Post-deployment**: Use InSpec for compliance testing
5. **Continuous Monitoring**: Schedule InSpec tests regularly

## Prerequisites

### For Prisma Cloud Demo
- Python 3.7+
- pip3

### For InSpec Demo
- InSpec CLI
- AWS credentials configured
- AWS account access

## Getting Started

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
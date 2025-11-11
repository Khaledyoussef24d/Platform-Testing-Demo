# InSpec Demo

This demo shows how to use Chef InSpec to test and audit AWS cloud infrastructure for security and compliance.

## What is InSpec?

Chef InSpec is an open-source testing framework for infrastructure with a human-readable language for specifying compliance, security, and policy requirements. It can audit cloud infrastructure, detect security issues, and ensure compliance with security policies.

## Prerequisites

- InSpec installed (see installation instructions below)
- AWS account with credentials configured
- AWS CLI (optional, but recommended)
- Ruby 3.0+ (for gem installation method)

## Installation

### Option 1: Using the Official Installer (Recommended)

**macOS/Linux:**
```bash
curl https://omnitruck.chef.io/install.sh | sudo bash -s -- -P inspec
```

**Windows (PowerShell as Administrator):**
```powershell
. { iwr -useb https://omnitruck.chef.io/install.ps1 } | iex; install -project inspec
```

### Option 2: Using Ruby Gem

```bash
gem install inspec-bin
```

### Option 3: Using Package Managers

**macOS (Homebrew):**
```bash
brew install --cask chef/chef/inspec
```

**Ubuntu/Debian:**
```bash
wget https://packages.chef.io/files/stable/inspec/5.22.3/ubuntu/20.04/inspec_5.22.3-1_amd64.deb
sudo dpkg -i inspec_5.22.3-1_amd64.deb
```

## AWS Credentials Setup

InSpec needs AWS credentials to test your cloud infrastructure:

### Option 1: Environment Variables
```bash
export AWS_ACCESS_KEY_ID=your_access_key
export AWS_SECRET_ACCESS_KEY=your_secret_key
export AWS_REGION=us-east-1
```

### Option 2: AWS Profile
```bash
export AWS_PROFILE=your_profile_name
```

### Option 3: AWS CLI Configuration
```bash
aws configure
```

## Demo Contents

This demo includes:

- **profiles/aws-security-baseline/**: InSpec profile for AWS security testing
  - `inspec.yml`: Profile metadata and configuration
  - `controls/s3_buckets.rb`: S3 bucket security tests
  - `controls/security_groups.rb`: Security group compliance tests
  - `controls/iam.rb`: IAM security and best practices tests
  - `controls/cloudtrail.rb`: CloudTrail logging and audit tests
- **run-tests.sh**: Automated test execution script

## Running the Demo

### Option 1: Using the Test Script (Recommended)

Simply run the provided script:

```bash
cd inspec-demo
./run-tests.sh
```

This will:
1. Check if InSpec is installed
2. Verify AWS credentials
3. Run all security tests
4. Generate reports in multiple formats
5. Save results to test-results/ directory

### Option 2: Manual InSpec Commands

**Check the profile structure:**
```bash
inspec check profiles/aws-security-baseline/
```

**Run tests against AWS:**
```bash
inspec exec profiles/aws-security-baseline/ -t aws://
```

**Run with specific region:**
```bash
inspec exec profiles/aws-security-baseline/ -t aws://us-west-2
```

**Generate JSON output:**
```bash
inspec exec profiles/aws-security-baseline/ -t aws:// --reporter json:results.json
```

**Generate HTML report:**
```bash
inspec exec profiles/aws-security-baseline/ -t aws:// --reporter html:report.html
```

**Run specific controls:**
```bash
inspec exec profiles/aws-security-baseline/ -t aws:// --controls s3-bucket-encryption
```

**Run with custom inputs:**
```bash
inspec exec profiles/aws-security-baseline/ -t aws:// --input aws_region=us-west-2
```

## Understanding the Results

InSpec provides clear test results:
- ✓ **Passed**: Test requirements met
- ✗ **Failed**: Security issues or non-compliance found
- ⊘ **Skipped**: Test was skipped

Each result includes:
- Control ID
- Control title and description
- Expected vs. actual values
- Impact level (0.0 to 1.0)

## Security Controls Included

This demo covers:

### S3 Bucket Security
- Encryption enabled
- Versioning enabled
- Public access blocked
- SSL/TLS enforcement
- Access logging

### Security Groups
- No unrestricted SSH access
- No unrestricted RDP access
- No unrestricted database access
- Proper descriptions
- Default security group restrictions

### IAM Security
- Root account protection
- MFA enforcement
- Strong password policy
- Access key rotation
- Least privilege principle

### CloudTrail
- Multi-region trails enabled
- Log file validation
- Encryption at rest
- CloudWatch integration

## Remediation Workflow

When tests fail:

1. **Review the failure details** in the test output
2. **Identify the affected resource** (e.g., specific S3 bucket or security group)
3. **Apply the recommended fix** in your AWS console or IaC
4. **Re-run the tests** to verify compliance
5. **Document the changes** for audit purposes

## Integration Options

InSpec can be integrated with:
- **CI/CD Pipelines**: Jenkins, GitLab CI, GitHub Actions
- **Configuration Management**: Chef, Ansible
- **Cloud Platforms**: AWS Systems Manager, Azure Policy
- **Compliance Frameworks**: CIS Benchmarks, PCI-DSS, HIPAA

## Example CI/CD Integration

### GitHub Actions
```yaml
name: InSpec Security Scan
on: [push]
jobs:
  security-scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Run InSpec
        run: |
          curl https://omnitruck.chef.io/install.sh | sudo bash -s -- -P inspec
          inspec exec profiles/aws-security-baseline/ -t aws://
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
```

## Customization

You can customize the profile by:

1. **Modifying controls**: Edit files in `controls/` directory
2. **Adding new controls**: Create new `.rb` files in `controls/`
3. **Adjusting inputs**: Update values in `inspec.yml` or pass via CLI
4. **Changing thresholds**: Modify impact levels (0.0-1.0)

## Additional Resources

- [InSpec Documentation](https://docs.chef.io/inspec/)
- [InSpec AWS Resource Pack](https://docs.chef.io/inspec/resources/#aws-resources)
- [InSpec Profile Repository](https://github.com/inspec/inspec-aws)
- [CIS AWS Foundations Benchmark](https://www.cisecurity.org/benchmark/amazon_web_services)

## Troubleshooting

### "InSpec command not found"
- Ensure InSpec is installed and in your PATH
- Try running with full path: `/opt/inspec/bin/inspec`

### "AWS credentials not configured"
- Verify environment variables are set
- Check AWS CLI configuration: `aws configure list`
- Test AWS access: `aws sts get-caller-identity`

### "Permission denied" errors
- Ensure your AWS credentials have read permissions
- Required permissions: EC2, S3, IAM, CloudTrail (read-only)

### Tests taking too long
- Run specific controls instead of the entire profile
- Use `--controls` flag to target specific tests
- Consider running tests in parallel regions

## Notes

⚠️ **Important**: 
- This demo runs read-only tests against your AWS account
- No changes will be made to your infrastructure
- Ensure you have appropriate AWS permissions before running tests
- Some tests may incur minimal AWS API costs

The InSpec profile is designed to test real AWS resources. You can run it against a test/dev environment first before using in production.

## Support

For issues or questions:
- InSpec Community: https://community.chef.io/
- InSpec GitHub: https://github.com/inspec/inspec
- AWS Documentation: https://aws.amazon.com/documentation/

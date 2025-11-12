# InSpec Local Testing Guide

This guide explains how to use InSpec to test infrastructure locally using LocalStack, without requiring AWS credentials or incurring any cloud costs.

## What You'll Test

The InSpec local baseline profile tests:
- **S3 Buckets**: Encryption, versioning, and public access controls
- **Security Groups**: Port restrictions and security rules
- **IAM Roles**: Least privilege and policy management

All tests run against LocalStack, a local AWS cloud emulator.

## Prerequisites

Before you begin, ensure you have:

1. **InSpec** - [Install InSpec](https://docs.chef.io/inspec/install/)
2. **Docker** - [Install Docker](https://docs.docker.com/get-docker/)
3. **Docker Compose** - Usually included with Docker Desktop
4. **Terraform** (>= 1.0) - [Install Terraform](https://www.terraform.io/downloads)

## Quick Start

### 1. Run Local Tests

```bash
cd inspec-demo
./local-test.sh
```

This script will:
1. ✅ Check prerequisites (InSpec, Docker, Terraform)
2. 🚀 Start LocalStack container
3. ⏳ Wait for LocalStack to be ready
4. 📦 Deploy test infrastructure to LocalStack
5. 🧪 Run InSpec security compliance tests
6. 📊 Generate test reports

### 2. View Results

The script generates multiple outputs:

**Console Output**: See immediate results in your terminal

**JSON Report**: Detailed machine-readable results
```bash
cat test-results/results.json | jq
```

**HTML Report** (optional): Generate a visual report
```bash
cd inspec-demo
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1
export AWS_ENDPOINT_URL=http://localhost:4566

inspec exec profiles/local-baseline/ -t aws:// --reporter html:test-results/report.html
```

### 3. Clean Up

When you're done testing:

```bash
cd inspec-demo
./local-cleanup.sh
```

This will:
- Destroy all test infrastructure
- Stop the LocalStack container
- Clean up resources

## Manual Testing Workflow

If you prefer more control, you can run commands manually:

### Step 1: Start LocalStack

```bash
# From the repository root
docker compose up -d localstack

# Wait for LocalStack to be ready
curl http://localhost:4566/_localstack/health
```

### Step 2: Deploy Test Infrastructure

```bash
cd prisma-cloud-demo/terraform

# Initialize Terraform (first time only)
terraform init

# Deploy infrastructure to LocalStack
terraform apply -var="use_localstack=true" -auto-approve
```

### Step 3: Configure Environment

```bash
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1
export AWS_ENDPOINT_URL=http://localhost:4566
```

### Step 4: Run InSpec Tests

```bash
cd ../../inspec-demo

# Run tests against LocalStack
inspec exec profiles/local-baseline/ -t aws://

# Generate JSON output
inspec exec profiles/local-baseline/ -t aws:// --reporter json:test-results/results.json

# Generate HTML report
inspec exec profiles/local-baseline/ -t aws:// --reporter html:test-results/report.html
```

### Step 5: Clean Up

```bash
# Destroy infrastructure
cd ../prisma-cloud-demo/terraform
terraform destroy -var="use_localstack=true" -auto-approve

# Stop LocalStack
cd ../..
docker compose down
```

## Understanding Test Results

InSpec provides clear test results with the following indicators:

- ✓ **Passed** (Green): Test requirements met, infrastructure is compliant
- ✗ **Failed** (Red): Security issues or non-compliance found, needs attention
- ⊘ **Skipped** (Yellow): Test was skipped (e.g., no resources to test)

Each result includes:
- **Control ID**: Unique identifier for the test
- **Title**: Human-readable description
- **Description**: What the test checks and why it matters
- **Impact**: Severity level (0.0 to 1.0)
- **Status**: Pass/Fail/Skip with details

### Example Output

```
Profile: Local Infrastructure Baseline Profile (local-baseline)
Version: 1.0.0
Target:  aws://us-east-1

  ✔  s3-bucket-encryption: Ensure S3 buckets have encryption enabled
     ✔  aws_s3_bucket my-secure-bucket should have default encryption enabled
     
  ✗  sg-no-unrestricted-ssh: Ensure security groups do not allow unrestricted SSH access (1 failed)
     ✗  aws_security_group sg-123456 should not allow in {:port=>22, :ipv4_range=>"0.0.0.0/0"}
     expected `aws_security_group allow in {:port=>22, :ipv4_range=>"0.0.0.0/0"}` to return false, got true

Profile Summary: 8 successful controls, 1 control failure, 2 controls skipped
Test Summary: 15 successful, 1 failure, 2 skipped
```

## Customizing Tests

### Modify Existing Controls

Edit control files in `profiles/local-baseline/controls/`:
- `s3_buckets.rb`: S3 bucket security tests
- `security_groups.rb`: Security group compliance tests
- `iam.rb`: IAM security tests

### Add New Controls

Create a new `.rb` file in `profiles/local-baseline/controls/`:

```ruby
# profiles/local-baseline/controls/custom.rb

title 'Custom Security Controls'

control 'custom-check-1' do
  impact 0.8
  title 'My custom security check'
  desc 'Description of what this checks'
  
  describe aws_s3_bucket(bucket_name: 'my-bucket') do
    it { should exist }
  end
end
```

### Adjust Test Parameters

Edit `profiles/local-baseline/inspec.yml` to change inputs:

```yaml
inputs:
  - name: aws_region
    type: String
    value: us-east-1
    description: AWS region to test
```

## Troubleshooting

### InSpec not found

```bash
# Install InSpec using the official installer
curl https://omnitruck.chef.io/install.sh | sudo bash -s -- -P inspec

# Or using Ruby gem
gem install inspec-bin
```

### LocalStack not starting

```bash
# Check Docker is running
docker ps

# Check LocalStack logs
docker logs localstack-demo

# Restart LocalStack
docker compose restart localstack
```

### Connection refused errors

```bash
# Verify LocalStack is ready
curl http://localhost:4566/_localstack/health

# Check the endpoint is accessible
curl http://localhost:4566

# Ensure environment variables are set
echo $AWS_ENDPOINT_URL
```

### No resources found

This is normal if test infrastructure hasn't been deployed:

```bash
# Deploy test infrastructure
cd prisma-cloud-demo/terraform
terraform apply -var="use_localstack=true" -auto-approve
```

### Tests fail with authentication errors

Make sure you've set the test credentials:

```bash
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1
export AWS_ENDPOINT_URL=http://localhost:4566
```

## Differences from AWS Testing

### Local Testing (LocalStack)
- ✅ No AWS account needed
- ✅ No credentials required
- ✅ No cloud costs
- ✅ Fast iteration
- ✅ Safe experimentation
- ⚠️ Limited AWS service support
- ⚠️ Some features may behave differently

### AWS Testing
- ✅ Full AWS service support
- ✅ Production-ready testing
- ✅ Accurate service behavior
- ⚠️ Requires AWS account
- ⚠️ Requires credentials
- ⚠️ May incur costs
- ⚠️ Changes affect real resources

## Benefits of Local Testing

### 1. Cost Savings
- Zero AWS charges during development
- Test as much as you want
- No accidental resource costs

### 2. Speed
- Instant resource creation
- No internet latency
- Faster feedback loops

### 3. Safety
- Can't affect production
- Safe to experiment
- Easy to reset and restart

### 4. Convenience
- Works offline (after initial setup)
- No credential management
- No AWS account required

### 5. CI/CD Integration
- Easy to integrate into pipelines
- Consistent test environments
- Parallel test execution

## Advanced Usage

### Run Specific Controls

```bash
inspec exec profiles/local-baseline/ -t aws:// --controls s3-bucket-encryption
```

### Run with Custom Inputs

```bash
inspec exec profiles/local-baseline/ -t aws:// --input aws_region=us-west-2
```

### Generate Multiple Reports

```bash
inspec exec profiles/local-baseline/ -t aws:// \
  --reporter cli \
  --reporter json:results.json \
  --reporter html:report.html
```

### Test Against Different Environments

```bash
# Local testing
export AWS_ENDPOINT_URL=http://localhost:4566
inspec exec profiles/local-baseline/ -t aws://

# AWS testing (requires real credentials)
unset AWS_ENDPOINT_URL
inspec exec profiles/aws-security-baseline/ -t aws://
```

## Next Steps

1. **Experiment**: Modify controls and test infrastructure
2. **Learn**: Practice InSpec without fear of cloud costs
3. **Integrate**: Add InSpec testing to your CI/CD pipeline
4. **Expand**: Create custom controls for your specific needs
5. **Graduate**: Move to AWS testing when ready for production

## Resources

- [InSpec Documentation](https://docs.chef.io/inspec/)
- [InSpec AWS Resources](https://docs.chef.io/inspec/resources/#aws-resources)
- [LocalStack Documentation](https://docs.localstack.cloud/)
- [Repository Main README](../README.md)
- [Local Testing Guide](../LOCAL-TESTING-GUIDE.md)

## Support

For issues or questions:
- InSpec: https://github.com/inspec/inspec/issues
- LocalStack: https://github.com/localstack/localstack/issues
- This Demo: Open an issue in this repository

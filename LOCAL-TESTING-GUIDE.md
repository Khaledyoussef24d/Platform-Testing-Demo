# Local Cloud Testing Guide

This guide explains how to test cloud infrastructure locally using LocalStack without needing AWS credentials or incurring cloud costs.

## What's New?

The Terraform configurations in this repository now support **LocalStack**, a fully functional local AWS cloud stack. This means you can:

✅ Deploy and test Terraform configurations locally  
✅ No AWS account or credentials required  
✅ Zero cloud costs  
✅ Fast iteration cycles  
✅ Safe experimentation environment  

## Prerequisites

Before you begin, ensure you have:

1. **Docker** - [Install Docker](https://docs.docker.com/get-docker/)
2. **Docker Compose** - Usually included with Docker Desktop
3. **Terraform** (>= 1.0) - [Install Terraform](https://www.terraform.io/downloads)
4. (Optional) **AWS CLI** - For interacting with LocalStack resources

## Quick Start

### Option 1: Prisma Cloud Demo (IaC Scanning + Deployment)

```bash
cd prisma-cloud-demo
./local-deploy.sh
```

This script will:
1. ✅ Check prerequisites (Docker, Terraform)
2. 🚀 Start LocalStack container
3. ⏳ Wait for LocalStack to be ready
4. 📦 Initialize Terraform
5. 🎯 Deploy all resources to LocalStack
6. ✅ Show deployment status

### Option 2: InSpec Demo (Infrastructure Testing)

```bash
cd inspec-demo
./local-test.sh
```

This script will:
1. ✅ Check prerequisites (InSpec, Docker, Terraform)
2. 🚀 Start LocalStack container
3. 📦 Deploy test infrastructure to LocalStack
4. 🧪 Run InSpec security compliance tests
5. 📊 Generate test reports

### Interact with Deployed Resources

After deployment, you can interact with the resources:

```bash
# List S3 buckets
aws --endpoint-url=http://localhost:4566 s3 ls

# List IAM roles
aws --endpoint-url=http://localhost:4566 iam list-roles

# Describe security groups
aws --endpoint-url=http://localhost:4566 ec2 describe-security-groups

# View Terraform state
cd prisma-cloud-demo/terraform
terraform show
```

### Clean Up

When you're done testing:

**For Prisma Cloud Demo:**
```bash
cd prisma-cloud-demo
./local-cleanup.sh
```

**For InSpec Demo:**
```bash
cd inspec-demo
./local-cleanup.sh
```

This will destroy all resources and stop LocalStack.

## Manual Workflow

If you prefer more control, you can run commands manually:

### Step 1: Start LocalStack

```bash
# From the repository root
docker-compose up -d

# Check LocalStack health
curl http://localhost:4566/_localstack/health
```

### Step 2: Deploy with Terraform

```bash
cd prisma-cloud-demo/terraform

# Initialize Terraform
terraform init

# Plan deployment (review changes)
terraform plan -var="use_localstack=true"

# Apply deployment
terraform apply -var="use_localstack=true" -auto-approve
```

### Step 3: Test Your Resources

```bash
# Set endpoint for AWS CLI
export AWS_ENDPOINT=http://localhost:4566

# List resources
aws --endpoint-url=$AWS_ENDPOINT s3 ls
aws --endpoint-url=$AWS_ENDPOINT iam list-roles

# Test S3 bucket
aws --endpoint-url=$AWS_ENDPOINT s3 mb s3://test-bucket
aws --endpoint-url=$AWS_ENDPOINT s3 ls
```

### Step 4: Destroy Resources

```bash
# From terraform directory
terraform destroy -var="use_localstack=true" -auto-approve

# Stop LocalStack
cd ../..
docker-compose down
```

## Switching Between LocalStack and AWS

The Terraform configuration supports both LocalStack and real AWS:

### Using LocalStack (Default)

```bash
terraform apply -var="use_localstack=true"
```

### Using Real AWS

```bash
# Make sure AWS credentials are configured
export AWS_ACCESS_KEY_ID="your-key"
export AWS_SECRET_ACCESS_KEY="your-secret"

# Deploy to real AWS
terraform apply -var="use_localstack=false"
```

## Troubleshooting

### LocalStack not starting

```bash
# Check Docker is running
docker ps

# Check LocalStack logs
docker logs localstack-demo

# Restart LocalStack
docker-compose restart localstack
```

### Terraform connection issues

```bash
# Verify LocalStack is ready
curl http://localhost:4566/_localstack/health

# Check endpoints are accessible
curl http://localhost:4566

# Ensure no firewall is blocking port 4566
```

### Resources not being created

```bash
# Check Terraform state
terraform show

# Enable debug logging
export TF_LOG=DEBUG
terraform apply -var="use_localstack=true"

# Check LocalStack logs for errors
docker logs localstack-demo
```

### "Credentials not found" error

This usually means the `use_localstack` variable is not set:

```bash
# Always specify use_localstack when working with LocalStack
terraform apply -var="use_localstack=true"

# Or create terraform.tfvars file:
echo 'use_localstack = true' > terraform.tfvars
terraform apply
```

## LocalStack Features

LocalStack emulates the following AWS services used in this demo:

- **S3** - Object storage
- **EC2** - Security groups and VPC resources
- **IAM** - Identity and Access Management
- **STS** - Security Token Service

For more information, visit [LocalStack Documentation](https://docs.localstack.cloud/).

## Benefits of Local Testing

### 1. Cost Savings
- No AWS charges during development
- Test as much as you want without worrying about costs
- Avoid accidental resource creation in production

### 2. Speed
- Instant resource creation
- No internet latency
- Faster iteration cycles

### 3. Safety
- Can't accidentally modify production resources
- Safe to experiment and learn
- Easy to reset and start fresh

### 4. Convenience
- No AWS account required
- No credential management
- Works offline (after initial Docker image pull)

### 5. CI/CD Integration
- Easy to integrate into CI/CD pipelines
- Consistent testing environment
- Parallel test execution without conflicts

## Integration with Testing Tools

### Checkov (IaC Security Scanning)

```bash
# Scan before deploying
cd prisma-cloud-demo
./scan.sh

# Fix issues, then deploy locally to test
./local-deploy.sh
```

### InSpec (Infrastructure Testing)

InSpec can now test against LocalStack infrastructure:

```bash
# Quick start - automated
cd inspec-demo
./local-test.sh

# Or manually configure and test
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1
export AWS_ENDPOINT_URL=http://localhost:4566

inspec exec profiles/local-baseline/ -t aws://
```

## Next Steps

1. **Experiment**: Try modifying the Terraform files and redeploy
2. **Test Security**: Use Checkov to scan for security issues
3. **Learn**: Practice Terraform without fear of cloud costs
4. **Integrate**: Add LocalStack testing to your CI/CD pipeline

## Resources

- [LocalStack Documentation](https://docs.localstack.cloud/)
- [Terraform Documentation](https://www.terraform.io/docs)
- [AWS CLI with LocalStack](https://docs.localstack.cloud/user-guide/integrations/aws-cli/)
- [This Repository's README](README.md)

## Support

For issues or questions:
- LocalStack: https://github.com/localstack/localstack/issues
- Terraform: https://github.com/hashicorp/terraform/issues
- This Demo: Open an issue in this repository

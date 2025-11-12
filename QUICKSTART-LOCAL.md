# Quick Start: Local Cloud Testing (No AWS Account Needed!)

Test cloud infrastructure locally without AWS credentials or costs using LocalStack.

## 🚀 One-Command Setup

### Option 1: Prisma Cloud Demo (IaC Scanning + Deployment)

```bash
cd prisma-cloud-demo
./local-deploy.sh
```

That's it! This will:
- Start LocalStack (local AWS emulator)
- Deploy all Terraform resources locally
- Show you how to interact with them

### Option 2: InSpec Demo (Infrastructure Testing)

```bash
cd inspec-demo
./local-test.sh
```

This will:
- Start LocalStack (local AWS emulator)
- Deploy test infrastructure
- Run InSpec security compliance tests
- Generate test reports

## 🧹 Cleanup

**For Prisma Cloud:**
```bash
cd prisma-cloud-demo
./local-cleanup.sh
```

**For InSpec:**
```bash
cd inspec-demo
./local-cleanup.sh
```

## 📋 Prerequisites

- Docker
- Docker Compose  
- Terraform
- InSpec (only for InSpec demo)

## 📚 Learn More

See [LOCAL-TESTING-GUIDE.md](LOCAL-TESTING-GUIDE.md) for detailed instructions and troubleshooting.

## ✅ What Gets Deployed Locally?

- S3 buckets (with encryption, versioning)
- Security groups
- IAM roles and policies
- All without touching AWS!

## 🔍 Next Steps

### For Prisma Cloud Demo:
1. **Scan for security issues**: `cd prisma-cloud-demo && ./scan.sh`
2. **Deploy locally**: `./local-deploy.sh`
3. **Test resources**: `aws --endpoint-url=http://localhost:4566 s3 ls`
4. **Clean up**: `./local-cleanup.sh`

### For InSpec Demo:
1. **Run compliance tests**: `cd inspec-demo && ./local-test.sh`
2. **View results**: `cat test-results/results.json | jq`
3. **Generate HTML report**: `inspec exec profiles/local-baseline/ -t aws:// --reporter html:test-results/report.html`
4. **Clean up**: `./local-cleanup.sh`

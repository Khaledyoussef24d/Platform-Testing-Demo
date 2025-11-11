# Quick Start: Local Cloud Testing (No AWS Account Needed!)

Test cloud infrastructure locally without AWS credentials or costs using LocalStack.

## 🚀 One-Command Setup

```bash
cd prisma-cloud-demo
./local-deploy.sh
```

That's it! This will:
- Start LocalStack (local AWS emulator)
- Deploy all Terraform resources locally
- Show you how to interact with them

## 🧹 Cleanup

```bash
cd prisma-cloud-demo
./local-cleanup.sh
```

## 📋 Prerequisites

- Docker
- Docker Compose  
- Terraform

## 📚 Learn More

See [LOCAL-TESTING-GUIDE.md](LOCAL-TESTING-GUIDE.md) for detailed instructions and troubleshooting.

## ✅ What Gets Deployed Locally?

- S3 buckets (with encryption, versioning)
- Security groups
- IAM roles and policies
- All without touching AWS!

## 🔍 Next Steps

1. **Scan for security issues**: `cd prisma-cloud-demo && ./scan.sh`
2. **Deploy locally**: `./local-deploy.sh`
3. **Test resources**: `aws --endpoint-url=http://localhost:4566 s3 ls`
4. **Clean up**: `./local-cleanup.sh`

# Quick Start: 100% Local Testing (No Cloud Credentials Needed!)

Test infrastructure locally without any cloud credentials or costs using MinIO and local services.

## 🚀 One-Command Setup

### Option 1: Prisma Cloud Demo (IaC Scanning + Deployment)

```bash
cd prisma-cloud-demo
./local-deploy.sh
```

That's it! This will:
- Start MinIO (S3-compatible local storage)
- Deploy all Terraform resources locally
- Show you how to interact with them
- No cloud credentials required!

### Option 2: InSpec Demo (Infrastructure Testing)

```bash
cd inspec-demo
./local-test.sh
```

This will:
- Start MinIO (S3-compatible local storage)
- Deploy test infrastructure
- Run InSpec security compliance tests
- Generate test reports
- No cloud credentials required!

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

- S3-compatible buckets (with versioning)
- Simulated security rules
- Simulated IAM policies
- All running locally - no cloud services!

## 🔍 Next Steps

### For Prisma Cloud Demo:
1. **Scan for security issues**: `cd prisma-cloud-demo && ./scan.sh`
2. **Deploy locally**: `./local-deploy.sh`
3. **Access MinIO Console**: Open http://localhost:9001 (user: minioadmin, password: minioadmin)
4. **View Terraform state**: `cd terraform && terraform show`
5. **Clean up**: `./local-cleanup.sh`

### For InSpec Demo:
1. **Run compliance tests**: `cd inspec-demo && ./local-test.sh`
2. **View results**: `cat test-results/results.json | jq`
3. **Generate HTML report**: `inspec exec profiles/local-baseline/ --reporter html:test-results/report.html`
4. **Clean up**: `./local-cleanup.sh`

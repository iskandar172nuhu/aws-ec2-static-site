# AWS EC2 Static Website Deployment

## Overview
This project provisions an AWS EC2 instance and deploys a public-facing static HTML website using the AWS CLI and Nginx.  
The EC2 instance is configured automatically at launch using a cloud-init user-data script, with no manual server setup.

The solution follows DevOps best practices including automation, secure access control, and cost-aware resource teardown.

---

## Architecture

User
|
| HTTP (Port 80)
|
EC2 Instance (Ubuntu 22.04)
├── Nginx
└── Static HTML Site
---

## Prerequisites
- AWS account
- AWS CLI v2 installed and configured
- IAM user with EC2 permissions
- macOS or Linux terminal
- Git

---

## Project Structure

aws-ec2-static-site/
├── site/
│ └── index.html
├── infra/
│ ├── deploy.sh
│ ├── teardown.sh
│ └── user-data.sh
├── docs/
└── .gitignore
---

## Deployment

### Clone the repository
```bash
git clone https://github.com/<your-username>/aws-ec2-static-site.git
cd aws-ec2-static-site


./infra/deploy.sh
This script:
Provisions an EC2 instance
Configures security group rules
Installs and configures Nginx
Deploys the static website automatically using cloud-init

## Docker (Local Run)

Build:
```bash
docker build -t ec2-static-site:1.0 .
docker run -d --name ec2-static-site -p 8080:80 ec2-static-site:1.0

## Verify
```bash
curl http://localhost:8080
curl http://localhost:8080/health

## Stop
```bash
docker rm -f ec2-static-site


## Verification:

After deployment completes, validate that the service is running:
```bash
curl http://<PUBLIC_IP>
curl http://<PUBLIC_IP>/health

A successful response confirms that the web server and application are available.


## SSH Access (Optional:)

SSH access is intended for verification and troubleshooting only.
The private SSH key is generated locally during deployment and is excluded from version control.

```bash
ssh -i ec2-static-site-key.pem ubuntu@<PUBLIC_IP>


Verification commands:

```bash
systemctl status nginx
ls /var/www/html
curl localhost/health


## Teardown (Cost Control):

To destroy all AWS resources created by this project and prevent unnecessary charges:
```bash
./infra/teardown.sh

This terminates the EC2 instance and deletes associated security groups.


## CI/CD Pipeline (GitHub Actions)

This project includes an automated CI/CD pipeline implemented using GitHub Actions to build, test, and validate the Docker image on every push to the main branch.

Pipeline Overview

The workflow is triggered automatically when changes are pushed to the repository. It performs the following steps:

Checkout Source Code
Retrieves the latest version of the repository.

Set Up Docker Buildx
Enables advanced Docker build capabilities used in modern CI environments.

Authenticate to Docker Hub (Securely)
Logs in using GitHub encrypted secrets:

DOCKERHUB_USERNAME

DOCKERHUB_TOKEN

Build Docker Image
Builds the container image using the project Dockerfile.

Run Container & Health Check
Starts the container and validates the application using the /health endpoint to ensure the service is running correctly.

Fail Fast on Errors
If any step fails (build, run, or health check), the pipeline exits immediately, preventing broken images from being published.

## CI Workflow File

The CI pipeline is defined in:
```bash
.github/workflows/docker.yml

This file controls how Docker images are built and tested in a clean, repeatable environment.

Security Considerations

Docker Hub credentials are stored as GitHub Secrets

Secrets are never logged or exposed in workflow output

Sensitive files are excluded using .dockerignore

SSH keys and tokens are not committed to version control

The CI pipeline builds and validates the Docker image.
Image publishing to Docker Hub can be enabled by adding a push step.

🏗 Infrastructure Provisioning (Terraform)

This project uses Terraform to provision AWS infrastructure in a repeatable and production-ready way.

Terraform replaces manual AWS CLI provisioning and ensures infrastructure is:

Declarative

Version-controlled

Reproducible

Secure by default

Resources provisioned

EC2 instance (Ubuntu 22.04)

Security Group:

HTTP (80) open to the internet

SSH (22) restricted to a single trusted IP

Key pair for SSH access

Cloud-init user-data to install and configure Nginx automatically
🔁 Architecture Flow
Developer
  |
  | terraform apply
  v
Terraform
  |
  | creates
  v
AWS EC2 (Ubuntu)
  |
  | cloud-init
  v
Nginx installed & started
  |
  v
Static website available on port 80

▶️ Terraform Usage

From the project root:
cd terraform
terraform init
terraform apply

Terraform outputs:

Public IP address

Website URL

Health check endpoint

🔐 Security Considerations

SSH access is restricted to a single CIDR (your public IP)

No private keys are committed to version control

Terraform state files and provider binaries are ignored via .gitignore

Infrastructure can be safely destroyed using:

terraform destroy


🧹 State & Git Hygiene

The following files are intentionally excluded from version control:

.terraform/

terraform.tfstate

terraform.tfvars

This prevents:

Accidental secret leakage

Large binary commits

Corrupted Git history

## Author: Iskandar Nuhu


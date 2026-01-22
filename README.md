AWS EC2 Static Site with Docker, CI/CD, and Terraform

Overview

This project demonstrates an end-to-end DevOps workflow for building, testing, and deploying a containerised static website on AWS using Docker, GitHub Actions, and Terraform.

The infrastructure is provisioned using Infrastructure as Code (IaC), validated, and then safely destroyed to control cloud costs.


Architecture

Docker: Containerised Nginx static website

GitHub Actions: CI pipeline for build & validation

Terraform: Provisioning AWS EC2 and Security Groups

AWS EC2 (Ubuntu): Hosts the web server

Cloud-init: Automated server configuration on launch


Tech Stack

Docker

Nginx

GitHub Actions (CI)

Terraform

AWS EC2

Bash / Linux

SSH


What This Project Does

1️⃣ Containerisation

Built a Docker image for a static Nginx website

Exposed port 80 inside the container

Added /health endpoint for validation


2️⃣ CI Pipeline (GitHub Actions)

Automatically triggers on push to main

Builds Docker image

Runs container and performs health check

Ensures build reliability before deployment


3️⃣ Infrastructure as Code (Terraform)

Terraform provisions:

EC2 instance (Ubuntu)

Security Group:

HTTP (80) open to public

SSH (22) restricted to my IP

Key pair for SSH access

Outputs:

Public IP

Website URL

Health check URL


4️⃣ Automated Server Configuration

Using cloud-init, the EC2 instance automatically:

Installs Nginx

Starts the service

Serves the static site on boot

No manual configuration required.


5️⃣ Validation

After deployment:

SSH access verified

Nginx service status confirmed

Website reachable via public IP

/health endpoint returns HTTP 200


6️⃣ Clean Teardown

Infrastructure destroyed using terraform destroy

No resources left running

Zero ongoing AWS cost

## Repository Structure
```
.
├── .github/workflows/      # CI pipeline
├── terraform/              # Infrastructure as Code
├── site/                   # Static website files
├── Dockerfile              # Docker image definition
├── .dockerignore
├── .gitignore
└── README.md
```

How to Reproduce

Clone the repository

git clone https://github.com/iskandar172nuhu/aws-ec2-static-site.git

cd aws-ec2-static-site

Deploy infrastructure
cd terraform
terraform init
terraform apply

Destroy infrastructure
terraform destroy

Key DevOps Concepts Demonstrated

Infrastructure as Code (Terraform)

CI/CD pipelines

Secure SSH access

Cloud cost control

Immutable infrastructure

Automated provisioning with cloud-init


Author

Iskandar Nuhu

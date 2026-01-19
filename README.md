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


## Author: Iskandar Nuhu


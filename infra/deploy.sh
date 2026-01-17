#!/usr/bin/env bash
set -euo pipefail

# -------- CONFIG --------
AWS_REGION="eu-west-2"
APP_NAME="ec2-static-site"
INSTANCE_TYPE="t3.micro"
KEY_NAME="ec2-static-site-key"
SG_NAME="ec2-static-site-sg"
# ------------------------

echo "Using region: $AWS_REGION"
aws configure set region "$AWS_REGION" >/dev/null

echo "[1/6] Finding latest Ubuntu 22.04 AMI..."
AMI_ID=$(aws ec2 describe-images \
  --owners 099720109477 \
  --filters "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*" \
  --query "Images | sort_by(@, &CreationDate) | [-1].ImageId" \
  --output text)

echo "AMI_ID: $AMI_ID"

echo "[2/6] Creating or reusing key pair..."
if ! aws ec2 describe-key-pairs --key-names "$KEY_NAME" >/dev/null 2>&1; then
  aws ec2 create-key-pair \
    --key-name "$KEY_NAME" \
    --query "KeyMaterial" \
    --output text > "${KEY_NAME}.pem"
  chmod 400 "${KEY_NAME}.pem"
  echo "Key saved as ${KEY_NAME}.pem"
else
  echo "Key pair already exists"
fi

echo "[3/6] Creating or reusing security group..."
VPC_ID=$(aws ec2 describe-vpcs \
  --filters "Name=isDefault,Values=true" \
  --query "Vpcs[0].VpcId" \
  --output text)

SG_ID=$(aws ec2 describe-security-groups \
  --filters "Name=group-name,Values=$SG_NAME" "Name=vpc-id,Values=$VPC_ID" \
  --query "SecurityGroups[0].GroupId" \
  --output text)

if [[ "$SG_ID" == "None" || -z "$SG_ID" ]]; then
  SG_ID=$(aws ec2 create-security-group \
    --group-name "$SG_NAME" \
    --description "Security group for $APP_NAME" \
    --vpc-id "$VPC_ID" \
    --query "GroupId" \
    --output text)
  echo "Created SG: $SG_ID"
else
  echo "Reusing SG: $SG_ID"
fi

MY_IP=$(curl -s https://checkip.amazonaws.com)

aws ec2 authorize-security-group-ingress \
  --group-id "$SG_ID" \
  --protocol tcp \
  --port 22 \
  --cidr "$MY_IP/32" >/dev/null 2>&1 || true

aws ec2 authorize-security-group-ingress \
  --group-id "$SG_ID" \
  --protocol tcp \
  --port 80 \
  --cidr "0.0.0.0/0" >/dev/null 2>&1 || true

echo "[4/6] Launching EC2 instance..."
INSTANCE_ID=$(aws ec2 run-instances \
  --image-id "$AMI_ID" \
  --instance-type "$INSTANCE_TYPE" \
  --key-name "$KEY_NAME" \
  --security-group-ids "$SG_ID" \
  --user-data file://infra/user-data.sh \
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$APP_NAME},{Key=Project,Value=$APP_NAME}]" \
  --query "Instances[0].InstanceId" \
  --output text)

echo "Instance ID: $INSTANCE_ID"

echo "[5/6] Waiting for instance to start..."
aws ec2 wait instance-running --instance-ids "$INSTANCE_ID"

PUBLIC_IP=$(aws ec2 describe-instances \
  --instance-ids "$INSTANCE_ID" \
  --query "Reservations[0].Instances[0].PublicIpAddress" \
  --output text)

echo "[6/6] Deployment complete"
echo "Website URL: http://$PUBLIC_IP"
echo "Health URL : http://$PUBLIC_IP/health"
echo "SSH access : ssh -i ${KEY_NAME}.pem ubuntu@$PUBLIC_IP"


#!/usr/bin/env bash
set -euo pipefail

AWS_REGION="eu-west-2"
APP_NAME="ec2-static-site"
SG_NAME="ec2-static-site-sg"

aws configure set region "$AWS_REGION" >/dev/null

echo "Finding EC2 instances for project: $APP_NAME"

INSTANCE_IDS=$(aws ec2 describe-instances \
  --filters "Name=tag:Project,Values=$APP_NAME" \
           "Name=instance-state-name,Values=pending,running,stopping,stopped" \
  --query "Reservations[].Instances[].InstanceId" \
  --output text)

if [[ -n "$INSTANCE_IDS" ]]; then
  echo "Terminating instances: $INSTANCE_IDS"
  aws ec2 terminate-instances --instance-ids $INSTANCE_IDS >/dev/null
  aws ec2 wait instance-terminated --instance-ids $INSTANCE_IDS
  echo "Instances terminated"
else
  echo "No instances found"
fi

echo "Deleting security group (if exists)"

VPC_ID=$(aws ec2 describe-vpcs \
  --filters "Name=isDefault,Values=true" \
  --query "Vpcs[0].VpcId" \
  --output text)

SG_ID=$(aws ec2 describe-security-groups \
  --filters "Name=group-name,Values=$SG_NAME" \
           "Name=vpc-id,Values=$VPC_ID" \
  --query "SecurityGroups[0].GroupId" \
  --output text)

if [[ "$SG_ID" != "None" && -n "$SG_ID" ]]; then
  aws ec2 delete-security-group --group-id "$SG_ID" >/dev/null
  echo "Security group deleted"
else
  echo "Security group not found"
fi


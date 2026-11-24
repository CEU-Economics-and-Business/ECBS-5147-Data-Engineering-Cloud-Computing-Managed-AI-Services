#!/usr/bin/env bash
#
# Create the shared IAM roles students pick in the pipeline assignment.
# Idempotent: existing roles are left in place, policies are (re)attached.
#
#   LambdaS3ExecutionRole  - Lambda execution role with S3 + CloudWatch Logs access
#   EventBridgeLambdaRole  - EventBridge Scheduler role that may invoke Lambda functions
#
# Usage:
#   AWS_PROFILE=ceu ./create_roles.sh
#
export AWS_PAGER=""
export AWS_DEFAULT_REGION="eu-west-1"
set -eu

ACCOUNT_ID="870137400553"

if [[ -z "${AWS_PROFILE:-}" ]]; then
    echo "Error: AWS_PROFILE must be set" >&2
    exit 1
fi

trust_policy() {
    local service="$1"
    cat <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {"Service": "${service}"},
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

ensure_role() {
    local role_name="$1" service="$2" description="$3"
    if aws iam get-role --role-name "$role_name" &>/dev/null; then
        echo "Role exists: $role_name"
    else
        echo "Creating role: $role_name"
        aws iam create-role \
            --role-name "$role_name" \
            --description "$description" \
            --assume-role-policy-document "$(trust_policy "$service")" >/dev/null
    fi
}

# Lambda execution role
ensure_role LambdaS3ExecutionRole lambda.amazonaws.com "CEU class: Lambda execution role with S3 write access"
aws iam attach-role-policy --role-name LambdaS3ExecutionRole \
    --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
aws iam attach-role-policy --role-name LambdaS3ExecutionRole \
    --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess
echo "  Attached AWSLambdaBasicExecutionRole, AmazonS3FullAccess"

# EventBridge Scheduler role
ensure_role EventBridgeLambdaRole scheduler.amazonaws.com "CEU class: EventBridge Scheduler role that invokes Lambda"
aws iam put-role-policy --role-name EventBridgeLambdaRole \
    --policy-name InvokeLambda \
    --policy-document "{
        \"Version\": \"2012-10-17\",
        \"Statement\": [
            {
                \"Effect\": \"Allow\",
                \"Action\": \"lambda:InvokeFunction\",
                \"Resource\": \"arn:aws:lambda:eu-west-1:${ACCOUNT_ID}:function:*\"
            }
        ]
    }"
echo "  Put inline policy InvokeLambda"

echo "=== Done ==="

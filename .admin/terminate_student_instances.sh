#!/usr/bin/env bash
#
# terminate_student_instances.sh - Terminate every EC2 instance in eu-west-1 launched by a student
#
# EC2 doesn't record who launched an instance, so the launcher is looked up in CloudTrail
# (RunInstances event). Only instances launched by a member of the "student" IAM group are
# terminated; instances launched by admins or roles are left alone. CloudTrail event history
# covers 90 days, so instances whose launcher can't be found are reported and skipped.
#
# Usage:
#   AWS_PROFILE=ceu ./terminate_student_instances.sh [--dry-run]
#
# Options:
#   --dry-run    Show what would be terminated without terminating anything
#

export AWS_PAGER=""
export AWS_DEFAULT_REGION="eu-west-1"
set -eu

GROUP_NAME="student"

DRY_RUN=false
if [[ "${1:-}" == "--dry-run" ]]; then
    DRY_RUN=true
    echo "=== DRY RUN MODE - No changes will be made ==="
    echo ""
fi

if [[ -z "${AWS_PROFILE:-}" ]]; then
    echo "ERROR: AWS_PROFILE must be set" >&2
    echo "Usage: AWS_PROFILE=ceu ./terminate_student_instances.sh [--dry-run]" >&2
    exit 1
fi

echo "=== Terminating student EC2 instances ==="
echo "AWS Profile: $AWS_PROFILE"
echo "Region: $AWS_DEFAULT_REGION"
echo ""

students=$(aws iam get-group --group-name "$GROUP_NAME" --query 'Users[].UserName' --output text | tr '\t' '\n')
echo "Students in group '$GROUP_NAME': $(echo "$students" | grep -c .)"

instances=$(aws ec2 describe-instances \
    --filters Name=instance-state-name,Values=pending,running,stopping,stopped \
    --query 'Reservations[].Instances[].InstanceId' \
    --output text)

if [[ -z "$instances" ]]; then
    echo "  No instances found"
    echo ""
    echo "=== Done ==="
    exit 0
fi

to_terminate=()
for instance in $instances; do
    launcher=$(aws cloudtrail lookup-events \
        --lookup-attributes AttributeKey=ResourceName,AttributeValue="$instance" \
        --query 'Events[?EventName==`RunInstances`].Username | [0]' \
        --output text)
    if [[ -z "$launcher" || "$launcher" == "None" ]]; then
        echo "  SKIP $instance: launcher not found in CloudTrail (older than 90 days?)"
    elif echo "$students" | grep -qxF "$launcher"; then
        echo "  TERMINATE $instance (launched by $launcher)"
        to_terminate+=("$instance")
    else
        echo "  KEEP $instance (launched by $launcher, not a student)"
    fi
done

echo ""
if [[ ${#to_terminate[@]} -eq 0 ]]; then
    echo "No student instances to terminate"
elif $DRY_RUN; then
    echo "[DRY RUN] Would terminate ${#to_terminate[@]} instance(s): ${to_terminate[*]}"
else
    aws ec2 terminate-instances --instance-ids "${to_terminate[@]}" \
        --query 'TerminatingInstances[].[InstanceId,CurrentState.Name]' --output text
    echo "Terminated ${#to_terminate[@]} instance(s)"
fi

echo ""
echo "=== Done ==="

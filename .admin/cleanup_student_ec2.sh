#!/usr/bin/env bash
#
# cleanup_student_ec2.sh - Remove student EC2 resources in eu-west-1 and empty the class DNS zone
#
# This script:
# 1. Terminates EC2 instances launched by students
# 2. Deletes security groups created by students
# 3. Deletes EC2 key pairs created or imported by students
# 4. Deletes every record in the ceu-data.com hosted zone (except the apex NS and SOA)
#
# EC2 doesn't record who created a resource, so the creator is looked up in CloudTrail.
# Only resources created by a member of the "student" IAM group are removed; resources
# created by admins or roles are left alone. CloudTrail event history covers 90 days, so
# resources whose creator can't be found are reported and skipped.
#
# Usage:
#   AWS_PROFILE=ceu ./cleanup_student_ec2.sh [--dry-run]
#
# Options:
#   --dry-run    Show what would be removed without removing anything
#

export AWS_PAGER=""
export AWS_DEFAULT_REGION="eu-west-1"
set -eu

GROUP_NAME="student"
DNS_ZONE="ceu-data.com."

DRY_RUN=false
if [[ "${1:-}" == "--dry-run" ]]; then
    DRY_RUN=true
    echo "=== DRY RUN MODE - No changes will be made ==="
    echo ""
fi

if [[ -z "${AWS_PROFILE:-}" ]]; then
    echo "ERROR: AWS_PROFILE must be set" >&2
    echo "Usage: AWS_PROFILE=ceu ./cleanup_student_ec2.sh [--dry-run]" >&2
    exit 1
fi

echo "=== Student EC2 cleanup ==="
echo "AWS Profile: $AWS_PROFILE"
echo "Region: $AWS_DEFAULT_REGION"
echo ""

students=$(aws iam get-group --group-name "$GROUP_NAME" --query 'Users[].UserName' --output text | tr '\t' '\n')
echo "Students in group '$GROUP_NAME': $(echo "$students" | grep -c .)"

# Print the student who created a resource (via CloudTrail), or nothing.
# Reports KEEP/SKIP lines on stderr for resources that are not a student's.
student_creator() {
    local resource="$1" events="$2"
    local creator
    creator=$(aws cloudtrail lookup-events \
        --lookup-attributes AttributeKey=ResourceName,AttributeValue="$resource" \
        --query "Events[?contains(\`$events\`, EventName)].Username | [0]" \
        --output text)
    if [[ -z "$creator" || "$creator" == "None" ]]; then
        echo "  SKIP $resource: creator not found in CloudTrail (older than 90 days?)" >&2
    elif echo "$students" | grep -qxF "$creator"; then
        echo "$creator"
    else
        echo "  KEEP $resource (created by $creator, not a student)" >&2
    fi
}

# --- EC2 Instances ---
echo ""
echo "=== Terminating student EC2 instances ==="
instances=$(aws ec2 describe-instances \
    --filters Name=instance-state-name,Values=pending,running,stopping,stopped \
    --query 'Reservations[].Instances[].InstanceId' \
    --output text)
to_terminate=()
for instance in $instances; do
    creator=$(student_creator "$instance" '["RunInstances"]')
    if [[ -n "$creator" ]]; then
        echo "  TERMINATE $instance (launched by $creator)"
        to_terminate+=("$instance")
    fi
done
if [[ ${#to_terminate[@]} -eq 0 ]]; then
    echo "  No student instances found"
elif $DRY_RUN; then
    echo "  [DRY RUN] Would terminate ${#to_terminate[@]} instance(s)"
else
    aws ec2 terminate-instances --instance-ids "${to_terminate[@]}" >/dev/null
    echo "  Waiting for ${#to_terminate[@]} instance(s) to terminate (security groups can't be deleted before)..."
    aws ec2 wait instance-terminated --instance-ids "${to_terminate[@]}"
    echo "  Terminated ${#to_terminate[@]} instance(s)"
fi

# --- Security Groups ---
echo ""
echo "=== Deleting student security groups ==="
sgs=$(aws ec2 describe-security-groups \
    --query 'SecurityGroups[?GroupName!=`default`].GroupId' \
    --output text)
found=false
for sg in $sgs; do
    creator=$(student_creator "$sg" '["CreateSecurityGroup"]')
    if [[ -n "$creator" ]]; then
        found=true
        name=$(aws ec2 describe-security-groups --group-ids "$sg" --query 'SecurityGroups[0].GroupName' --output text)
        if $DRY_RUN; then
            echo "  [DRY RUN] Would delete $sg ($name, created by $creator)"
        else
            echo "  Deleting $sg ($name, created by $creator)"
            aws ec2 delete-security-group --group-id "$sg" >/dev/null || echo "    Could not delete $sg (still in use?)"
        fi
    fi
done
$found || echo "  No student security groups found"

# --- EC2 Key Pairs ---
echo ""
echo "=== Deleting student EC2 key pairs ==="
keypairs=$(aws ec2 describe-key-pairs --query 'KeyPairs[].KeyName' --output text)
found=false
for keypair in $keypairs; do
    creator=$(student_creator "$keypair" '["CreateKeyPair","ImportKeyPair"]')
    if [[ -n "$creator" ]]; then
        found=true
        if $DRY_RUN; then
            echo "  [DRY RUN] Would delete key pair $keypair (created by $creator)"
        else
            echo "  Deleting key pair $keypair (created by $creator)"
            aws ec2 delete-key-pair --key-name "$keypair" >/dev/null
        fi
    fi
done
$found || echo "  No student key pairs found"

# --- DNS records ---
echo ""
echo "=== Emptying hosted zone $DNS_ZONE ==="
zone_id=$(aws route53 list-hosted-zones-by-name --dns-name "$DNS_ZONE" \
    --query "HostedZones[?Name=='$DNS_ZONE'].Id | [0]" --output text)
if [[ -z "$zone_id" || "$zone_id" == "None" ]]; then
    echo "  Hosted zone $DNS_ZONE not found"
else
    # Every record except the apex NS and SOA, which Route 53 requires
    records=$(aws route53 list-resource-record-sets --hosted-zone-id "$zone_id" --output json |
        jq --arg zone "$DNS_ZONE" '[.ResourceRecordSets[] | select(.Name != $zone or (.Type != "NS" and .Type != "SOA"))]')
    count=$(echo "$records" | jq length)
    echo "$records" | jq -r '.[] | "  \(.Name) \(.Type) \((.ResourceRecords // []) | map(.Value) | join(",")) \(.AliasTarget.DNSName // "")"'
    if [[ "$count" -eq 0 ]]; then
        echo "  No records to delete"
    elif $DRY_RUN; then
        echo "  [DRY RUN] Would delete $count record(s)"
    else
        aws route53 change-resource-record-sets --hosted-zone-id "$zone_id" \
            --change-batch "$(echo "$records" | jq '{Changes: map({Action: "DELETE", ResourceRecordSet: .})}')" >/dev/null
        echo "  Deleted $count record(s)"
    fi
fi

echo ""
echo "=== Done ==="

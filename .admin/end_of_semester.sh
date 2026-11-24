#!/usr/bin/env bash
#
# end_of_semester.sh - Clean up all student resources and remove permissions
#
# This script:
# 1. Deletes all running services/assets (except S3 buckets)
# 2. Removes all students from the "student" group
#
# Usage:
#   AWS_PROFILE=ceu ./end_of_semester.sh [--dry-run]
#
# Options:
#   --dry-run    Show what would be deleted without actually deleting
#

export AWS_PAGER=""
export AWS_DEFAULT_REGION="eu-west-1"
set -eu

DRY_RUN=false
if [[ "${1:-}" == "--dry-run" ]]; then
    DRY_RUN=true
    echo "=== DRY RUN MODE - No changes will be made ==="
    echo ""
fi

if [[ -z "${AWS_PROFILE:-}" ]]; then
    echo "ERROR: AWS_PROFILE must be set" >&2
    echo "Usage: AWS_PROFILE=ceu ./end_of_semester.sh [--dry-run]" >&2
    exit 1
fi

echo "=== End of Semester Cleanup ==="
echo "AWS Profile: $AWS_PROFILE"
echo "Region: $AWS_DEFAULT_REGION"
echo ""

run_cmd() {
    if $DRY_RUN; then
        echo "  [DRY RUN] Would run: $*"
    else
        "$@"
    fi
}

# Confirmation
if ! $DRY_RUN; then
    echo "WARNING: This will delete ALL student resources (except S3) and remove all students from the 'student' group."
    echo ""
    read -p "Are you sure you want to proceed? (type 'yes' to confirm): " confirm
    if [[ "$confirm" != "yes" ]]; then
        echo "Aborted by user"
        exit 1
    fi
    echo ""
fi

#######################################
# SECTION 1: Delete all running services/assets (except S3)
#######################################

echo "========================================"
echo "SECTION 1: Deleting resources"
echo "========================================"

# --- EC2 Instances ---
echo ""
echo "=== Terminating EC2 instances ==="
instances=$(aws ec2 describe-instances \
    --query 'Reservations[].Instances[?State.Name!=`terminated`].InstanceId' \
    --output text)
if [[ -n "$instances" ]]; then
    for instance in $instances; do
        echo "  Terminating instance: $instance"
        run_cmd aws ec2 terminate-instances --instance-ids "$instance"
    done
    if ! $DRY_RUN; then
        echo "  Waiting for instances to terminate..."
        sleep 10
    fi
else
    echo "  No running instances found"
fi

# --- EC2 Key Pairs ---
echo ""
echo "=== Deleting EC2 key pairs ==="
keypairs=$(aws ec2 describe-key-pairs --query 'KeyPairs[].KeyName' --output text)
if [[ -n "$keypairs" ]]; then
    for keypair in $keypairs; do
        echo "  Deleting key pair: $keypair"
        run_cmd aws ec2 delete-key-pair --key-name "$keypair"
    done
else
    echo "  No key pairs found"
fi

# --- Security Groups ---
echo ""
echo "=== Deleting security groups (except default) ==="
sgs=$(aws ec2 describe-security-groups \
    --query 'SecurityGroups[?GroupName!=`default`].GroupId' \
    --output text)
if [[ -n "$sgs" ]]; then
    for sg in $sgs; do
        echo "  Deleting security group: $sg"
        run_cmd aws ec2 delete-security-group --group-id "$sg" 2>/dev/null || echo "    Could not delete $sg (may have dependencies)"
    done
else
    echo "  No custom security groups found"
fi

# --- EBS Volumes ---
echo ""
echo "=== Deleting unattached EBS volumes ==="
volumes=$(aws ec2 describe-volumes \
    --query 'Volumes[?State!=`in-use`].VolumeId' \
    --output text)
if [[ -n "$volumes" ]]; then
    for volume in $volumes; do
        echo "  Deleting volume: $volume"
        run_cmd aws ec2 delete-volume --volume-id "$volume" 2>/dev/null || true
    done
else
    echo "  No unattached volumes found"
fi

# --- Lambda Functions ---
echo ""
echo "=== Deleting Lambda functions ==="
functions=$(aws lambda list-functions --query 'Functions[].FunctionName' --output text 2>/dev/null || true)
if [[ -n "$functions" ]]; then
    for func in $functions; do
        echo "  Deleting function: $func"
        run_cmd aws lambda delete-function --function-name "$func" 2>/dev/null || true
    done
else
    echo "  No Lambda functions found"
fi

# --- EventBridge Rules ---
echo ""
echo "=== Deleting EventBridge rules ==="
rules=$(aws events list-rules --query 'Rules[].Name' --output text 2>/dev/null || true)
if [[ -n "$rules" ]]; then
    for rule in $rules; do
        echo "  Removing targets and deleting rule: $rule"
        # First remove all targets
        targets=$(aws events list-targets-by-rule --rule "$rule" --query 'Targets[].Id' --output text 2>/dev/null || true)
        if [[ -n "$targets" ]]; then
            run_cmd aws events remove-targets --rule "$rule" --ids $targets 2>/dev/null || true
        fi
        # Then delete the rule
        run_cmd aws events delete-rule --name "$rule" 2>/dev/null || true
    done
else
    echo "  No EventBridge rules found"
fi

# --- EventBridge Scheduler Schedules ---
echo ""
echo "=== Deleting EventBridge Scheduler schedules ==="
schedules=$(aws scheduler list-schedules --query 'Schedules[].Name' --output text 2>/dev/null || true)
if [[ -n "$schedules" ]]; then
    for schedule in $schedules; do
        echo "  Deleting schedule: $schedule"
        run_cmd aws scheduler delete-schedule --name "$schedule" 2>/dev/null || true
    done
else
    echo "  No EventBridge schedules found"
fi

# --- Athena Databases ---
echo ""
echo "=== Deleting Athena databases and tables ==="
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if $DRY_RUN; then
    echo "  [DRY RUN] Would run: python3 $SCRIPT_DIR/athena_delete_everything.py --profile $AWS_PROFILE --dry-run"
    python3 "$SCRIPT_DIR/athena_delete_everything.py" --profile "$AWS_PROFILE" --dry-run 2>/dev/null || echo "  Could not list Athena databases"
else
    python3 "$SCRIPT_DIR/athena_delete_everything.py" --profile "$AWS_PROFILE" 2>/dev/null || echo "  Could not delete Athena databases"
fi

# --- Transcribe Jobs ---
echo ""
echo "=== Deleting Transcribe jobs ==="
jobs=$(aws transcribe list-transcription-jobs --query 'TranscriptionJobSummaries[].TranscriptionJobName' --output text 2>/dev/null || true)
if [[ -n "$jobs" ]]; then
    for job in $jobs; do
        echo "  Deleting job: $job"
        run_cmd aws transcribe delete-transcription-job --transcription-job-name "$job" 2>/dev/null || true
    done
else
    echo "  No Transcribe jobs found"
fi

# --- Rekognition Collections ---
echo ""
echo "=== Deleting Rekognition collections ==="
collections=$(aws rekognition list-collections --query 'CollectionIds[]' --output text 2>/dev/null || true)
if [[ -n "$collections" ]]; then
    for collection in $collections; do
        echo "  Deleting collection: $collection"
        run_cmd aws rekognition delete-collection --collection-id "$collection" 2>/dev/null || true
    done
else
    echo "  No Rekognition collections found"
fi

# --- Comprehend Jobs ---
echo ""
echo "=== Stopping Comprehend jobs ==="
comprehend_jobs=$(aws comprehend list-sentiment-detection-jobs --query 'SentimentDetectionJobPropertiesList[].JobId' --output text 2>/dev/null || true)
if [[ -n "$comprehend_jobs" ]]; then
    for job in $comprehend_jobs; do
        echo "  Stopping job: $job"
        run_cmd aws comprehend stop-sentiment-detection-job --job-id "$job" 2>/dev/null || true
    done
else
    echo "  No Comprehend jobs found"
fi

# --- Translate Resources ---
echo ""
echo "=== Deleting Translate terminologies ==="
terminologies=$(aws translate list-terminologies --query 'TerminologyPropertiesList[].Name' --output text 2>/dev/null || true)
if [[ -n "$terminologies" ]]; then
    for terminology in $terminologies; do
        echo "  Deleting terminology: $terminology"
        run_cmd aws translate delete-terminology --name "$terminology" 2>/dev/null || true
    done
else
    echo "  No Translate terminologies found"
fi

echo ""
echo "=== Deleting Translate parallel data ==="
parallel_data=$(aws translate list-parallel-data --query 'ParallelDataPropertiesList[].Name' --output text 2>/dev/null || true)
if [[ -n "$parallel_data" ]]; then
    for data in $parallel_data; do
        echo "  Deleting parallel data: $data"
        run_cmd aws translate delete-parallel-data --name "$data" 2>/dev/null || true
    done
else
    echo "  No Translate parallel data found"
fi

# --- IAM Roles created by students ---
echo ""
echo "=== Deleting student-created IAM roles ==="
# Only delete roles that look like they were created by students (not AWS service roles)
roles=$(aws iam list-roles --query 'Roles[?!starts_with(RoleName, `AWS`) && !starts_with(RoleName, `aws-`)].RoleName' --output text 2>/dev/null || true)
if [[ -n "$roles" ]]; then
    for role in $roles; do
        # Skip known system roles
        if [[ "$role" == "OrganizationAccountAccessRole" ]] || [[ "$role" == "Admin" ]]; then
            echo "  Skipping system role: $role"
            continue
        fi
        echo "  Deleting role: $role"
        # First detach all policies
        attached=$(aws iam list-attached-role-policies --role-name "$role" --query 'AttachedPolicies[].PolicyArn' --output text 2>/dev/null || true)
        for policy_arn in $attached; do
            run_cmd aws iam detach-role-policy --role-name "$role" --policy-arn "$policy_arn" 2>/dev/null || true
        done
        # Delete inline policies
        inline=$(aws iam list-role-policies --role-name "$role" --query 'PolicyNames[]' --output text 2>/dev/null || true)
        for policy in $inline; do
            run_cmd aws iam delete-role-policy --role-name "$role" --policy-name "$policy" 2>/dev/null || true
        done
        # Delete the role
        run_cmd aws iam delete-role --role-name "$role" 2>/dev/null || echo "    Could not delete role $role"
    done
else
    echo "  No student-created roles found"
fi

#######################################
# SECTION 2: Remove students from the "student" group
#######################################

echo ""
echo "========================================"
echo "SECTION 2: Removing students from 'student' group"
echo "========================================"

students=$(aws iam get-group --group-name student --query 'Users[].UserName' --output text 2>/dev/null || true)
if [[ -n "$students" ]]; then
    for student in $students; do
        echo "  Removing $student from 'student' group"
        run_cmd aws iam remove-user-from-group --group-name student --user-name "$student"
    done
else
    echo "  No students found in 'student' group"
fi

#######################################
# Summary
#######################################

echo ""
echo "========================================"
echo "=== Cleanup complete ==="
echo "========================================"

if $DRY_RUN; then
    echo ""
    echo "This was a DRY RUN. No changes were made."
    echo "Run without --dry-run to execute the cleanup."
fi

echo ""
echo "Note: S3 buckets were NOT deleted. To delete S3 buckets, use cleanup_all.sh"
echo ""

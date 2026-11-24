#!/usr/bin/env bash
export AWS_PAGER=""
export AWS_DEFAULT_REGION="eu-west-1"
export AWS_PROFILE=ceu

set -eu

echo "=== Starting AWS cleanup with profile: $AWS_PROFILE ==="

# S3 - Delete everything except de2-datasets bucket
echo ""
echo "=== S3 Buckets Found ==="
echo ""
echo "The following buckets will be DELETED:"
for bucket in $(aws s3api list-buckets --query 'Buckets[].Name' --output text); do
    if [ "$bucket" != "de2-datasets" ]; then
        echo "  - $bucket"
    fi
done
echo ""
echo "The following buckets will be KEPT:"
for bucket in $(aws s3api list-buckets --query 'Buckets[].Name' --output text); do
    if [ "$bucket" = "de2-datasets" ]; then
        echo "  - $bucket (protected)"
    fi
done
echo ""
read -p "Are you sure you want to delete all S3 buckets except de2-datasets? (type 'yes' to confirm): " confirm
if [ "$confirm" != "yes" ]; then
    echo "Aborted by user"
    exit 1
fi

echo ""
echo "=== Cleaning S3 buckets ==="
for bucket in $(aws s3api list-buckets --query 'Buckets[].Name' --output text); do
    if [ "$bucket" != "de2-datasets" ]; then
        echo "Deleting bucket: $bucket"
        # Delete all objects and versions first
        aws s3 rm "s3://$bucket" --recursive 2> /dev/null || true
        # Delete all versions if versioning is enabled
        aws s3api delete-objects --bucket "$bucket" --delete "$(aws s3api list-object-versions --bucket "$bucket" --query='{Objects: Versions[].{Key:Key,VersionId:VersionId}}' --max-items 1000)" 2> /dev/null || true
        # Delete all delete markers
        aws s3api delete-objects --bucket "$bucket" --delete "$(aws s3api list-object-versions --bucket "$bucket" --query='{Objects: DeleteMarkers[].{Key:Key,VersionId:VersionId}}' --max-items 1000)" 2> /dev/null || true
        # Delete bucket
        aws s3api delete-bucket --bucket "$bucket" 2> /dev/null || true
    else
        echo "Skipping bucket: $bucket (protected)"
    fi
done

# EC2 - Terminate all instances
echo ""
echo "=== Terminating EC2 instances ==="
for instance in $(aws ec2 describe-instances --query 'Reservations[].Instances[?State.Name!=`terminated`].InstanceId' --output text); do
    echo "Terminating instance: $instance"
    aws ec2 terminate-instances --instance-ids "$instance"
done

# Wait a bit for instances to terminate
echo "Waiting for instances to terminate..."
sleep 10

# EC2 - Delete all key pairs
echo ""
echo "=== Deleting EC2 key pairs ==="
for keypair in $(aws ec2 describe-key-pairs --query 'KeyPairs[].KeyName' --output text); do
    echo "Deleting key pair: $keypair"
    aws ec2 delete-key-pair --key-name "$keypair"
done

# EC2 - Delete all security groups except default
echo ""
echo "=== Deleting security groups ==="
for sg in $(aws ec2 describe-security-groups --query 'SecurityGroups[?GroupName!=`default`].GroupId' --output text); do
    echo "Deleting security group: $sg"
    aws ec2 delete-security-group --group-id "$sg" 2> /dev/null || echo "  Could not delete $sg (may be in use or have dependencies)"
done

# EC2 - Delete all EBS volumes
echo ""
echo "=== Deleting EBS volumes ==="
for volume in $(aws ec2 describe-volumes --query 'Volumes[?State!=`in-use`].VolumeId' --output text); do
    echo "Deleting volume: $volume"
    aws ec2 delete-volume --volume-id "$volume" 2> /dev/null || true
done

# Athena - Delete all databases, tables, and associated S3 data
echo ""
echo "=== Deleting Athena databases and associated S3 data ==="
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
python3 "$SCRIPT_DIR/athena_delete_everything.py" --profile "$AWS_PROFILE"

echo ""
echo "=== Cleanup complete ==="

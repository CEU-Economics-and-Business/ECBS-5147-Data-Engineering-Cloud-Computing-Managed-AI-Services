#!/usr/bin/env bash
#
# Apply IAM policies to the student group.
# Idempotent: creates or updates policies as needed.
#
# Usage:
#   ./apply_policies.sh                    # Apply all policies in ./policies/
#   ./apply_policies.sh policies/Foo.json  # Apply a single policy
#
export AWS_PAGER=""
export AWS_DEFAULT_REGION="eu-west-1"
set -eu

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
POLICIES_DIR="$SCRIPT_DIR/policies"
GROUP_NAME="student"
ACCOUNT_ID="870137400553"

if [[ -z "${AWS_PROFILE:-}" ]]; then
    echo "Error: AWS_PROFILE must be set" >&2
    exit 1
fi

apply_policy() {
    local policy_file="$1"
    local policy_name
    policy_name="$(basename "$policy_file" .json)"
    local policy_arn="arn:aws:iam::${ACCOUNT_ID}:policy/${policy_name}"

    echo "Processing: $policy_name"

    # Check if policy exists
    if aws iam get-policy --policy-arn "$policy_arn" &>/dev/null; then
        echo "  Policy exists, updating..."

        # Create new version (AWS keeps up to 5 versions)
        # First, check how many versions exist and delete oldest if at limit
        local version_count
        version_count=$(aws iam list-policy-versions --policy-arn "$policy_arn" \
            --query 'length(Versions)' --output text)

        if [[ "$version_count" -ge 5 ]]; then
            # Find and delete the oldest non-default version
            local oldest_version
            oldest_version=$(aws iam list-policy-versions --policy-arn "$policy_arn" \
                --query 'Versions[?IsDefaultVersion==`false`] | sort_by(@, &CreateDate) | [0].VersionId' \
                --output text)
            if [[ "$oldest_version" != "None" && -n "$oldest_version" ]]; then
                echo "  Deleting old version: $oldest_version"
                aws iam delete-policy-version --policy-arn "$policy_arn" --version-id "$oldest_version"
            fi
        fi

        # Create new version and set as default
        aws iam create-policy-version \
            --policy-arn "$policy_arn" \
            --policy-document "file://$policy_file" \
            --set-as-default >/dev/null
        echo "  Updated policy version"
    else
        echo "  Creating new policy..."
        aws iam create-policy \
            --policy-name "$policy_name" \
            --policy-document "file://$policy_file" >/dev/null
        echo "  Created policy"
    fi

    # Ensure policy is attached to the group
    if aws iam list-attached-group-policies --group-name "$GROUP_NAME" \
        --query "AttachedPolicies[?PolicyArn=='$policy_arn']" --output text | grep -q "$policy_name"; then
        echo "  Already attached to $GROUP_NAME"
    else
        echo "  Attaching to $GROUP_NAME..."
        aws iam attach-group-policy --group-name "$GROUP_NAME" --policy-arn "$policy_arn"
        echo "  Attached"
    fi

    echo ""
}

# Main
echo "=== Applying IAM policies with profile: $AWS_PROFILE ==="
echo ""

if [[ $# -gt 0 ]]; then
    # Apply specific policy file(s)
    for file in "$@"; do
        if [[ -f "$file" ]]; then
            apply_policy "$file"
        else
            echo "Error: File not found: $file" >&2
            exit 1
        fi
    done
else
    # Apply all policies in the policies directory
    for policy_file in "$POLICIES_DIR"/*.json; do
        if [[ -f "$policy_file" ]]; then
            apply_policy "$policy_file"
        fi
    done
fi

# Attach AWS managed ReadOnlyAccess policy
READONLY_ARN="arn:aws:iam::aws:policy/ReadOnlyAccess"
echo "Processing: AWS managed ReadOnlyAccess"
if aws iam list-attached-group-policies --group-name "$GROUP_NAME" \
    --query "AttachedPolicies[?PolicyArn=='$READONLY_ARN']" --output text | grep -q "ReadOnlyAccess"; then
    echo "  Already attached to $GROUP_NAME"
else
    echo "  Attaching to $GROUP_NAME..."
    aws iam attach-group-policy --group-name "$GROUP_NAME" --policy-arn "$READONLY_ARN"
    echo "  Attached"
fi
echo ""

echo "=== Done ==="

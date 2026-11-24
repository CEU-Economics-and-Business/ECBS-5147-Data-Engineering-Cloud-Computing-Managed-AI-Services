#!/usr/bin/env bash
export AWS_PAGER=""
export AWS_DEFAULT_REGION="eu-west-1"
set -eu

if [[ -z "${AWS_PROFILE}" ]]
then
   echo "AWS profile must be set" >&2
   exit 1
fi

while read -r email
do
    email=$(echo "$email" | awk '{print tolower($0)}')
    echo "Adding $email"

    # Check if user exists and delete if so
    if aws iam get-user --user-name "$email" &> /dev/null; then
        echo "User $email already exists, deleting all resources..."

        # Delete access keys
        for key in $(aws iam list-access-keys --user-name "$email" --query 'AccessKeyMetadata[].AccessKeyId' --output text); do
            aws iam delete-access-key --user-name "$email" --access-key-id "$key"
        done

        # Delete login profile if it exists
        aws iam delete-login-profile --user-name "$email" 2> /dev/null || true

        # Remove from all groups
        for group in $(aws iam list-groups-for-user --user-name "$email" --query 'Groups[].GroupName' --output text); do
            aws iam remove-user-from-group --group-name "$group" --user-name "$email"
        done

        # Delete inline policies
        for policy in $(aws iam list-user-policies --user-name "$email" --query 'PolicyNames[]' --output text); do
            aws iam delete-user-policy --user-name "$email" --policy-name "$policy"
        done

        # Detach managed policies
        for policy in $(aws iam list-attached-user-policies --user-name "$email" --query 'AttachedPolicies[].PolicyArn' --output text); do
            aws iam detach-user-policy --user-name "$email" --policy-arn "$policy"
        done

        # Delete MFA devices
        for mfa in $(aws iam list-mfa-devices --user-name "$email" --query 'MFADevices[].SerialNumber' --output text); do
            aws iam deactivate-mfa-device --user-name "$email" --serial-number "$mfa"
            aws iam delete-virtual-mfa-device --serial-number "$mfa" 2> /dev/null || true
        done

        # Delete SSH public keys
        for key in $(aws iam list-ssh-public-keys --user-name "$email" --query 'SSHPublicKeys[].SSHPublicKeyId' --output text); do
            aws iam delete-ssh-public-key --user-name "$email" --ssh-public-key-id "$key"
        done

        # Delete signing certificates
        for cert in $(aws iam list-signing-certificates --user-name "$email" --query 'Certificates[].CertificateId' --output text); do
            aws iam delete-signing-certificate --user-name "$email" --certificate-id "$cert"
        done

        # Delete service specific credentials
        for cred in $(aws iam list-service-specific-credentials --user-name "$email" --query 'ServiceSpecificCredentials[].ServiceSpecificCredentialId' --output text); do
            aws iam delete-service-specific-credential --user-name "$email" --service-specific-credential-id "$cred"
        done

        # Delete EC2 instances
        echo "Terminating EC2 instances..."
        for instance in $(aws ec2 describe-instances --filters "Name=tag:Owner,Values=$email" --query 'Reservations[].Instances[].InstanceId' --output text); do
            aws ec2 terminate-instances --instance-ids "$instance"
        done

        # Delete EC2 key pairs
        echo "Deleting EC2 key pairs..."
        for keypair in $(aws ec2 describe-key-pairs --filters "Name=tag:Owner,Values=$email" --query 'KeyPairs[].KeyName' --output text); do
            aws ec2 delete-key-pair --key-name "$keypair"
        done

        # Delete security groups (skip default)
        echo "Deleting security groups..."
        for sg in $(aws ec2 describe-security-groups --filters "Name=tag:Owner,Values=$email" --query 'SecurityGroups[?GroupName!=`default`].GroupId' --output text); do
            aws ec2 delete-security-group --group-id "$sg" 2> /dev/null || true
        done

        # Delete Athena databases and tables
        echo "Deleting Athena databases..."
        for db in $(aws athena list-databases --catalog-name AwsDataCatalog --query 'DatabaseList[?Name!=`default`].Name' --output text 2> /dev/null || true); do
            # Delete tables first
            for table in $(aws athena list-table-metadata --catalog-name AwsDataCatalog --database-name "$db" --query 'TableMetadataList[].Name' --output text 2> /dev/null || true); do
                aws athena start-query-execution --query-string "DROP TABLE IF EXISTS \`$db\`.\`$table\`" --result-configuration "OutputLocation=s3://aws-athena-query-results-temp/" 2> /dev/null || true
            done
            # Delete database
            aws athena start-query-execution --query-string "DROP DATABASE IF EXISTS \`$db\` CASCADE" --result-configuration "OutputLocation=s3://aws-athena-query-results-temp/" 2> /dev/null || true
        done

        # Delete Transcribe jobs
        echo "Deleting Transcribe jobs..."
        for job in $(aws transcribe list-transcription-jobs --query 'TranscriptionJobSummaries[].TranscriptionJobName' --output text 2> /dev/null || true); do
            aws transcribe delete-transcription-job --transcription-job-name "$job" 2> /dev/null || true
        done

        # Delete Rekognition collections
        echo "Deleting Rekognition collections..."
        for collection in $(aws rekognition list-collections --query 'CollectionIds[]' --output text 2> /dev/null || true); do
            aws rekognition delete-collection --collection-id "$collection" 2> /dev/null || true
        done

        # Delete Comprehend sentiment analysis jobs
        echo "Deleting Comprehend jobs..."
        for job in $(aws comprehend list-sentiment-detection-jobs --query 'SentimentDetectionJobPropertiesList[].JobId' --output text 2> /dev/null || true); do
            aws comprehend stop-sentiment-detection-job --job-id "$job" 2> /dev/null || true
        done

        # Delete Translate custom terminologies
        echo "Deleting Translate terminologies..."
        for terminology in $(aws translate list-terminologies --query 'TerminologyPropertiesList[].Name' --output text 2> /dev/null || true); do
            aws translate delete-terminology --name "$terminology" 2> /dev/null || true
        done

        # Delete Translate parallel data
        echo "Deleting Translate parallel data..."
        for data in $(aws translate list-parallel-data --query 'ParallelDataPropertiesList[].Name' --output text 2> /dev/null || true); do
            aws translate delete-parallel-data --name "$data" 2> /dev/null || true
        done

        # Delete user
        aws iam delete-user --user-name "$email"
        echo "User $email deleted successfully"
    fi

    aws iam create-user --user-name "$email"
    aws iam add-user-to-group --group-name student --user-name "$email"
    aws iam create-login-profile --user-name "$email" --password CEUba2222 --password-reset-required

done

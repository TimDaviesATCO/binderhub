#!/usr/bin/env bash
# file: terraform_remote_state_setup.sh
# author: Jess Robertson, CSIRO Minerals
# date:   August 2018
#
# description: Automatically sets up an AWS account to store remote terraform
#              state.

# Values that we can set
AWS_REGION="${AWS_REGION:-ap-southeast-2}"
AWS_PROFILE="${AWS_PROFILE:-default}"

# Find out our account ID
account_id="$(aws sts get-caller-identity --query Account --output text)"

# Names for state storage
terraform_bucket_name="core.${account_id}.terraform-state"
lock_table="core.${account_id}.terraform-locks"

help () {
    echo "Usage: terraform_remote_state.sh COMMAND"
    echo ""
    echo "Set up or tear down terraform remote state infrastructure."
    echo ""
    echo "We generally have to do this seperately and once per project."
    echo "Once this is done everything else can be managed by terraform."
    echo ""
    echo "You can change the region by setting AWS_REGION."
    echo ""
    echo "Commands:"
    echo ""
    echo "    create - Create the required S3 bucket and DynamoDB table."
    echo "    config - Create a terraform_config.tf file to configure "
    echo "         terraform to use the S3 backend."
    echo "    destroy - Remove the S3 bucket and DynamoDB table"
}

create () {
    echo "Creating an S3 bucket to store terraform state"
    aws s3api create-bucket \
        --region "${AWS_REGION}" \
        --create-bucket-configuration LocationConstraint="${AWS_REGION}" \
        --bucket "${terraform_bucket_name}"

    echo "Creating lock table in DynamoDB"
    aws dynamodb create-table \
        --region "${AWS_REGION}" \
        --table-name "${lock_table}" \
        --attribute-definitions AttributeName=LockID,AttributeType=S \
        --key-schema AttributeName=LockID,KeyType=HASH \
        --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1
}

config () {
    if [ -z "$1" ]; then
      echo "Usage: terraform_remote_state.sh config STATE_NAME"
      exit
    fi
    NAME="$1"

    # Dump out file
    cat <<EOF > ./terraform_config.tf
terraform {
    backend "s3" {
        bucket = "${terraform_bucket_name}"
        key = "${NAME}"
        region = "${AWS_REGION}"
        dynamodb_table = "${lock_table}"
        profile = "${AWS_PROFILE}"
    }
}
EOF
    echo "Remote terraform state storage output to terraform_config.tf"
}

destroy () {
    echo "Deleting terraform state bucket ${terraform_bucket_name}"
    aws s3api delete-bucket \
        --region "${AWS_REGION}" \
        --bucket "${terraform_bucket_name}"

    echo "Deleting terraform state lock table ${lock_table}"
    aws dynamodb delete-table \
        --region "${AWS_REGION}" \
        --table-name "${lock_table}"
}

# Run the command
if [ -z "$1" ]; then
  help
  exit
fi
$*
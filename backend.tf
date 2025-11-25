terraform {
  backend "s3" {
    # Production remote state stored in S3
    bucket  = "pod-6-project"
    key     = "prod/terraform.tfstate"
    region  = "eu-north-1"
    encrypt = true
    # NOTE: DynamoDB state locking intentionally disabled per request.
    # Using S3 only means Terraform will not acquire a DynamoDB lock. This
    # is acceptable for single-operator workflows but not recommended for
    # concurrent/team workflows because it does not prevent concurrent state
    # writes.
    acl = "bucket-owner-full-control"
  }
}

# Notes:
# - Create the DynamoDB lock table before running `terraform init` for the
#   first time (see PRODUCTION.md). Example:
#   aws dynamodb create-table --table-name pod-6-project-lock --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 --region eu-north-1
# - Do NOT commit AWS credentials. Ensure your CI or operator environment has
#   least-privilege IAM access to the S3 bucket and the DynamoDB table.
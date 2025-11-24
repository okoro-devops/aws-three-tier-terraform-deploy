terraform {
  backend "s3" {
    # Production remote state stored in S3
    bucket  = "pod-6-project"
    key     = "prod/terraform.tfstate"
    region  = "eu-north-1"
    encrypt = true
    # DynamoDB table used for state locking (create separately)
    dynamodb_table = "pod-6-project-lock"
    acl            = "bucket-owner-full-control"
  }
}

# Notes:
# - Create the DynamoDB lock table before running `terraform init` for the
#   first time (see PRODUCTION.md). Example:
#   aws dynamodb create-table --table-name pod-6-project-lock --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 --region eu-north-1
# - Do NOT commit AWS credentials. Ensure your CI or operator environment has
#   least-privilege IAM access to the S3 bucket and the DynamoDB table.
/*
Module `module-database` provider guidance

Best practices:
- Configure the `aws` provider at root and pass required inputs into this module.
- Do not store database credentials in plaintext; use Secrets Manager or SSM Parameter Store.

Example root usage:
# provider "aws" { region = "eu-north-1" }
# module "rds-mysql_deployment" {
#   source = "./module-database"
#   environment = var.environment
#   db_username = var.db_username
#   # Sensitive values should be provided via secure mechanisms
# }
*/
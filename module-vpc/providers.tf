/*
Module `module-vpc` provider guidance

Best practices:
- Keep provider configuration (aws) in the root module and do not hardcode credentials in modules.
- Modules should be reusable and not depend on a specific provider alias.

Example root usage:
# provider "aws" { region = "eu-north-1" }
# module "vpc_deployment" {
#   source = "./module-vpc"
#   environment = var.environment
#   # ...other inputs...
# }

Notes:
- The VPC module creates networking resources; ensure the caller has the necessary IAM permissions.
*/
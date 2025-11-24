/*
Module `module-dns` provider guidance

Best practices:
- Modules should avoid pinning provider versions; pin providers at the root.
- Configure the `aws` provider in the root module and pass provider aliases if the module needs them.

Example root configuration (recommended):

# provider "aws" { region = "eu-north-1" }
#
# module "dns_deployment" {
#   source = "./module-dns"
#   providers = {
#     aws = aws
#   }
#   # ...inputs...
# }

Notes:
- The module uses Route53 resources which require AWS credentials with appropriate permissions.
- Keep IAM credentials out of VCS; use environment credentials, assumed roles, or CI secrets.
*/

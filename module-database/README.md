# module-database

Purpose: deploy RDS MySQL instances with subnet group and security group.

Usage notes:
- Inputs: see `variables.tf` (db_name, db_username, db_password, subnet ids, instance class, allocated storage).
- Outputs: see `output.tf` for DB endpoint and connection info.

Recommendations:
- Store DB passwords and sensitive values in AWS Secrets Manager or SSM Parameter Store and reference them in the root module.
- Enable automated backups and set an appropriate retention window.
- Use Multi-AZ for production RDS instances for improved availability.

Security:
- Ensure the DB security group only allows access from application subnets or bastion hosts.
- Mark sensitive variables as `sensitive = true` in `variables.tf`.

Production deployment checklist and best practices

This document describes recommended production-grade practices for this repository.

1) State & Locking
- Use a remote S3 backend with server-side encryption (SSE-KMS preferred).
- Enable DynamoDB state locking (DynamoDB table with `LockID` partition key).
- Restrict access to the S3 bucket and DynamoDB table using IAM and bucket policies.

2) Provider Versioning
- Pin provider versions in `required_providers` and commit `.terraform.lock.hcl`.
- Test provider upgrades in a staging workspace before production.

3) Secrets & Sensitive Data
- Do NOT commit secrets in `terraform.tfvars`.
- Use a secrets manager (AWS Secrets Manager, SSM Parameter Store) or Terraform Cloud variables.
- Mark sensitive variables with `sensitive = true` in variable definitions.

4) Environments & Workspaces
- Use a single `prod` workspace or a dedicated prod workspace in Terraform Cloud.
- Keep staging/dev separate for testing provider / module upgrades.

5) IAM & Least Privilege
- Use least-privilege IAM roles for CI/CD and operators.
- Use separate IAM roles for EKS control-plane, node groups, and CI/CD.

6) Networking & Security
- Use private subnets for worker nodes; place public-facing services behind an ALB/NLB.
- Use Security Groups (not wide open) and Network ACLs as needed.
- Use Kubernetes Network Policies to limit pod-to-pod traffic.

7) Ingress, TLS & DNS
- Use `Service` type=LoadBalancer for ingress; prefer NLB for high-throughput or ALB for layer-7 routing.
- Use AWS Certificate Manager (ACM) for TLS certificates and attach to the LB.
- Use Route53 CNAMEs/A records to point to the LB.

8) Observability & Reliability
- Enable CloudWatch Container Insights or Prometheus + Grafana for metrics.
- Ship logs (CloudWatch Logs / EFK) and enable audit logging.
- Configure health checks and auto-scaling for node groups and deployments.

9) Backups & DR
- Enable automated RDS snapshots and snapshot retention policies.
- Consider snapshot/backup for EBS volumes if stateful workloads exist.

10) CI/CD & Automation
- Run `terraform fmt` and `tflint` in CI.
- Use `terraform plan` in CI and require manual approval for `apply` to prod.
- Keep IaC PRs small and reviewable.

11) Upgrades & Maintenance
- Test EKS version upgrades in staging.
- Use managed node groups and managed OS images where possible.
- Monitor pod density and CNI limits; scale node groups or use custom networking as needed.


If you'd like, I can:
- Create a `backend.tf` configured for S3/DynamoDB (if you provide bucket/table names),
- Mark sensitive variables and move sensitive values to SSM/Secrets Manager,
- Add a small `Makefile` or `scripts/` commands for common tasks (plan/apply/format).

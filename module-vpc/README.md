# module-vpc

Purpose: provision VPC, subnets, NAT gateways, route tables, and networking primitives used by the environment.

Usage notes:
- Inputs: see `variables.tf` for CIDR ranges, subnet counts, and tagging inputs.
- Outputs: see `output.tf` for subnet IDs and VPC ID used by other modules.

Recommendations:
- Use multiple AZs for high availability.
- Tag subnets properly (`kubernetes.io/cluster/<name>` and `kubernetes.io/role/elb` when needed) so AWS services can discover them.
- Keep public and private subnets separate; place nodes in private subnets and use NAT for outbound internet.

Security:
- Harden network ACLs and Security Groups; avoid overly permissive rules.

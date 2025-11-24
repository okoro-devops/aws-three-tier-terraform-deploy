# module-dns

Purpose: manage DNS records and hosted zones (Route53 / Namecheap helper files).

Usage notes:
- Inputs: see `variables.tf` in this folder (domain_name, environment, nginx_ingress_lb_dns, node_ips_public, node_ips_private, create_records, node_record_source).
- Outputs: see `output.tf` for the fqdn outputs returned to the root module.

Recommendations:
- Use a centralized production hosted zone and grant the Terraform IAM role least-privilege rights to manage records.
- For public-facing services prefer an AWS Load Balancer and CNAME records rather than pointing records to node IPs.
- For internal-only services consider using a private hosted zone associated with your VPC.

Security:
- Do not commit DNS provider credentials; use secure CI secrets or IAM roles.

# module-eks

Purpose: provision an EKS cluster and related node groups, along with Helm-managed addons (ingress, cert-manager, argocd).

Usage notes:
- This module expects the root module to configure `aws` provider and to create EKS cluster data sources when needed.
- For Kubernetes and Helm operations it's recommended to configure aliased `kubernetes` and `helm` providers in the root and pass them into this module using the `providers = { ... }` map.

Inputs: (see `variables.tf` in this folder)
- `environment`, `cluster_name`, `eks_version`, `instance_types`, `public_subnet_ids`, `private_subnet_ids`, etc.

Outputs: (see `output.tf`)
- `nginx_lb_ip`, `nginx_ingress_lb_dns`, `nginx_node_ips_public`, `nginx_node_ips_private`, etc.

Notes:
- The module contains Helm charts and may rely on the Kubernetes API being accessible during `apply`.
- Use exec-based provider auth (`aws eks get-token`) to avoid token expiry during long `terraform apply` runs.

If you need me to normalize variables or mark sensitive inputs, tell me which ones to flag.

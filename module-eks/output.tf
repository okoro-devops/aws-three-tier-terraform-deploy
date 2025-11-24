# output "nginx_ingress_lb_dns" {
#   value = data.aws_lb.nginx_ingress.dns_name
# }

# output "nginx_lb_ip" {
#   value = data.aws_lb.nginx_ingress.ip_address_type == "ipv4" ? data.aws_lb.nginx_ingress.dns_name : ""
# }
# output "nginx_ingress_load_balancer_hostname" {
#   value = data.aws_lb.nginx_ingress.dns_name
# }

# ==========================
# Outputs for NGINX Ingress Load Balancer
# ==========================

# Fetch the AWS Load Balancer created by the NGINX Ingress
## When using NodePort there is no AWS load balancer to query. Return the
## service's external hostname when present, otherwise empty string.
output "nginx_lb_ip" {
  value = try(
    data.kubernetes_service.nginx_ingress.status[0].load_balancer[0].ingress[0].ip,
    ""
  )
}

output "nginx_ingress_lb_dns" {
  value = try(
    data.kubernetes_service.nginx_ingress.status[0].load_balancer[0].ingress[0].hostname,
    ""
  )
}

output "nginx_ingress_load_balancer_hostname" {
  value = try(
    data.kubernetes_service.nginx_ingress.status[0].load_balancer[0].ingress[0].hostname,
    ""
  )
}

output "nginx_lb_dns" {
  description = "DNS hostname of the NGINX Ingress Load Balancer (if any)"
  value       = try(data.kubernetes_service.nginx_ingress.status[0].load_balancer[0].ingress[0].hostname, "")
}

# Gather EC2 instances that are part of the EKS cluster node group(s)
data "aws_instances" "eks_nodes" {
  filter {
    name   = "tag:kubernetes.io/cluster/${var.environment}-${var.cluster_name}"
    values = ["owned"]
  }
}

data "aws_instance" "eks_node_instances" {
  for_each    = toset(data.aws_instances.eks_nodes.ids)
  instance_id = each.value
}

# Public IPs (if any) of the nodes
output "nginx_node_ips_public" {
  value = try([for i in data.aws_instance.eks_node_instances : i.public_ip if i.public_ip != ""], [])
}

# Private IPs of the nodes
output "nginx_node_ips_private" {
  value = try([for i in data.aws_instance.eks_node_instances : i.private_ip], [])
}

# NodePort used by the ingress service (if available)
## NodePort output removed — service spec.ports may not be available via this data source.




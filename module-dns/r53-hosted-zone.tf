resource "aws_route53_zone" "r53_zone" {
  name          = var.domain_name
  comment       = "Managed by Terraform"
  force_destroy = true

  tags = {
    Name        = "${var.environment}-hosted-zone"
    Environment = var.environment
  }
}

## Resolve whichever LB DNS variable is supplied (legacy or new)
locals {
  lb_dns = var.nginx_lb_dns != "" ? var.nginx_lb_dns : (var.nginx_ingress_lb_dns != "" ? var.nginx_ingress_lb_dns : "")
}

## Note: creating a CNAME at the zone apex (the naked domain) is invalid
## because the zone already has SOA/NS records. Only create subdomain
## CNAME records when an upstream LB DNS is provided.

locals {
  # Prefer public node IPs if requested, otherwise private
  node_ips = length(var.node_ips_public) > 0 && var.node_record_source == "public" ? var.node_ips_public : var.node_ips_private
}

resource "aws_route53_record" "frontend_cname" {
  count   = var.create_records && local.lb_dns != "" ? 1 : 0
  zone_id = aws_route53_zone.r53_zone.zone_id
  name    = "bank.${var.domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = [local.lb_dns]
}

resource "aws_route53_record" "frontend_a" {
  count   = var.create_records && local.lb_dns == "" && length(local.node_ips) > 0 ? 1 : 0
  zone_id = aws_route53_zone.r53_zone.zone_id
  name    = "bank.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = local.node_ips
}

resource "aws_route53_record" "backend_cname" {
  count   = var.create_records && local.lb_dns != "" ? 1 : 0
  zone_id = aws_route53_zone.r53_zone.zone_id
  name    = "bankapi.${var.domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = [local.lb_dns]
}

resource "aws_route53_record" "backend_a" {
  count   = var.create_records && local.lb_dns == "" && length(local.node_ips) > 0 ? 1 : 0
  zone_id = aws_route53_zone.r53_zone.zone_id
  name    = "bankapi.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = local.node_ips
}

resource "aws_route53_record" "argocd_cname" {
  count   = var.create_records && local.lb_dns != "" ? 1 : 0
  zone_id = aws_route53_zone.r53_zone.zone_id
  name    = "argocd.${var.domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = [local.lb_dns]
}

resource "aws_route53_record" "argocd_a" {
  count   = var.create_records && local.lb_dns == "" && length(local.node_ips) > 0 ? 1 : 0
  zone_id = aws_route53_zone.r53_zone.zone_id
  name    = "argocd.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = local.node_ips
}










# resource "aws_route53_zone" "r53_zone" {
#     name = var.domain-name
#     comment = "Managed by Terraform"
#     force_destroy = true

#     tags = {
#         Name        = "${var.environment}-hosted-zone"
#         Environment = var.environment
#     }
# }
# resource "aws_route53_record" "name" {
#     zone_id = aws_route53_zone.r53_zone.zone_id
#     name    = "bank.${var.domain-name}" # Use a subdomain for CNAME
#     type    = "CNAME"
#     ttl     = 300
#     records = [var.nginx_lb_ip]
#   }

# resource "aws_route53_record" "name1" {
#     zone_id = aws_route53_zone.r53_zone.zone_id
#     name    = "bankapi.${var.domain-name}" # Use a subdomain for CNAME
#     type    = "CNAME"
#     ttl     = 300
#     records = [var.nginx_lb_ip]
#   }
# resource "aws_route53_record" "name2" {
#     zone_id = aws_route53_zone.r53_zone.zone_id
#     name    = "argocd.${var.domain-name}" # Use a subdomain for CNAME
#     type    = "CNAME"
#     ttl     = 300
#     records = [var.nginx_lb_ip]
#   }
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

# -----------------------------
# FRONTEND (uses LB only)
# -----------------------------
resource "aws_route53_record" "frontend_cname" {
  count   = var.create_records ? 1 : 0
  zone_id = aws_route53_zone.r53_zone.zone_id
  name    = "bank.${var.domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = [local.lb_dns]
}

# -----------------------------
# BACKEND API (uses LB only)
# -----------------------------
resource "aws_route53_record" "backend_cname" {
  count   = var.create_records ? 1 : 0
  zone_id = aws_route53_zone.r53_zone.zone_id
  name    = "bankapi.${var.domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = [local.lb_dns]
}

# -----------------------------
# ARGO CD (uses LB only)
# -----------------------------
resource "aws_route53_record" "argocd_cname" {
  count   = var.create_records ? 1 : 0
  zone_id = aws_route53_zone.r53_zone.zone_id
  name    = "argocd.${var.domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = [local.lb_dns]
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





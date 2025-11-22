# Create Route53 Hosted Zone
resource "aws_route53_zone" "r53_zone" {
  name          = var.domain-name
  comment       = "Managed by Terraform"
  force_destroy = true

  tags = {
    Name        = "${var.environment}-hosted-zone"
    Environment = var.environment
  }
}

# Frontend subdomain
resource "aws_route53_record" "frontend" {
  zone_id = aws_route53_zone.r53_zone.zone_id
  name    = "bank.${var.domain-name}"
  type    = "CNAME"
  ttl     = 300
  records = [var.nginx_lb_ip]
}

# Backend API
resource "aws_route53_record" "backend" {
  zone_id = aws_route53_zone.r53_zone.zone_id
  name    = "bankapi.${var.domain-name}"
  type    = "CNAME"
  ttl     = 300
  records = [var.nginx_lb_ip]
}

# ArgoCD
resource "aws_route53_record" "argocd" {
  zone_id = aws_route53_zone.r53_zone.zone_id
  name    = "argocd.${var.domain-name}"
  type    = "CNAME"
  ttl     = 300
  records = [var.nginx_lb_ip]
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
# Create Route53 Hosted Zone
resource "aws_route53_zone" "r53_zone" {
  name          = var.domain_name
  comment       = "Managed by Terraform"
  force_destroy = true

  tags = {
    Name        = "${var.environment}-hosted-zone"
    Environment = var.environment
  }
}

# Frontend subdomain
resource "aws_route53_record" "frontend_cname" {
  zone_id = aws_route53_zone.r53_zone.zone_id
  name    = "bank.${var.domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = [var.nginx_ingress_lb_dns]
}

# Backend API
resource "aws_route53_record" "backend_cname" {
  zone_id = aws_route53_zone.r53_zone.zone_id
  name    = "bankapi.${var.domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = [var.nginx_ingress_lb_dns]
}

# ArgoCD
resource "aws_route53_record" "argocd_cname" {
  zone_id = aws_route53_zone.r53_zone.zone_id
  name    = "argocd.${var.domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = [var.nginx_ingress_lb_dns]
}






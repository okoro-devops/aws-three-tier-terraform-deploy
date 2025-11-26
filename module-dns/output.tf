output "frontend_dns" {
  value = aws_route53_record.frontend_cname.fqdn
}

output "backend_dns" {
  value = aws_route53_record.backend_cname.fqdn
}

output "argocd_dns" {
  value = aws_route53_record.argocd_cname.fqdn
}



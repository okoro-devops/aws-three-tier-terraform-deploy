# output "route53_name_servers" {
#      description = "The name servers of the Route 53 hosted zone"
#      value       = aws_route53_zone.r53_zone.name_servers
#  }

# Output nameservers for manual Namecheap configuration
output "route53_name_servers" {
  description = "Route53 NS to copy manually to Namecheap"
  value       = aws_route53_zone.r53_zone.name_servers
}

output "frontend_dns" {
  value = length(aws_route53_record.frontend_cname) > 0 ? aws_route53_record.frontend_cname[0].fqdn : (length(aws_route53_record.frontend_a) > 0 ? aws_route53_record.frontend_a[0].fqdn : "")
}

output "backend_dns" {
  value = length(aws_route53_record.backend_cname) > 0 ? aws_route53_record.backend_cname[0].fqdn : (length(aws_route53_record.backend_a) > 0 ? aws_route53_record.backend_a[0].fqdn : "")
}

output "argocd_dns" {
  value = length(aws_route53_record.argocd_cname) > 0 ? aws_route53_record.argocd_cname[0].fqdn : (length(aws_route53_record.argocd_a) > 0 ? aws_route53_record.argocd_a[0].fqdn : "")
}

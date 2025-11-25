# output "route53_name_servers" {
#      description = "The name servers of the Route 53 hosted zone"
#      value       = aws_route53_zone.r53_zone.name_servers
#  }

# Output nameservers for manual Namecheap configuration
output "frontend_dns" {
  description = "Frontend DNS name"
  value       = length(aws_route53_record.frontend_cname) > 0 ? aws_route53_record.frontend_cname[0].fqdn : ""
}

output "backend_dns" {
  description = "Backend API DNS name"
  value       = length(aws_route53_record.backend_cname) > 0 ? aws_route53_record.backend_cname[0].fqdn : ""
}

output "argocd_dns" {
  description = "ArgoCD DNS name"
  value       = length(aws_route53_record.argocd_cname) > 0 ? aws_route53_record.argocd_cname[0].fqdn : ""
}

output "hosted_zone_id" {
  value       = aws_route53_zone.r53_zone.zone_id
  description = "Hosted zone ID"
}

output "hosted_zone_name" {
  value       = aws_route53_zone.r53_zone.name
  description = "Hosted zone name"
}


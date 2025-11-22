# output "route53_name_servers" {
#      description = "The name servers of the Route 53 hosted zone"
#      value       = aws_route53_zone.r53_zone.name_servers
#  }

# Output nameservers for manual Namecheap configuration
output "route53_name_servers" {
  description = "Route53 NS to copy manually to Namecheap"
  value       = aws_route53_zone.r53_zone.name_servers
}
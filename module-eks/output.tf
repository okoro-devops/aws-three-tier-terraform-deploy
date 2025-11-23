# output "nginx_ingress_lb_dns" {
#   value = data.aws_lb.nginx_ingress.dns_name
# }

# output "nginx_lb_ip" {
#   value = data.aws_lb.nginx_ingress.ip_address_type == "ipv4" ? data.aws_lb.nginx_ingress.dns_name : ""
# }
# output "nginx_ingress_load_balancer_hostname" {
#   value = data.aws_lb.nginx_ingress.dns_name
# }

output "nginx_ingress_lb_dns" {
  description = "NGINX Ingress LoadBalancer DNS name"
  value       = data.kubernetes_service.nginx_ingress.status[0].load_balancer[0].ingress[0].hostname
}

output "nginx_lb_ip" {
  description = "NGINX Ingress LoadBalancer IP (if IPv4)"
  value = (
    length(data.kubernetes_service.nginx_ingress.status[0].load_balancer[0].ingress) > 0 &&
    lookup(data.kubernetes_service.nginx_ingress.status[0].load_balancer[0].ingress[0], "ip", "") != ""
  ) ? data.kubernetes_service.nginx_ingress.status[0].load_balancer[0].ingress[0].ip : ""
}

output "nginx_ingress_load_balancer_hostname" {
  description = "NGINX Ingress LoadBalancer Hostname"
  value       = data.kubernetes_service.nginx_ingress.status[0].load_balancer[0].ingress[0].hostname
}


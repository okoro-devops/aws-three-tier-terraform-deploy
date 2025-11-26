# =====================================
# Outputs for EKS Helm Addons
# =====================================
output "nginx_lb_ip" {
  value = data.aws_lb.nginx_ingress.dns_name
}


output "nginx_ingress_load_balancer_hostname" {
  value = data.aws_lb.nginx_ingress.dns_name
}








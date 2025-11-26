variable "environment" {}

variable "domain_name" {
  description = "Domain name managed manually in Namecheap"
}

variable "nginx_ingress_lb_dns" {
  description = "DNS name of the NGINX Ingress Load Balancer"
  type        = string
}

variable "nginx_lb_ip" {
  description = "IP address of the NGINX Ingress Load Balancer"
  type        = string
}

variable "nginx_ingress_load_balancer_hostname" {
  description = "Hostname of the NGINX Ingress Load Balancer"
  type        = string
}
variable "frontend_lb_dns" {
  description = "DNS name of the Frontend Load Balancer"
  type        = string
  
}
variable "backend_lb_dns" {
  description = "DNS name of the Backend Load Balancer"
  type        = string
}
variable "argocd_lb_dns" {
  description = "DNS name of the ArgoCD Load Balancer"
  type        = string
  
}
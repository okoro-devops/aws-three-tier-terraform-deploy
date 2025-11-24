# variable "environment" {}
# variable "domain-name" {}
# variable "nginx_ingress_lb_dns" {
#   description = "DNS name of the NGINX Ingress Load Balancer"
#   type        = string  

# }
# variable "nginx_lb_ip" {
#   description = "IP address of the NGINX Ingress Load Balancer"
#   type        = string
# }
# variable "nginx_ingress_load_balancer_hostname" {
#   description = "Hostname of the NGINX Ingress Load Balancer"
#   type        = string
# }


variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "domain_name" {
  description = "Domain name managed manually in Namecheap"
  type        = string
}

variable "nginx_lb_dns" {
  description = "DNS name of the NGINX Ingress Load Balancer (legacy variable)"
  type        = string
  default     = ""
}

variable "nginx_ingress_lb_dns" {
  description = "DNS name of the NGINX Ingress Load Balancer (new name expected from root module)"
  type        = string
  default     = ""
}

variable "nginx_lb_ip" {
  description = "Optional IP address of the NGINX Ingress Load Balancer"
  type        = string
  default     = ""
}

variable "nginx_ingress_load_balancer_hostname" {
  description = "Optional hostname of the NGINX Ingress Load Balancer"
  type        = string
  default     = ""
}

variable "create_records" {
  description = "Create Route53 records for application subdomains"
  type        = bool
  default     = false
}

variable "node_ips_public" {
  description = "Public IPs of cluster nodes (used for A records when no LB exists)"
  type        = list(string)
  default     = []
}

variable "node_ips_private" {
  description = "Private IPs of cluster nodes (fallback for A records)"
  type        = list(string)
  default     = []
}

variable "node_record_source" {
  description = "Which node IPs to use for A records: 'public' or 'private'"
  type        = string
  default     = "public"
}

variable "node_port" {
  description = "NodePort exposed by the ingress controller (informational)"
  type        = number
  default     = 0
}

variable "vpc_cidrblock" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "192.168.0.0/16"

}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "staging"

}

variable "create_subnet" {
  description = "Flag to create a subnet"
  type        = bool
  default     = true
}

variable "countsub" {
  description = "Number of subnets to create"
  type        = number
  default     = 2

}
variable "create_elastic_ip" {
  description = "Flag to create Elastic IPs"
  type        = bool
  default     = true
}

variable "desired_size" {
  description = "Desired size of the EKS node group"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum size of the EKS node group"
  type        = number
  default     = 6
}

variable "min_size" {
  description = "Minimum size of the EKS node group"
  type        = number
  default     = 2
}

variable "instance_types" {
  description = "Instance types for the EKS node group"
  type        = list(string)
  default     = ["t2.micro"]
}

variable "capacity_type" {
  description = "Capacity type for the EKS node group"
  type        = string
  default     = "ON_DEMAND"
}
variable "eks_version" {
  description = "EKS cluster version"
  type        = string
  default     = "1.33"
}
variable "ami_type" {
  description = "AMI type for the EKS node group; when empty the module auto-selects based on eks_version"
  type        = string
  default     = ""
}

variable "label_one" {
  description = "Label for the EKS node group"
  type        = string
  default     = "system"
}

# variable "subnet_ids" {
#   type = list(string)
# }
variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs to place public-facing resources"
}
variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs"
}
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "repository_name" {
  description = "Container repository name (ECR) used by workloads"
  type        = string
}

variable "domain_name" {
  description = "Domain name for certificates / DNS"
  type        = string
  default     = "example.com"
}
variable "email" {
  description = "Contact email used for certificates and notifications"
  type        = string
}
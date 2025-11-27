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
  default     = ["t2.medium"]
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
## The following variables are currently unused in this repository.
## They are commented out to avoid lint warnings but left here
## so you can re-enable them easily if needed.

# variable "ami_type" {
#   description = "AMI type for the EKS node group"
#   type        = string
#   default     = "AL2_x86_64" # Use AL2_x86_64 for x86 instances, AL2_ARM_64 for ARM instances
# }
#
# variable "label_one" {
#   description = "Label for the EKS node group"
#   type        = string
#   default     = "system"
# }
#
# variable "zone_name" {
#   description = "Name of the DNS zone"
#   type        = string
#   default     = "example.com"
# }

variable "domain_name" {
  description = "Alternate variable name for domain (compatibility with modules)"
  type        = string
  default     = "myapp.example.com"
}

## Namecheap integration variables (commented out — configure Namecheap manually)
# variable "namecheap_api_user" {
#   description = "Namecheap API user"
#   type        = string
# }
# variable "namecheap_api_key" {
#   description = "Namecheap API key"
#   type        = string
# }
# variable "namecheap_username" {
#   description = "Namecheap username"
#   type        = string
# }
# variable "namecheap_client_ip" {
#   description = "Client IP for Namecheap API access"
#   type        = string
# }

#===========

variable "db_instance_class" {
  description = "Instance class for the RDS database"
  type        = string
  default     = "db.t3.medium"
}

variable "db_allocated_storage" {
  description = "Storage allocated to the DB instance (in GB)"
  type        = number
  default     = 20
}

variable "db_subnet_group_name" {
  description = "Name of the DB subnet group"
  type        = string
  default     = "my-db-subnet-group"
}

variable "db_username" {
  description = "Username for the database"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Password for the database"
  type        = string
  default     = "password123"
  sensitive   = true
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "production_db"
}
variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "eks-cluster"
}

variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "eks-repository"

}

variable "email" {
  description = "Email address for notifications and certificates"
  type        = string
  default     = "okoro.christianpeace@gmail.com"
}
variable "vpc_cidr" {
  type = string
}

variable "azs" {
  type = list(string)
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "private_db_subnet_cidrs" {
  type = list(string)
}

variable "ami_type" {
  type    = string
  default = "AL2023_x86_64_STANDARD"
}


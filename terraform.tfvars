# environment       = "production"
# vpc_cidrblock     = "192.168.0.0/16"
# countsub          = 2
# create_subnet     = true
# create_elastic_ip = true
# desired_size      = 2
# max_size          = 6
# min_size          = 2
# instance_types    = ["t3.medium"]
# capacity_type     = "ON_DEMAND"
# #ami_type          = "AL2023_x86_64"
# #label_one         = "system-nodepool"
# eks_version       = "1.33"
# domain_name       = "mypodsix.online"
# cluster_name      = "production-eks-cluster"
# repository_name   = "eks-repository"
# email             = "okoro.christianpeace@gmail.com"
environment = "production"

# VPC CIDR
vpc_cidr = "192.168.0.0/16"

# Availability Zones
azs = ["us-east-1a", "us-east-1b"]

# Public Subnets
public_subnet_cidrs = [
  "192.168.1.0/24",
  "192.168.2.0/24"
]

# Private Subnets
private_subnet_cidrs = [
  "192.168.3.0/24",
  "192.168.4.0/24"
]

# Private DB Subnets
private_db_subnet_cidrs = [
  "192.168.5.0/24",
  "192.168.6.0/24"
]

desired_size = 2
max_size     = 6
min_size     = 2

instance_types = ["t3.medium"]
capacity_type  = "ON_DEMAND"
eks_version    = "1.33"
ami_type       = "AL2023_x86_64_STANDARD"

domain_name     = "mypodsix.online"
cluster_name    = "eks-cluster"
repository_name = "eks-repository"
email           = "okoro.christianpeace@gmail.com"

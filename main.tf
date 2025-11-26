# ==========================
# Stage 1: VPC & Networking
# ==========================
# module "vpc_deployment" {
#   source            = "./module-vpc"
#   environment       = var.environment
#   vpc_cidr     = var.vpc_cidr
#   countsub          = var.countsub
#   create_subnet     = var.create_subnet
#   create_elastic_ip = var.create_elastic_ip

# }

module "vpc_deployment" {
  source = "./module-vpc"

  environment             = var.environment
  vpc_cidr                = var.vpc_cidr
  azs                     = var.azs
  public_subnet_cidrs     = var.public_subnet_cidrs
  private_subnet_cidrs    = var.private_subnet_cidrs
  private_db_subnet_cidrs = var.private_db_subnet_cidrs
}


# ==========================
# Stage 2: EKS Cluster
# ==========================
module "eks_deployment" {
  source             = "./module-eks"
  environment        = var.environment
  cluster_name       = var.cluster_name
  eks_version        = var.eks_version
  desired_size       = var.desired_size
  max_size           = var.max_size
  min_size           = var.min_size
  instance_types     = var.instance_types
  capacity_type      = var.capacity_type
  public_subnet_ids  = module.vpc_deployment.public_subnet_ids
  private_subnet_ids = module.vpc_deployment.private_subnet_ids
  repository_name    = var.repository_name
  domain-name        = var.domain_name
  email              = var.email
}


module "dns_deployment" {
  source = "./module-dns"

  environment = var.environment
  domain_name = var.domain_name

  frontend_lb_dns = module.eks_deployment.nginx_ingress_lb_dns
  backend_lb_dns  = module.eks_deployment.nginx_ingress_lb_dns
  argocd_lb_dns   = module.eks_deployment.nginx_ingress_lb_dns

  nginx_lb_ip                          = module.eks_deployment.nginx_lb_ip
  nginx_ingress_lb_dns                 = module.eks_deployment.nginx_ingress_lb_dns
  nginx_ingress_load_balancer_hostname = module.eks_deployment.nginx_ingress_load_balancer_hostname
}


# ==========================
# Stage 4: RDS MySQL
# ==========================
module "rds-mysql_deployment" {
  source                 = "./module-database"
  private_subnet_db_ids   = module.vpc_deployment.private_subnet_ids   # or private_subnet_db_ids if separate
  aws_security_group_ids  = module.vpc_deployment.mysql_security_group_id
  environment            = var.environment
  db_instance_class      = var.db_instance_class
  db_allocated_storage   = var.db_allocated_storage
  db_name                = var.db_name
  db_password            = var.db_password
  db_username            = var.db_username
  # Optional depends_on is fine for VPC
  depends_on = [module.vpc_deployment]
}






# # Creating a VPC and EKS cluster using Terraform
# module "vpc-deployment" {
#     source = "./module-vpc"

#     environment = var.environment
#     vpc_cidrblock = var.vpc_cidrblock
#     countsub = var.countsub
#     create_subnet = var.create_subnet
#     create_elastic_ip = var.create_elastic_ip

# }

# #creating an EKS cluster using Terraform
# # and deploying it in the VPC created above
# module "eks-deployment" {
#     source = "./module-eks"

#     environment = var.environment
#     vpc_cidrblock = var.vpc_cidrblock
#     countsub = var.countsub
#     create_subnet = var.create_subnet
#     create_elastic_ip = var.create_elastic_ip
#     desired_size = var.desired_size
#     max_size = var.max_size
#     min_size = var.min_size
#     instance_types = var.instance_types
#     capacity_type = var.capacity_type
#     public_subnet_ids  = module.vpc-deployment.public_subnet_ids
#     private_subnet_ids = module.vpc-deployment.private_subnet_ids
#     cluster_name = var.cluster_name
#     repository_name = var.repository_name
#     domain-name = var.domain-name
#     email = var.email

# }
# module "dns-deployment" {
#   source = "./module-dns"

#   environment                     = var.environment
#   domain-name                     = var.domain-name

#   nginx_lb_ip                     = module.eks-deployment.nginx_lb_ip
#   nginx_ingress_lb_dns            = module.eks-deployment.nginx_ingress_lb_dns
#   nginx_ingress_load_balancer_hostname = module.eks-deployment.nginx_ingress_load_balancer_hostname
# }



# # module "namecheap-deployment" {     #First commented out
# #     source = "./module-dns"
# #     environment = var.environment
# #     domain-name = var.domain-name
# #     nginx_lb_ip = module.eks-deployment.nginx_lb_ip
# #     nginx_ingress_load_balancer_hostname = module.eks-deployment.nginx_ingress_load_balancer_hostname
# #     nginx_ingress_lb_dns = module.eks-deployment.nginx_ingress_lb_dns

# # }

# module "rds-mysql-deployment" {
#     source = "./module-database"
#     environment = var.environment
#     db_instance_class = var.db_instance_class
#     db_allocated_storage = var.db_allocated_storage
#     private_subnet_db_ids = module.vpc-deployment.private_subnet_db_ids
#     db_name =  var.db_name
#     db_password = var.db_password
#     db_username = var.db_username
#     aws_security_group_ids = module.vpc-deployment.aws_security_group_ids
# }
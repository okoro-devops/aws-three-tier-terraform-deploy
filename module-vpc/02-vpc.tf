resource "aws_vpc" "Project-VPC" {
  cidr_block = var.vpc_cidrblock
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.environment}-vpc"
    Environment = var.environment
  }
  
}

resource "aws_internet_gateway" "Project-igw" {
  vpc_id = aws_vpc.Project-VPC.id
  tags = {
    Name = "${var.environment}-igw"
    Environment = var.environment
  }
  
}

resource "aws_subnet" "Projec-public-subnet" {
  vpc_id = aws_vpc.Project-VPC.id
  cidr_block = var.vpc_cidrblock
  tags = {
    Name = "${var.environment}"
    Enviroment = var.environment
  }
  
}
resource "aws_subnet" "Project-private-subnet" {
  vpc_id = aws_vpc.Project-VPC.id
  cidr_block = var.vpc_cidrblock
  tags = {
    Name = "${var.environment}"
    Enviroment = var.environment
  }
  
}

resource "aws_subnet" "Project-private-subnet-db" {
  vpc_id = aws_vpc.Project-VPC.id
  cidr_block = var.vpc_cidrblock
  tags = {
    Name = "${var.environment}"
    Enviroment = var.environment
  }
  
}









# resource "aws_vpc" "vpc-main" {
#   cidr_block       = var.vpc_cidrblock
#   instance_tenancy = "default"
#   enable_dns_support = true
#   enable_dns_hostnames = true
#   assign_generated_ipv6_cidr_block = false
#   tags = {
#     Name = "${var.environment}-vpc"
#     Environment = var.environment
#   }
# }
# ==========================
# VPC
# ==========================
resource "aws_vpc" "main" {
  cidr_block                       = var.vpc_cidrblock
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = false
  instance_tenancy                 = "default"

  tags = {
    Name        = "${var.environment}-vpc"
    Environment = var.environment
  }
}
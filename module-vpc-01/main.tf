// module-vpc rewritten: single-file module (main.tf) for VPC with
// - N public subnets (map_public_ip_on_launch = true)
// - N private subnets for worker nodes (route to NAT)
// - N private subnets for DB (route to NAT)
// - Internet Gateway, Elastic IPs, NAT Gateways (one per public subnet/AZ)
// - Route tables and associations
// - EKS-friendly tags
// - Outputs and variables

// (Diagram used while designing: /mnt/data/e4232cf6-4b79-41be-893e-300271854824.png)

// -------------------------
// Data
// -------------------------
data "aws_availability_zones" "available" {
  state = "available"
}

// -------------------------
// VPC + IGW
// -------------------------
resource "aws_vpc" "this" {
  cidr_block                       = var.vpc_cidrblock
  enable_dns_support               = true
  enable_dns_hostnames             = true
  instance_tenancy                 = "default"
  assign_generated_ipv6_cidr_block = false

  tags = {
    Name        = "${var.environment}-vpc"
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "${var.environment}-internet-gateway"
    Environment = var.environment
  }
}

// -------------------------
// Public subnets (N)
// -------------------------
resource "aws_subnet" "public" {
  count                   = var.az_count
  vpc_id                  = aws_vpc.this.id
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = cidrsubnet(var.vpc_cidrblock, 8, count.index)
  map_public_ip_on_launch = true

  tags = merge(var.common_tags, {
    Name                             = "${var.environment}-public-${count.index + 1}-${data.aws_availability_zones.available.names[count.index]}"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "kubernetes.io/role/elb" = "1"
  })
}

// -------------------------
// Private subnets for workers (N)
// -------------------------
resource "aws_subnet" "private" {
  count             = var.az_count
  vpc_id            = aws_vpc.this.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = cidrsubnet(var.vpc_cidrblock, 8, var.az_count + count.index)

  tags = merge(var.common_tags, {
    Name                             = "${var.environment}-private-${count.index + 1}-${data.aws_availability_zones.available.names[count.index]}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb" = "1"
  })
}

// -------------------------
// Private subnets for DB (N)
// -------------------------
resource "aws_subnet" "private_db" {
  count             = var.az_count
  vpc_id            = aws_vpc.this.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = cidrsubnet(var.vpc_cidrblock, 8, var.az_count * 2 + count.index)

  tags = merge(var.common_tags, {
    Name                             = "${var.environment}-private-db-${count.index + 1}-${data.aws_availability_zones.available.names[count.index]}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb" = "1"
  })
}

// -------------------------
// Elastic IPs and NAT Gateways (one per public subnet)
// -------------------------
resource "aws_eip" "nat" {
  count = var.create_nat ? var.az_count : 0
  vpc_= true
 

  tags = merge(var.common_tags, { Name = "${var.environment}-eip-nat-${count.index + 1}" })

  depends_on = [aws_internet_gateway.this]
}

resource "aws_nat_gateway" "this" {
  count         = var.create_nat ? var.az_count : 0
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(var.common_tags, { Name = "${var.environment}-nat-${count.index + 1}" })

  depends_on = [aws_internet_gateway.this]
}

// -------------------------
// Public route table (uses VPC's main route table by default) but we will explicitly create a public RT as well
// -------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.common_tags, { Name = "${var.environment}-public-rt" })
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public_assoc" {
  count          = var.az_count
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

// -------------------------
// Private route tables (one per AZ) -> route to NAT gateway in same AZ
// -------------------------
resource "aws_route_table" "private" {
  count  = var.az_count
  vpc_id = aws_vpc.this.id

  tags = merge(var.common_tags, { Name = "${var.environment}-private-rt-${count.index + 1}" })
}

resource "aws_route" "private_default" {
  count                  = var.create_nat ? var.az_count : 0
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[count.index].id
}

resource "aws_route_table_association" "private_assoc" {
  count          = var.az_count
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id

  depends_on = [aws_nat_gateway.this]
}

resource "aws_route_table_association" "private_db_assoc" {
  count          = var.az_count
  subnet_id      = aws_subnet.private_db[count.index].id
  route_table_id = aws_route_table.private[count.index].id

  depends_on = [aws_nat_gateway.this]
}

// -------------------------
// Security group for RDS example
// -------------------------
resource "aws_security_group" "mysql_sg" {
  name        = "${var.environment}-mysql-sg"
  description = "Security group for MySQL database"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidrblock]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, { Name = "${var.environment}-mysql-sg" })
}

// -------------------------
// Outputs
// -------------------------
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = aws_subnet.private[*].id
}

output "private_subnet_db_ids" {
  description = "List of private DB subnet IDs"
  value       = aws_subnet.private_db[*].id
}

output "nat_gateway_ids" {
  value = aws_nat_gateway.this[*].id
  description = "NAT Gateway IDs (one per AZ)"
}

output "mysql_security_group_id" {
  value = aws_security_group.mysql_sg.id
}

// -------------------------
// Variables (defaults)
// -------------------------
variable "vpc_cidrblock" {
  type    = string
  default = "192.168.0.0/16"
}

variable "environment" {
  type    = string
  default = "production"
}

variable "az_count" {
  type    = number
  default = 2
  description = "Number of AZs (subnets per public/private/db). Keep <= available AZs."
}

variable "create_nat" {
  type    = bool
  default = true
}

variable "create_elastic_ip" {
  type    = bool
  default = true
}

variable "cluster_name" {
  type    = string
  default = "eks-cluster"
}

variable "common_tags" {
  type    = map(string)
  default = {
    ManagedBy = "terraform"
  }
}

// -------------------------
// Notes
// -------------------------
// - cidrsubnet() is used to carve /24s from the VPC. Adjust if you want different sizes.
// - For production, consider creating a NAT per AZ (this module does), and a single EIP per NAT.
// - Ensure `az_count` <= length(data.aws_availability_zones.available.names)
// - This single-file module can be split into multiple files (variables.tf, outputs.tf, main.tf) as desired.

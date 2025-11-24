# ==========================
# Private Subnets for DB
# ==========================
resource "aws_subnet" "private_db" {
  count             = var.countsub
  vpc_id            = aws_vpc.main.id
  availability_zone = sort(data.aws_availability_zones.available.names)[count.index]
  cidr_block        = "192.168.${count.index + 20}.0/24"

  tags = {
    Name                                                           = "${var.environment}-private-subnet-db-${count.index + 1}"
    Environment                                                    = var.environment
    "kubernetes.io/role/internal-elb"                              = "1"
    "kubernetes.io/cluster/${var.environment}-${var.cluster_name}" = "owned"
  }
}




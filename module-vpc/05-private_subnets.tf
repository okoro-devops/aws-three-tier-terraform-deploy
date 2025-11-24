# ==========================
# Private Subnets
# ==========================
resource "aws_subnet" "private" {
  count             = var.countsub
  vpc_id            = aws_vpc.main.id
  availability_zone = sort(data.aws_availability_zones.available.names)[count.index]
  cidr_block        = "192.168.${count.index + 10}.0/24"

  tags = {
    Name        = "${var.environment}-private-subnet-${count.index + 1}"
    Environment = var.environment

    # For internal ELB/NLB detection
    "kubernetes.io/role/internal-elb"                              = "1"
    "kubernetes.io/cluster/${var.environment}-${var.cluster_name}" = "owned"
  }
}



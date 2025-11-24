# ==========================
# NAT Gateways
# ==========================
resource "aws_nat_gateway" "nat" {
  count         = var.countsub
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name        = "${var.environment}-nat-gateway-${count.index + 1}"
    Environment = var.environment
  }

  depends_on = [aws_eip.nat]
}
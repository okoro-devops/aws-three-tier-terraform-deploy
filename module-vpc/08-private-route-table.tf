# ==========================
# Private Route Tables
# ==========================
resource "aws_route_table" "private" {
  count  = var.countsub
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.environment}-private-route-table-${count.index + 1}"
    Environment = var.environment
  }
}

# Private Routes via NAT
resource "aws_route" "private_nat_route" {
  count                  = var.countsub
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat[count.index].id
}
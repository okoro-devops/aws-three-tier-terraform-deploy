# Associate Private Subnets
resource "aws_route_table_association" "private_assoc" {
  count          = var.countsub
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

# Associate DB Subnets
resource "aws_route_table_association" "private_db_assoc" {
  count          = var.countsub
  subnet_id      = aws_subnet.private_db[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
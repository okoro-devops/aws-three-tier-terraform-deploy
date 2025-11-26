# # Associate Private Subnets
# resource "aws_route_table_association" "private_route_association" {
#   count = true ? var.countsub : 0
#   subnet_id      = aws_subnet.private_subnet[count.index].id
#   route_table_id = aws_route_table.private_route_table[count.index].id

#   depends_on = [aws_nat_gateway.name]       
  
# }

# resource "aws_route_table_association" "private_route_association_db" {
#   count = true ? var.countsub : 0
#   subnet_id      = aws_subnet.private_subnet_db[count.index].id
#   route_table_id = aws_route_table.private_route_table[count.index].id

#   depends_on = [aws_nat_gateway.name]       
  
# }

resource "aws_route_table_association" "private_assoc" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_db_assoc" {
  count          = length(var.private_db_subnet_cidrs)
  subnet_id      = aws_subnet.private_db[count.index].id
  route_table_id = aws_route_table.private.id
}

# # ==========================
# # Outputs
# # ==========================
# output "vpc_id" {
#   description = "The ID of the VPC"
#   value       = aws_vpc.main.id
#   sensitive = true
  
# }

# output "private_subnet_ids" {
#   description = "List of private subnet IDs"
#   value       = aws_subnet.private_subnet[*].id
# }
# output "public_subnet_ids" {
#   description = "List of public subnet IDs"
#   value       = aws_subnet.public_subnet[*].id
# }


# output "private_subnet_db_ids" {
#   description = "List of private subnet IDs"
#   value       = aws_subnet.private_subnet_db[*].id
# }

# output "aws_security_group_ids" {
#   description = "List of security group IDs"
#   value       = aws_security_group.mysql_sg.id
# }

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "private_db_subnet_ids" {
  value = aws_subnet.private_db[*].id
}

output "private_subnet_db_ids" {
  description = "IDs of private DB subnets"
  value       = aws_subnet.private[*].id
}



output "vpc_id" {
  value = aws_vpc.main.id
}

output "mysql_security_group_id" {
  description = "The ID of the MySQL security group"
  value       = aws_security_group.mysql_sg.id
}

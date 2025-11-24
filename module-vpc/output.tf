# ==========================
# Outputs
# ==========================
output "vpc_id" {
  value       = aws_vpc.main.id
  description = "VPC ID"
}

output "public_subnet_ids" {
  value       = aws_subnet.public[*].id
  description = "Public subnet IDs"
}

output "private_subnet_ids" {
  value       = aws_subnet.private[*].id
  description = "Private subnet IDs"
}

output "private_db_subnet_ids" {
  value       = aws_subnet.private_db[*].id
  description = "Private DB subnet IDs"
}

output "mysql_sg_id" {
  description = "Security Group ID for MySQL"
  value       = aws_security_group.mysql_sg.id # <-- matches your resource name
}

output "private_subnet_db_ids" {
  value = aws_subnet.private_db[*].id
}

output "aws_security_group_ids" {
  value = aws_security_group.mysql_sg.id
}

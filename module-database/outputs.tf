output "db_instance_id" {
  description = "The RDS instance id"
  value       = aws_db_instance.mysql_db_instance.id
}

output "db_endpoint" {
  description = "The endpoint address of the RDS instance"
  value       = aws_db_instance.mysql_db_instance.endpoint
}

output "db_port" {
  description = "Port the RDS instance is listening on"
  value       = aws_db_instance.mysql_db_instance.port
}

output "db_arn" {
  description = "The ARN of the RDS instance"
  value       = aws_db_instance.mysql_db_instance.arn
}

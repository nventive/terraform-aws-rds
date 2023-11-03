output "instance_id" {
  value       = module.db.instance_id
  description = "ID of the instance"
}

output "instance_arn" {
  value       = module.db.instance_arn
  description = "ARN of the instance"
}

output "instance_address" {
  value       = module.db.instance_address
  description = "Address of the instance"
}

output "instance_endpoint" {
  value       = module.db.instance_endpoint
  description = "DNS Endpoint of the instance"
}

output "subnet_group_id" {
  value       = module.db.subnet_group_id
  description = "ID of the created Subnet Group"
}

output "security_group_id" {
  value       = module.db.security_group_id
  description = "ID of the Security Group"
}

output "parameter_group_id" {
  value       = module.db.parameter_group_id
  description = "ID of the Parameter Group"
}

output "option_group_id" {
  value       = module.db.option_group_id
  description = "ID of the Option Group"
}

output "hostname" {
  value       = module.db.hostname
  description = "DNS host name of the instance"
}

output "resource_id" {
  value       = module.db.resource_id
  description = "The RDS Resource ID of this instance"
}

output "security_group_id_self" {
  value       = module.sg.id
  description = "ID of the Security Group with self referencing ingress"
}

output "database_name" {
  value       = var.database_name
  description = "The name of the database to create when the DB instance is created"
}

output "database_user" {
  value       = var.database_user
  description = "Username for the master DB user"
}

output "password_ssm_arn" {
  value       = join("", aws_ssm_parameter.db_password.*.arn)
  description = "ARN of the SSM parameter for the database password"
}

output "iam_policy_ssm_get_arn" {
  value       = join("", aws_iam_policy.ssm_get.*.arn)
  description = "ARN of the IAM Policy with GET permission for the database password SSM parameter"
}

output "enabled" {
  value       = var.enabled
  description = "Whether or not the database is enabled"
}

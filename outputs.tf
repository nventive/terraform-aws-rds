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

output "proxy_enabled" {
  value       = local.proxy_enabled
  description = "Whether or not the database proxy is enabled"
}

output "proxy_id" {
  value       = module.rds_proxy.proxy_id
  description = "Proxy ID"
}

output "proxy_arn" {
  value       = module.rds_proxy.proxy_arn
  description = "Proxy ARN"
}

output "proxy_endpoint" {
  value       = module.rds_proxy.proxy_endpoint
  description = "Proxy endpoint"
}

output "proxy_target_endpoint" {
  value       = module.rds_proxy.proxy_target_endpoint
  description = "Hostname for the target RDS DB Instance. Only returned for `RDS_INSTANCE` type"
}

output "proxy_target_id" {
  value       = module.rds_proxy.proxy_target_id
  description = "Identifier of `db_proxy_name`, `target_group_name`, `target type` (e.g. `RDS_INSTANCE` or `TRACKED_CLUSTER`), and resource identifier separated by forward slashes (`/`)"
}

output "proxy_target_port" {
  value       = module.rds_proxy.proxy_target_port
  description = "Port for the target RDS DB instance or Aurora DB cluster"
}

output "proxy_target_rds_resource_id" {
  value       = module.rds_proxy.proxy_target_rds_resource_id
  description = "Identifier representing the DB instance or DB cluster target"
}

output "proxy_target_target_arn" {
  value       = module.rds_proxy.proxy_target_target_arn
  description = "Amazon Resource Name (ARN) for the DB instance or DB cluster"
}

output "proxy_target_tracked_cluster_id" {
  value       = module.rds_proxy.proxy_target_tracked_cluster_id
  description = "DB Cluster identifier for the DB instance target. Not returned unless manually importing an `RDS_INSTANCE` target that is part of a DB cluster"
}

output "proxy_target_type" {
  value       = module.rds_proxy.proxy_target_type
  description = "Type of target. e.g. `RDS_INSTANCE` or `TRACKED_CLUSTER`"
}

output "proxy_default_target_group_arn" {
  value       = module.rds_proxy.proxy_default_target_group_arn
  description = "The Amazon Resource Name (ARN) representing the default target group"
}

output "proxy_default_target_group_name" {
  value       = module.rds_proxy.proxy_default_target_group_name
  description = "The name of the default target group"
}

output "proxy_iam_role_arn" {
  value       = module.rds_proxy.proxy_iam_role_arn
  description = "The ARN of the IAM role that the proxy uses to access secrets in AWS Secrets Manager"
}

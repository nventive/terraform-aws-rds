variable "security_group_ids" {
  type        = list(string)
  default     = []
  description = "The IDs of the security groups from which to allow `ingress` traffic to the DB instance."
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "The whitelisted CIDRs which to allow `ingress` traffic to the DB instance."
}

variable "associate_security_group_ids" {
  type        = list(string)
  default     = []
  description = "The IDs of the existing security groups to associate with the DB instance."
}

variable "database_name" {
  type        = string
  description = "The name of the database to create when the DB instance is created."
}

variable "database_user" {
  type        = string
  default     = ""
  description = "(Required unless a `snapshot_identifier` or `replicate_source_db` is provided) Username for the master DB user."
}

variable "database_password" {
  sensitive   = true
  type        = string
  default     = ""
  description = <<-EOT
    (Required unless a snapshot_identifier or replicate_source_db is provided)
    BASE64 encoded Password for the master DB user.
    The password for the database master user can include any printable ASCII character except /, ", @, or a space.
  EOT
}

variable "database_port" {
  type        = number
  default     = 5432
  description = "Database port (_e.g._ `3306` for `MySQL`). Used in the DB Security Group to allow access to the DB instance from the provided `security_group_ids`."
}

variable "deletion_protection" {
  type        = bool
  default     = true
  description = "Set to true to enable deletion protection on the RDS instance."
}

variable "multi_az" {
  type        = bool
  default     = false
  description = "Set to true if multi AZ deployment must be supported."
}

variable "storage_type" {
  type        = string
  default     = "gp2"
  description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD)."
}

variable "storage_encrypted" {
  type        = bool
  default     = true
  description = "(Optional) Specifies whether the DB instance is encrypted. The default is false if not specified."
}

variable "allocated_storage" {
  type        = number
  default     = null
  description = "The allocated storage in GBs."
}

# http://docs.aws.amazon.com/cli/latest/reference/rds/create-db-instance.html
# - mysql
# - postgres
# - oracle-*
# - sqlserver-*
variable "engine" {
  type        = string
  default     = "postgres"
  description = "Database engine type."
}

# http://docs.aws.amazon.com/cli/latest/reference/rds/create-db-instance.html
variable "engine_version" {
  type        = string
  description = "Database engine version, depends on engine type."
}

# https://docs.aws.amazon.com/cli/latest/reference/rds/create-option-group.html
variable "major_engine_version" {
  type        = string
  default     = ""
  description = "Database MAJOR engine version, depends on engine type."
}

# https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.DBInstanceClass.html
variable "instance_class" {
  type        = string
  description = "Class of RDS instance."
}

# This is for custom parameters to be passed to the DB
# We're "cloning" default ones, but we need to specify which should be copied
variable "db_parameter_group" {
  type        = string
  description = <<-EOT
    The DB parameter group family name. The value depends on DB engine used.
    See [DBParameterGroupFamily](https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBParameterGroup.html#API_CreateDBParameterGroup_RequestParameters) for instructions on how to retrieve applicable value."
  EOT
}

variable "publicly_accessible" {
  type        = bool
  default     = false
  description = "Determines if database can be publicly available (NOT recommended)."
}

variable "subnet_ids" {
  type        = list(string)
  default     = []
  description = "List of subnet IDs for the DB. DB instance will be created in the VPC associated with the DB subnet group provisioned using the subnet IDs. Specify one of `subnet_ids`, `db_subnet_group_name` or `availability_zone`."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID the DB instance will be created in."
}

variable "auto_minor_version_upgrade" {
  type        = bool
  default     = true
  description = "Allow automated minor version upgrade (e.g. from Postgres 9.5.3 to Postgres 9.5.4)."
}

variable "allow_major_version_upgrade" {
  type        = bool
  default     = false
  description = "Allow major version upgrade."
}

variable "apply_immediately" {
  type        = bool
  default     = false
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window."
}

variable "maintenance_window" {
  type        = string
  default     = "Mon:03:00-Mon:04:00"
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi' UTC."
}

variable "skip_final_snapshot" {
  type        = bool
  default     = false
  description = "If true (default), no snapshot will be made before deleting DB."
}

variable "copy_tags_to_snapshot" {
  type        = bool
  default     = true
  description = "Copy tags from DB to a snapshot."
}

variable "backup_retention_period" {
  type        = number
  default     = 0
  description = "Backup retention period in days. Must be > 0 to enable backups."
}

variable "backup_window" {
  type        = string
  default     = "22:00-03:00"
  description = "When AWS can perform DB snapshots, can't overlap with maintenance window."
}

variable "db_parameter" {
  type = list(object({
    apply_method = string
    name         = string
    value        = string
  }))
  default     = []
  description = "A list of DB parameters to apply. Note that parameters may differ from a DB family to another."
}

variable "db_options" {
  type = list(object({
    db_security_group_memberships  = list(string)
    option_name                    = string
    port                           = number
    version                        = string
    vpc_security_group_memberships = list(string)

    option_settings = list(object({
      name  = string
      value = string
    }))
  }))

  default     = []
  description = "A list of DB options to apply with an option group. Depends on DB engine."
}

variable "parameter_group_name" {
  type        = string
  default     = ""
  description = "Name of the DB parameter group to associate."
}

variable "option_group_name" {
  type        = string
  default     = ""
  description = "Name of the DB option group to associate."
}

variable "kms_key_arn" {
  type        = string
  default     = ""
  description = "The ARN of the existing KMS key to encrypt storage."
}

variable "enabled_cloudwatch_logs_exports" {
  type        = list(string)
  default     = []
  description = "List of log types to enable for exporting to CloudWatch logs. If omitted, no logs will be exported. Valid values (depending on engine): alert, audit, error, general, listener, slowquery, trace, postgresql (PostgreSQL), upgrade (PostgreSQL)."
}

variable "ca_cert_identifier" {
  type        = string
  default     = null
  description = "The identifier of the CA certificate for the DB instance."
}

variable "proxy_enabled" {
  type        = bool
  default     = false
  description = "Set to `true` to enable RDS proxy. Only available for Postgre and MySQL engines."
}

variable "proxy_debug_logging" {
  type        = bool
  default     = false
  description = "Whether the proxy includes detailed information about SQL statements in its logs."
}

variable "proxy_idle_client_timeout" {
  type        = number
  default     = 1800
  description = "The number of seconds that a connection to the proxy can be inactive before the proxy disconnects it."
}

variable "proxy_require_tls" {
  type        = bool
  default     = false
  description = "A Boolean parameter that specifies whether Transport Layer Security (TLS) encryption is required for connections to the proxy. By enabling this setting, you can enforce encrypted TLS connections to the proxy."
}

variable "proxy_connection_borrow_timeout" {
  type        = number
  default     = 120
  description = "The number of seconds for a proxy to wait for a connection to become available in the connection pool. Only applies when the proxy has opened its maximum number of connections and all connections are busy with client sessions."
}

variable "proxy_init_query" {
  type        = string
  default     = null
  description = "One or more SQL statements for the proxy to run when opening each new database connection."
}

variable "proxy_max_connections_percent" {
  type        = number
  default     = 100
  description = "The maximum size of the connection pool for each target in a target group."
}

variable "proxy_max_idle_connections_percent" {
  type        = number
  default     = 50
  description = "Controls how actively the proxy closes idle database connections in the connection pool. A high value enables the proxy to leave a high percentage of idle connections open. A low value causes the proxy to close idle client connections and return the underlying database connections to the connection pool."
}

variable "proxy_session_pinning_filters" {
  type        = list(string)
  default     = null
  description = "Each item in the list represents a class of SQL operations that normally cause all later statements in a session using a proxy to be pinned to the same underlying database connection."
}

variable "proxy_existing_iam_role_arn" {
  type        = string
  default     = null
  description = "The ARN of an existing IAM role that the proxy can use to access secrets in AWS Secrets Manager. If not provided, the module will create a role to access secrets in Secrets Manager."
}

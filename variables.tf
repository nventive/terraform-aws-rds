variable "security_group_ids" {
  type        = list(string)
  default     = []
  description = "The IDs of the security groups from which to allow `ingress` traffic to the DB instance"
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "The whitelisted CIDRs which to allow `ingress` traffic to the DB instance"
}

variable "associate_security_group_ids" {
  type        = list(string)
  default     = []
  description = "The IDs of the existing security groups to associate with the DB instance"
}

variable "database_name" {
  type        = string
  description = "The name of the database to create when the DB instance is created"
}

variable "database_user" {
  type        = string
  default     = ""
  description = "(Required unless a `snapshot_identifier` or `replicate_source_db` is provided) Username for the master DB user"
}

variable "database_password" {
  sensitive   = true
  type        = string
  default     = ""
  description = <<-EOT
    (Required unless a snapshot_identifier or replicate_source_db is provided)
    BASE64 encoded Password for the master DB user
    The password for the database master user can include any printable ASCII character except /, ", @, or a space
    EOT
}

variable "database_port" {
  type        = number
  description = "Database port (_e.g._ `3306` for `MySQL`). Used in the DB Security Group to allow access to the DB instance from the provided `security_group_ids`"
  default     = 5432
}

variable "deletion_protection" {
  type        = bool
  description = "Set to true to enable deletion protection on the RDS instance"
  default     = true
}

variable "multi_az" {
  type        = bool
  description = "Set to true if multi AZ deployment must be supported"
  default     = false
}

variable "storage_type" {
  type        = string
  description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD)"
  default     = "gp2"
}

variable "storage_encrypted" {
  type        = bool
  description = "(Optional) Specifies whether the DB instance is encrypted. The default is false if not specified"
  default     = true
}

variable "allocated_storage" {
  type        = number
  description = "The allocated storage in GBs"
  default     = null
}

variable "engine" {
  type        = string
  description = "Database engine type"
  default     = "postgres"
  # http://docs.aws.amazon.com/cli/latest/reference/rds/create-db-instance.html
  # - mysql
  # - postgres
  # - oracle-*
  # - sqlserver-*
}

variable "engine_version" {
  type        = string
  description = "Database engine version, depends on engine type"
  # http://docs.aws.amazon.com/cli/latest/reference/rds/create-db-instance.html
}

variable "major_engine_version" {
  type        = string
  description = "Database MAJOR engine version, depends on engine type"
  default     = ""
  # https://docs.aws.amazon.com/cli/latest/reference/rds/create-option-group.html
}

variable "instance_class" {
  type        = string
  description = "Class of RDS instance"
  # https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.DBInstanceClass.html
}

# This is for custom parameters to be passed to the DB
# We're "cloning" default ones, but we need to specify which should be copied
variable "db_parameter_group" {
  type        = string
  description = "The DB parameter group family name. The value depends on DB engine used. See [DBParameterGroupFamily](https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBParameterGroup.html#API_CreateDBParameterGroup_RequestParameters) for instructions on how to retrieve applicable value."
  # "mysql5.6"
  # "postgres9.5"
}

variable "publicly_accessible" {
  type        = bool
  description = "Determines if database can be publicly available (NOT recommended)"
  default     = false
}

variable "subnet_ids" {
  description = "List of subnet IDs for the DB. DB instance will be created in the VPC associated with the DB subnet group provisioned using the subnet IDs. Specify one of `subnet_ids`, `db_subnet_group_name` or `availability_zone`"
  type        = list(string)
  default     = []
}

variable "vpc_id" {
  type        = string
  description = "VPC ID the DB instance will be created in"
}

variable "auto_minor_version_upgrade" {
  type        = bool
  description = "Allow automated minor version upgrade (e.g. from Postgres 9.5.3 to Postgres 9.5.4)"
  default     = true
}

variable "allow_major_version_upgrade" {
  type        = bool
  description = "Allow major version upgrade"
  default     = false
}

variable "apply_immediately" {
  type        = bool
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window"
  default     = false
}

variable "maintenance_window" {
  type        = string
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi' UTC "
  default     = "Mon:03:00-Mon:04:00"
}

variable "skip_final_snapshot" {
  type        = bool
  description = "If true (default), no snapshot will be made before deleting DB"
  default     = false
}

variable "copy_tags_to_snapshot" {
  type        = bool
  description = "Copy tags from DB to a snapshot"
  default     = true
}

variable "backup_retention_period" {
  type        = number
  description = "Backup retention period in days. Must be > 0 to enable backups"
  default     = 0
}

variable "backup_window" {
  type        = string
  description = "When AWS can perform DB snapshots, can't overlap with maintenance window"
  default     = "22:00-03:00"
}

variable "db_parameter" {
  type = list(object({
    apply_method = string
    name         = string
    value        = string
  }))
  default     = []
  description = "A list of DB parameters to apply. Note that parameters may differ from a DB family to another"
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
  description = "A list of DB options to apply with an option group. Depends on DB engine"
}

variable "parameter_group_name" {
  type        = string
  description = "Name of the DB parameter group to associate"
  default     = ""
}

variable "option_group_name" {
  type        = string
  description = "Name of the DB option group to associate"
  default     = ""
}

variable "kms_key_arn" {
  type        = string
  description = "The ARN of the existing KMS key to encrypt storage"
  default     = ""
}

variable "enabled_cloudwatch_logs_exports" {
  type        = list(string)
  default     = []
  description = "List of log types to enable for exporting to CloudWatch logs. If omitted, no logs will be exported. Valid values (depending on engine): alert, audit, error, general, listener, slowquery, trace, postgresql (PostgreSQL), upgrade (PostgreSQL)."
}

variable "ca_cert_identifier" {
  type        = string
  description = "The identifier of the CA certificate for the DB instance"
  default     = null
}

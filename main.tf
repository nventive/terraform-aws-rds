locals {
  enabled = module.this.enabled
}

module "db" {
  source  = "cloudposse/rds/aws"
  version = "0.41.0"

  security_group_ids              = concat([module.sg.id], var.security_group_ids)
  associate_security_group_ids    = var.associate_security_group_ids
  allowed_cidr_blocks             = var.allowed_cidr_blocks
  database_name                   = var.database_name
  database_user                   = var.database_user
  database_port                   = var.database_port
  database_password               = local.password_decoded
  multi_az                        = var.multi_az
  storage_type                    = var.storage_type
  allocated_storage               = var.allocated_storage
  storage_encrypted               = var.storage_encrypted
  engine                          = var.engine
  engine_version                  = var.engine_version
  major_engine_version            = var.major_engine_version
  instance_class                  = var.instance_class
  db_parameter_group              = var.db_parameter_group
  db_parameter                    = var.db_parameter
  option_group_name               = var.option_group_name
  db_options                      = var.db_options
  kms_key_arn                     = var.kms_key_arn
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  ca_cert_identifier              = var.ca_cert_identifier
  publicly_accessible             = var.publicly_accessible
  subnet_ids                      = var.subnet_ids
  vpc_id                          = var.vpc_id
  auto_minor_version_upgrade      = var.auto_minor_version_upgrade
  allow_major_version_upgrade     = var.allow_major_version_upgrade
  apply_immediately               = var.apply_immediately
  maintenance_window              = var.maintenance_window
  deletion_protection             = var.deletion_protection
  skip_final_snapshot             = var.skip_final_snapshot
  copy_tags_to_snapshot           = var.copy_tags_to_snapshot
  backup_retention_period         = var.backup_retention_period
  backup_window                   = var.backup_window

  context = module.this.context
}

module "sg" {
  source  = "cloudposse/security-group/aws"
  version = "2.0.0"

  vpc_id = var.vpc_id

  # Allow unlimited egress
  allow_all_egress = true
  rules = [
    {
      type        = "ingress"
      from_port   = var.database_port
      to_port     = var.database_port
      protocol    = "tcp"
      cidr_blocks = []
      self        = true
      description = "Allow database connection from self referencing SG"
    }
  ]

  attributes = ["self"]
  context    = module.this.context
}

module "ssm_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  context    = module.this.context
  attributes = ["db-password"]
  delimiter  = "/"
}

resource "aws_ssm_parameter" "db_password" {
  count = local.enabled ? 1 : 0

  name        = "/${module.ssm_label.id}"
  description = "${module.this.id} database password"
  type        = "SecureString"
  value       = local.password_decoded
  overwrite   = true

  tags = module.this.tags
}

locals {
  ssm_get_arn      = join("", aws_ssm_parameter.db_password.*.arn)
  password_decoded = base64decode(var.database_password)
}

data "aws_iam_policy_document" "ssm" {
  statement {
    sid       = "AllowReadSsmParameterDbPassword"
    actions   = ["ssm:GetParameters"]
    resources = [local.ssm_get_arn == "" ? "*" : local.ssm_get_arn]
  }

  statement {
    sid       = "AllowDescribeSsmParameters"
    actions   = ["ssm:DescribeParameters"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ssm_get" {
  count = local.enabled ? 1 : 0

  name   = "${module.this.id}-ssm-get"
  path   = "/"
  policy = data.aws_iam_policy_document.ssm.json

  tags = module.this.tags
}

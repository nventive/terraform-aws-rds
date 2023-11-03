![nventive](https://nventive-public-assets.s3.amazonaws.com/nventive_logo_github.svg?v=2)

# terraform-aws-rds

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg?style=flat-square)](LICENSE) [![Latest Release](https://img.shields.io/github/release/nventive/terraform-aws-rds.svg?style=flat-square)](https://github.com/nventive/terraform-aws-rds/releases/latest)

Terraform module to create an RDS instance.

---

## Examples

**IMPORTANT:** We do not pin modules to versions in our examples because of the difficulty of keeping the versions in
the documentation in sync with the latest released versions. We highly recommend that in your code you pin the version
to the exact version you are using so that your infrastructure remains stable, and update versions in a systematic way
so that they do not catch you by surprise.

```hcl
module "network" {
  source = "nventive/network/aws"
  # We recommend pinning every module to a specific version
  # version = "x.x.x"

  namespace = "eg"
  stage     = "test"
  name      = "app"

  vpc_cidr_block              = "10.0.0.0/16"
  subnets_ipv4_cidr_block     = ["10.0.0.0/16"]
  subnets_availability_zones  = ["us-east-1a", "us-east-1b"]
  subnets_nat_gateway_enabled = true
  s3_endpoint_enabled         = false
}

module "db" {
  source = "nventive/network/aws"
  # We recommend pinning every module to a specific version
  # version = "x.x.x"

  namespace = "eg"
  stage     = "test"
  name      = "app"

  enabled                     = true
  name                        = "wordpress-db"
  security_group_ids          = []
  allowed_cidr_blocks         = []
  database_name               = "wordpress"
  database_user               = "wp_admin"
  database_password           = "VXBVcERvd25Eb3duTGVmdFJpZ2h0TGVmdFJpZ2h0QkE="
  database_port               = 3306
  allocated_storage           = 100
  engine                      = "mysql"
  engine_version              = "5.7"
  major_engine_version        = "5.7"
  instance_class              = "db.t3.micro"
  db_parameter_group          = "mysql5.7"
  publicly_accessible         = false
  subnet_ids                  = module.network.private_subnet_ids
  vpc_id                      = module.network.vpc_id
  allow_major_version_upgrade = false
  apply_immediately           = false
  skip_final_snapshot         = false
  backup_retention_period     = 7
}
```

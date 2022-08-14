# CLI driven workflow
terraform {
  cloud {
    organization = "waypoint"
    workspaces {
      # Only one of workspace "tags" or "name" is allowed.
      name = "node-express"
      #   tags = ["rust-actix"]
    }
  }
}

provider "aws" {
  region = local.region
}

locals {
  name   = "node-express-db"
  region = var.AWS_REGION
  tags = {
    Owner       = "user"
    Environment = "dev"
  }
}


################################################################################
# RDS Aurora Module - PostgreSQL Serverless V2
################################################################################

data "aws_rds_engine_version" "postgresql" {
  engine  = "aurora-postgresql"
  version = "13.6"
}

module "aurora_postgresql_serverlessv2" {
  source = "terraform-aws-modules/rds-aurora/aws"

  name              = "${local.name}-postgresqlv2"
  engine            = data.aws_rds_engine_version.postgresql.engine
  engine_mode       = "provisioned"
  engine_version    = data.aws_rds_engine_version.postgresql.version
  storage_encrypted = true
  # InvalidVPCNetworkStateFault: Cannot create a publicly accessible DBInstance. 
  # The specified VPC does not support DNS resolution, DNS hostnames, or both.
  # Update the VPC and then try again
  publicly_accessible = true

  # FIX Error: Error creating DB Subnet Group: InvalidSubnet: Subnet IDs are required.
  # https://github.com/terraform-aws-modules/terraform-aws-rds/issues/327
  create_db_subnet_group = false
  db_subnet_group_name   = var.db_subnet_group_name

  vpc_security_group_ids = var.vpc_security_group_ids
  vpc_id                 = module.vpc.vpc_id
  subnets                = module.vpc.database_subnets
  create_security_group  = true
  allowed_cidr_blocks    = module.vpc.private_subnets_cidr_blocks

  monitoring_interval = 60

  apply_immediately   = true
  skip_final_snapshot = true

  db_parameter_group_name         = aws_db_parameter_group.example_postgresql13.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.example_postgresql13.id

  serverlessv2_scaling_configuration = {
    min_capacity = 0.5
    max_capacity = 2
  }

  instance_class = "db.serverless"
  instances = {
    one = {}
    # two = {}
  }
}

resource "aws_db_parameter_group" "example_postgresql13" {
  name        = "${local.name}-aurora-db-postgres13-parameter-group"
  family      = "aurora-postgresql13"
  description = "${local.name}-aurora-db-postgres13-parameter-group"
  tags        = local.tags
}

resource "aws_rds_cluster_parameter_group" "example_postgresql13" {
  name        = "${local.name}-aurora-postgres13-cluster-parameter-group"
  family      = "aurora-postgresql13"
  description = "${local.name}-aurora-postgres13-cluster-parameter-group"
  tags        = local.tags
}

################################################################################
# Supporting Resources
################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"


  create_vpc = false

  manage_default_vpc               = true
  default_vpc_name                 = var.vpc_name
  default_vpc_enable_dns_hostnames = true
}

################################################################################
# VARIABLES — These are/should be set in Terraform Cloud
################################################################################
variable "vpc_name" {
  type    = string
  default = "default"
}

variable "db_subnet_group_name" {
  type = string
}


variable "vpc_security_group_ids" {
  type    = list(string)
  default = []
}

variable "AWS_REGION" {
  type    = string
  default = "us-east-1"
}

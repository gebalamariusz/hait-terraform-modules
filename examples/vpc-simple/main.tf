################################################################################
# VPC Simple Example
# Creates VPCs based on configuration defined in tfvars
################################################################################

module "vpc" {
  source   = "../../modules/vpc"
  for_each = var.vpcs

  name        = each.key
  environment = each.value.environment

  create_vpc            = each.value.create_vpc
  vpc_id                = each.value.vpc_id
  cidr_block            = each.value.cidr_block
  secondary_cidr_blocks = each.value.secondary_cidr_blocks

  enable_dns_support   = each.value.enable_dns_support
  enable_dns_hostnames = each.value.enable_dns_hostnames

  create_igw = each.value.create_igw

  enable_flow_logs                                 = each.value.enable_flow_logs
  flow_logs_destination_type                       = each.value.flow_logs_destination_type
  create_flow_logs_cloudwatch_log_group            = each.value.create_flow_logs_cloudwatch_log_group
  flow_logs_cloudwatch_log_group_retention_in_days = each.value.flow_logs_cloudwatch_log_group_retention_in_days
  create_flow_logs_iam_role                        = each.value.create_flow_logs_iam_role

  tags = each.value.tags
}

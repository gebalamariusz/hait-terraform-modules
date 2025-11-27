output "vpcs" {
  description = "Map of VPC outputs"
  value = {
    for name, vpc in module.vpc : name => {
      vpc_id                = vpc.vpc_id
      vpc_cidr_block        = vpc.vpc_cidr_block
      secondary_cidr_blocks = vpc.secondary_cidr_blocks
      all_cidr_blocks       = vpc.all_cidr_blocks
      internet_gateway_id   = vpc.internet_gateway_id
      flow_log_id           = vpc.flow_log_id
    }
  }
}

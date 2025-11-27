################################################################################
# General
################################################################################

variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

################################################################################
# VPCs
#
# Example - Create new VPC (all options):
#
#   vpcs = {
#     "my-vpc" = {
#       environment                                      = "dev"              # required: dev, staging, prod
#       create_vpc                                       = true               # default: true
#       cidr_block                                       = "10.0.0.0/16"      # required when create_vpc = true
#       secondary_cidr_blocks                            = ["10.1.0.0/16"]    # default: []
#       enable_dns_support                               = true               # default: true
#       enable_dns_hostnames                             = true               # default: true
#       create_igw                                       = true               # default: true
#       enable_flow_logs                                 = false              # default: false
#       flow_logs_destination_type                       = "cloud-watch-logs" # default: cloud-watch-logs (or s3)
#       create_flow_logs_cloudwatch_log_group            = true               # default: true
#       flow_logs_cloudwatch_log_group_retention_in_days = 30                 # default: 30
#       create_flow_logs_iam_role                        = true               # default: true
#       tags                                             = {}                 # default: {}
#     }
#   }
#
# Example - Reference existing VPC:
#
#   vpcs = {
#     "existing-vpc" = {
#       environment      = "prod"
#       create_vpc       = false
#       vpc_id           = "vpc-1234567890abcdef0"
#       enable_flow_logs = true
#     }
#   }
#
################################################################################

variable "vpcs" {
  description = "Map of VPC configurations"
  type = map(object({
    environment                                      = string
    create_vpc                                       = optional(bool, true)
    vpc_id                                           = optional(string, "")
    cidr_block                                       = optional(string, "")
    secondary_cidr_blocks                            = optional(list(string), [])
    enable_dns_support                               = optional(bool, true)
    enable_dns_hostnames                             = optional(bool, true)
    create_igw                                       = optional(bool, true)
    enable_flow_logs                                 = optional(bool, false)
    flow_logs_destination_type                       = optional(string, "cloud-watch-logs")
    create_flow_logs_cloudwatch_log_group            = optional(bool, true)
    flow_logs_cloudwatch_log_group_retention_in_days = optional(number, 30)
    create_flow_logs_iam_role                        = optional(bool, true)
    tags                                             = optional(map(string), {})
  }))
  default = {}
}

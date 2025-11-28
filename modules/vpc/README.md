# AWS VPC Terraform Module

Terraform module to create AWS VPC or reference an existing one, with optional Internet Gateway, DHCP Options, and VPC Flow Logs.

## Features

- Create new VPC or reference existing one
- Configurable CIDR block and DNS settings
- **Secondary CIDR blocks support** - expand VPC IP range when needed
- Optional Internet Gateway
- Optional custom DHCP Options Set
- Optional VPC Flow Logs to CloudWatch or S3
- Automatic IAM role creation for Flow Logs (CloudWatch)
- Consistent naming and tagging conventions
- Input validation with clear error messages

## Usage

### Create New VPC (Basic)

```hcl
module "vpc" {
  source = "../../modules/vpc"

  name        = "myapp"
  environment = "prod"
  cidr_block  = "10.0.0.0/16"
}
```

### Reference Existing VPC

```hcl
module "vpc" {
  source = "../../modules/vpc"

  name        = "myapp"
  environment = "prod"

  create_vpc = false
  vpc_id     = "vpc-1234567890abcdef0"
}
```

### VPC with Flow Logs to CloudWatch

```hcl
module "vpc" {
  source = "../../modules/vpc"

  name        = "myapp"
  environment = "prod"
  cidr_block  = "10.0.0.0/16"

  enable_flow_logs                                 = true
  flow_logs_destination_type                       = "cloud-watch-logs"
  create_flow_logs_cloudwatch_log_group            = true
  flow_logs_cloudwatch_log_group_retention_in_days = 30
}
```

### VPC with Flow Logs to S3

```hcl
module "vpc" {
  source = "../../modules/vpc"

  name        = "myapp"
  environment = "prod"
  cidr_block  = "10.0.0.0/16"

  enable_flow_logs           = true
  flow_logs_destination_type = "s3"
  flow_logs_destination_arn  = "arn:aws:s3:::my-flow-logs-bucket"
}
```

### VPC with Custom DHCP Options

```hcl
module "vpc" {
  source = "../../modules/vpc"

  name        = "myapp"
  environment = "prod"
  cidr_block  = "10.0.0.0/16"

  enable_dhcp_options              = true
  dhcp_options_domain_name         = "mycompany.internal"
  dhcp_options_domain_name_servers = ["10.0.0.2", "AmazonProvidedDNS"]
}
```

### Add Flow Logs to Existing VPC

```hcl
module "vpc" {
  source = "../../modules/vpc"

  name        = "legacy-app"
  environment = "prod"

  create_vpc       = false
  vpc_id           = "vpc-1234567890abcdef0"
  enable_flow_logs = true
}
```

### VPC with Secondary CIDR Blocks

Use secondary CIDR blocks when you need additional IP ranges (e.g., running out of IPs in the primary CIDR).

```hcl
module "vpc" {
  source = "../../modules/vpc"

  name        = "myapp"
  environment = "prod"
  cidr_block  = "10.0.0.0/16"

  secondary_cidr_blocks = [
    "10.1.0.0/16",
    "10.2.0.0/16"
  ]
}
```

This is useful for:
- Expanding IP address space when the primary CIDR is exhausted
- Separating workloads into different IP ranges
- Creating subnets in secondary CIDRs via the subnets module

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.7 |
| aws | >= 5.0 |

## Inputs

### General

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name for VPC and prefix for related resources | `string` | n/a | yes |
| environment | Environment name (used in naming/tagging if provided) | `string` | `""` | no |
| tags | Additional tags for all resources | `map(string)` | `{}` | no |

### VPC

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create_vpc | Create a new VPC. If false, vpc_id must be provided | `bool` | `true` | no |
| vpc_id | ID of an existing VPC (required when create_vpc = false) | `string` | `""` | no |
| cidr_block | IPv4 CIDR block for the VPC (required when create_vpc = true) | `string` | `""` | no |
| instance_tenancy | Tenancy option for instances (default or dedicated) | `string` | `"default"` | no |
| enable_dns_support | Enable DNS support in the VPC | `bool` | `true` | no |
| enable_dns_hostnames | Enable DNS hostnames in the VPC | `bool` | `true` | no |
| enable_network_address_usage_metrics | Enable Network Address Usage metrics | `bool` | `false` | no |
| secondary_cidr_blocks | List of secondary IPv4 CIDR blocks to associate with the VPC | `list(string)` | `[]` | no |

### Internet Gateway

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create_igw | Create an Internet Gateway (only when create_vpc = true) | `bool` | `true` | no |

### DHCP Options

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| enable_dhcp_options | Create custom DHCP options set (only when create_vpc = true) | `bool` | `false` | no |
| dhcp_options_domain_name | Domain name for DHCP options | `string` | `""` | no |
| dhcp_options_domain_name_servers | List of DNS server addresses | `list(string)` | `["AmazonProvidedDNS"]` | no |
| dhcp_options_ntp_servers | List of NTP server addresses | `list(string)` | `[]` | no |
| dhcp_options_netbios_name_servers | List of NetBIOS name server addresses | `list(string)` | `[]` | no |
| dhcp_options_netbios_node_type | NetBIOS node type (1, 2, 4, or 8) | `number` | `null` | no |

### VPC Flow Logs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| enable_flow_logs | Enable VPC Flow Logs | `bool` | `false` | no |
| flow_logs_destination_type | Destination type (cloud-watch-logs or s3) | `string` | `"cloud-watch-logs"` | no |
| flow_logs_destination_arn | ARN of the destination (required if not creating CloudWatch Log Group) | `string` | `""` | no |
| flow_logs_traffic_type | Traffic type (ACCEPT, REJECT, or ALL) | `string` | `"ALL"` | no |
| flow_logs_max_aggregation_interval | Max aggregation interval in seconds (60 or 600) | `number` | `600` | no |
| create_flow_logs_cloudwatch_log_group | Create CloudWatch Log Group for Flow Logs | `bool` | `true` | no |
| flow_logs_cloudwatch_log_group_retention_in_days | Retention days for CloudWatch Log Group | `number` | `30` | no |
| flow_logs_cloudwatch_log_group_kms_key_id | KMS key ARN for CloudWatch Log Group encryption | `string` | `null` | no |
| create_flow_logs_iam_role | Create IAM role for Flow Logs to CloudWatch | `bool` | `true` | no |
| flow_logs_iam_role_arn | ARN of existing IAM role for Flow Logs | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | The ID of the VPC |
| vpc_arn | The ARN of the VPC |
| vpc_cidr_block | The CIDR block of the VPC |
| vpc_main_route_table_id | The ID of the main route table |
| vpc_default_security_group_id | The ID of the default security group (only for created VPC) |
| vpc_default_route_table_id | The ID of the default route table (only for created VPC) |
| vpc_default_network_acl_id | The ID of the default network ACL (only for created VPC) |
| vpc_owner_id | The AWS account ID that owns the VPC |
| secondary_cidr_blocks | List of secondary CIDR blocks associated with the VPC |
| secondary_cidr_block_associations | Map of secondary CIDR blocks to their association details |
| all_cidr_blocks | List of all CIDR blocks (primary + secondary) |
| internet_gateway_id | The ID of the Internet Gateway |
| internet_gateway_arn | The ARN of the Internet Gateway |
| dhcp_options_id | The ID of the DHCP Options Set |
| dhcp_options_arn | The ARN of the DHCP Options Set |
| flow_log_id | The ID of the VPC Flow Log |
| flow_log_arn | The ARN of the VPC Flow Log |
| flow_log_cloudwatch_log_group_name | The name of the CloudWatch Log Group |
| flow_log_cloudwatch_log_group_arn | The ARN of the CloudWatch Log Group |
| flow_log_iam_role_arn | The ARN of the IAM role for Flow Logs |

## Validation

The module includes input validation:

- `vpc_id` must be a valid VPC ID format (vpc-*)
- `cidr_block` must be a valid IPv4 CIDR block
- `secondary_cidr_blocks` must all be valid IPv4 CIDR blocks
- `cidr_block` is required when `create_vpc = true`
- `vpc_id` is required when `create_vpc = false`

## License

MIT

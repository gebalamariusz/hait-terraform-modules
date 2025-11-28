# VPC Simple Example

Example usage of the VPC module - creating new VPCs or referencing existing ones.

## Quick Start

```bash
# 1. Copy example tfvars
cp terraform.tfvars.example terraform.tfvars

# 2. Adjust configuration
# edit terraform.tfvars

# 3. Run
terraform init
terraform plan
terraform apply
```

## Usage Scenarios

### 1. New VPC (minimal configuration)

```hcl
vpcs = {
  "my-vpc" = {
    cidr_block = "10.0.0.0/16"
  }
}
```

Creates VPC with:
- Name: `my-vpc`
- CIDR: `10.0.0.0/16`
- DNS support/hostnames: enabled
- Internet Gateway: yes

### 2. New VPC with environment

```hcl
vpcs = {
  "app-vpc" = {
    environment = "prod"
    cidr_block  = "10.0.0.0/16"
  }
}
```

Creates VPC with:
- Name: `app-vpc`
- Tags: `Environment = prod`
- Related resources (IGW, etc.) prefixed with `app-vpc-prod-`

### 3. Existing VPC (reference only)

When you already have a VPC and just want to fetch its data (outputs):

```hcl
vpcs = {
  "existing" = {
    create_vpc = false
    vpc_id     = "vpc-0abc123def456789"
  }
}
```

Returns outputs:
- `vpc_id`
- `vpc_cidr_block`
- `all_cidr_blocks` (primary + secondary)
- `vpc_default_security_group_id`
- `vpc_default_route_table_id`
- `vpc_default_network_acl_id`

### 4. Existing VPC + Flow Logs

Add Flow Logs to an existing VPC:

```hcl
vpcs = {
  "legacy-vpc" = {
    create_vpc       = false
    vpc_id           = "vpc-0abc123def456789"
    enable_flow_logs = true
  }
}
```

### 5. New VPC with Flow Logs to CloudWatch

```hcl
vpcs = {
  "secure-vpc" = {
    cidr_block                                       = "10.0.0.0/16"
    enable_flow_logs                                 = true
    flow_logs_cloudwatch_log_group_retention_in_days = 90
  }
}
```

### 6. New VPC with Secondary CIDR

```hcl
vpcs = {
  "large-vpc" = {
    cidr_block            = "10.0.0.0/16"
    secondary_cidr_blocks = ["10.1.0.0/16", "10.2.0.0/16"]
  }
}
```

### 7. Multiple VPCs at once

```hcl
vpcs = {
  "dev-vpc" = {
    environment = "dev"
    cidr_block  = "10.0.0.0/16"
  }
  "prod-vpc" = {
    environment = "prod"
    cidr_block  = "10.1.0.0/16"
  }
  "legacy" = {
    create_vpc = false
    vpc_id     = "vpc-0abc123def456789"
  }
}
```

## All Options

| Parameter | Description | Default |
|-----------|-------------|---------|
| `environment` | Environment name (optional) | `""` |
| `create_vpc` | Create new VPC? | `true` |
| `vpc_id` | Existing VPC ID (when `create_vpc = false`) | `""` |
| `cidr_block` | CIDR for new VPC | `""` |
| `secondary_cidr_blocks` | Additional CIDR blocks | `[]` |
| `enable_dns_support` | DNS support | `true` |
| `enable_dns_hostnames` | DNS hostnames | `true` |
| `create_igw` | Create Internet Gateway? | `true` |
| `enable_flow_logs` | Enable Flow Logs? | `false` |
| `flow_logs_destination_type` | `cloud-watch-logs` or `s3` | `cloud-watch-logs` |
| `create_flow_logs_cloudwatch_log_group` | Create Log Group? | `true` |
| `flow_logs_cloudwatch_log_group_retention_in_days` | Log retention | `30` |
| `create_flow_logs_iam_role` | Create IAM role? | `true` |
| `tags` | Additional tags | `{}` |

## Outputs

After `terraform apply`, outputs are available for each VPC:

```bash
# All outputs
terraform output

# Specific VPC
terraform output -json vpcs | jq '.["my-vpc"]'

# Just vpc_id
terraform output -json vpcs | jq -r '.["my-vpc"].vpc_id'
```

Available outputs per VPC:
- `vpc_id`
- `vpc_arn`
- `vpc_cidr_block`
- `all_cidr_blocks`
- `internet_gateway_id`
- `vpc_default_security_group_id`
- `vpc_default_route_table_id`
- `flow_log_id` (if enabled)
- ... and more

## How to find vpc_id of an existing VPC?

```bash
# AWS CLI - list all VPCs
aws ec2 describe-vpcs --query 'Vpcs[*].[VpcId,Tags[?Key==`Name`].Value|[0],CidrBlock]' --output table

# Get VPC ID by name
aws ec2 describe-vpcs --filters "Name=tag:Name,Values=my-vpc-name" --query 'Vpcs[0].VpcId' --output text
```

## Cleanup

```bash
terraform destroy
```

# VPC Simple Example

Przykład użycia modułu VPC - tworzenie nowych VPC lub referencja do istniejących.

## Szybki start

```bash
# 1. Skopiuj przykładowy tfvars
cp terraform.tfvars.example terraform.tfvars

# 2. Dostosuj konfigurację
# edytuj terraform.tfvars

# 3. Uruchom
terraform init
terraform plan
terraform apply
```

## Scenariusze użycia

### 1. Nowe VPC (minimalna konfiguracja)

```hcl
vpcs = {
  "my-vpc" = {
    cidr_block = "10.0.0.0/16"
  }
}
```

Tworzy VPC z:
- Nazwa: `my-vpc`
- CIDR: `10.0.0.0/16`
- DNS support/hostnames: enabled
- Internet Gateway: tak

### 2. Nowe VPC z environment

```hcl
vpcs = {
  "app-vpc" = {
    environment = "prod"
    cidr_block  = "10.0.0.0/16"
  }
}
```

Tworzy VPC z:
- Nazwa: `app-vpc`
- Tagi: `Environment = prod`
- Powiązane zasoby (IGW, etc.) z prefixem `app-vpc-prod-`

### 3. Istniejące VPC (tylko referencja)

Gdy masz już VPC i chcesz tylko pobrać jego dane (outputy):

```hcl
vpcs = {
  "existing" = {
    create_vpc = false
    vpc_id     = "vpc-0abc123def456789"
  }
}
```

Zwraca outputy:
- `vpc_id`
- `vpc_cidr_block`
- `all_cidr_blocks` (primary + secondary)
- `vpc_default_security_group_id`
- `vpc_default_route_table_id`
- `vpc_default_network_acl_id`

### 4. Istniejące VPC + Flow Logs

Dodanie Flow Logs do istniejącego VPC:

```hcl
vpcs = {
  "legacy-vpc" = {
    create_vpc       = false
    vpc_id           = "vpc-0abc123def456789"
    enable_flow_logs = true
  }
}
```

### 5. Nowe VPC z Flow Logs do CloudWatch

```hcl
vpcs = {
  "secure-vpc" = {
    cidr_block                                       = "10.0.0.0/16"
    enable_flow_logs                                 = true
    flow_logs_cloudwatch_log_group_retention_in_days = 90
  }
}
```

### 6. Nowe VPC z Secondary CIDR

```hcl
vpcs = {
  "large-vpc" = {
    cidr_block            = "10.0.0.0/16"
    secondary_cidr_blocks = ["10.1.0.0/16", "10.2.0.0/16"]
  }
}
```

### 7. Wiele VPC naraz

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

## Wszystkie opcje

| Parametr | Opis | Default |
|----------|------|---------|
| `environment` | Nazwa środowiska (opcjonalnie) | `""` |
| `create_vpc` | Tworzyć nowe VPC? | `true` |
| `vpc_id` | ID istniejącego VPC (gdy `create_vpc = false`) | `""` |
| `cidr_block` | CIDR dla nowego VPC | `""` |
| `secondary_cidr_blocks` | Dodatkowe CIDR bloki | `[]` |
| `enable_dns_support` | DNS support | `true` |
| `enable_dns_hostnames` | DNS hostnames | `true` |
| `create_igw` | Tworzyć Internet Gateway? | `true` |
| `enable_flow_logs` | Włączyć Flow Logs? | `false` |
| `flow_logs_destination_type` | `cloud-watch-logs` lub `s3` | `cloud-watch-logs` |
| `create_flow_logs_cloudwatch_log_group` | Tworzyć Log Group? | `true` |
| `flow_logs_cloudwatch_log_group_retention_in_days` | Retencja logów | `30` |
| `create_flow_logs_iam_role` | Tworzyć IAM role? | `true` |
| `tags` | Dodatkowe tagi | `{}` |

## Outputy

Po `terraform apply` dostępne są outputy dla każdego VPC:

```bash
# Wszystkie outputy
terraform output

# Konkretne VPC
terraform output -json vpcs | jq '.["my-vpc"]'

# Samo vpc_id
terraform output -json vpcs | jq -r '.["my-vpc"].vpc_id'
```

Dostępne outputy per VPC:
- `vpc_id`
- `vpc_arn`
- `vpc_cidr_block`
- `all_cidr_blocks`
- `internet_gateway_id`
- `vpc_default_security_group_id`
- `vpc_default_route_table_id`
- `flow_log_id` (jeśli enabled)
- ... i więcej

## Jak znaleźć vpc_id istniejącego VPC?

```bash
# AWS CLI - lista wszystkich VPC
aws ec2 describe-vpcs --query 'Vpcs[*].[VpcId,Tags[?Key==`Name`].Value|[0],CidrBlock]' --output table

# Tylko VPC ID po nazwie
aws ec2 describe-vpcs --filters "Name=tag:Name,Values=my-vpc-name" --query 'Vpcs[0].VpcId' --output text
```

## Cleanup

```bash
terraform destroy
```

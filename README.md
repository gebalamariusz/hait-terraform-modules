# HAIT Terraform Modules

[![CI](https://github.com/gebalamariusz/hait-terraform-modules/actions/workflows/ci.yml/badge.svg)](https://github.com/gebalamariusz/hait-terraform-modules/actions/workflows/ci.yml)
[![Release](https://img.shields.io/github/v/release/gebalamariusz/hait-terraform-modules?display_name=tag&sort=semver)](https://github.com/gebalamariusz/hait-terraform-modules/releases)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.7-purple.svg)](https://www.terraform.io/)
[![AWS Provider](https://img.shields.io/badge/AWS-%3E%3D5.0-orange.svg)](https://registry.terraform.io/providers/hashicorp/aws/latest)

Production-ready, reusable Terraform modules for AWS infrastructure.

## Features

- **Production-ready** - Battle-tested configurations with security best practices
- **Modular design** - Use modules independently or combine them for full stack
- **Well-documented** - Comprehensive README for each module with examples
- **CI/CD validated** - Every change passes automated linting and security scans
- **Consistent conventions** - Unified naming and tagging across all resources

## Available Modules

| Module | Description | Status |
|--------|-------------|--------|
| [vpc](./modules/vpc) | VPC with IGW, DHCP Options, Flow Logs, Secondary CIDRs | ✅ Ready |
| [subnets](./modules/subnets) | Public/Private/Database subnets with route tables | 🚧 Coming |
| [nat-gateway](./modules/nat-gateway) | NAT Gateway with EIP | 🚧 Coming |
| [alb](./modules/alb) | Application Load Balancer | 🚧 Coming |
| [rds](./modules/rds) | RDS databases | 🚧 Coming |
| [ecs](./modules/ecs) | ECS Fargate | 🚧 Coming |
| [s3](./modules/s3) | S3 buckets | 🚧 Coming |

## Quick Start

### Using a module

```hcl
module "vpc" {
  source = "github.com/gebalamariusz/hait-terraform-modules//modules/vpc?ref=v1.0.0"

  name       = "my-app"
  cidr_block = "10.0.0.0/16"

  tags = {
    Project = "my-project"
  }
}
```

### Pinning versions

Always pin to a specific version for production:

```hcl
source = "github.com/gebalamariusz/hait-terraform-modules//modules/vpc?ref=v1.0.0"
```

## Examples

| Example | Description |
|---------|-------------|
| [vpc-simple](./examples/vpc-simple) | Basic VPC setup with multiple configuration scenarios |

## Requirements

| Name | Version |
|------|---------|
| Terraform | >= 1.7 |
| AWS Provider | >= 5.0 |

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'feat: add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

**HAIT** - [haitmg.pl](https://haitmg.pl)

Mariusz Gębala - DevOps/Cloud Engineer

# Terraform Infrastructure Template

This repository contains a modular Terraform configuration for deploying infrastructure on Azure across multiple environments (dev, uat, prod).

## Project Structure

```
.
├── environments/          # Environment-specific configurations
│   ├── dev/
│   ├── uat/
│   └── prod/
├── modules/              # Reusable Terraform modules
│   ├── networking/
│   ├── vm/
│   ├── vmss/
│   ├── storage/
│   └── frontdoor/
├── pipeline/             # CI/CD pipeline configuration
└── providers.tf          # Provider configuration
```

## Prerequisites

- Terraform >= 1.0
- Azure CLI
- Service Principal with appropriate permissions
- Azure Storage Account for remote state

## Environment Variables

Set the following environment variables for authentication:

```bash
export ARM_CLIENT_ID="<service-principal-client-id>"
export ARM_CLIENT_SECRET="<service-principal-password>"
export ARM_SUBSCRIPTION_ID="<subscription-id>"
export ARM_TENANT_ID="<tenant-id>"
```

## Deploying to an Environment

### 1. Initialize Terraform

```bash
terraform init -backend-config=environments/<env>/backend.tfvars
```

### 2. Plan Changes

```bash
terraform plan -var-file=environments/<env>/variables.tfvars -out=tfplan
```

### 3. Apply Changes

```bash
terraform apply tfplan
```

## Modules

### networking
Provisions Virtual Network, Subnets, Network Security Groups, and related networking resources.

### vm
Creates Azure Virtual Machines with configuration management.

### vmss
Deploys Virtual Machine Scale Sets for auto-scaling scenarios.

### storage
Sets up Azure Storage Accounts with containers and configurations.

### frontdoor
Configures Azure Front Door for global load balancing and CDN.

## Remote State

Remote state is stored in Azure Blob Storage. Configure your backend in `environments/<env>/backend.tfvars`:

```hcl
resource_group_name      = "rg-terraform-state"
storage_account_name     = "terraformstateaccount"
container_name           = "tfstate"
key                      = "terraform.tfstate"
```

## Variables

Environment-specific variables are defined in `environments/<env>/variables.tfvars`.

- `environments/*/backend.tfvars` and `environments/*/variables.tfvars` should be tracked in Git when they contain non-sensitive defaults.
- Keep sensitive values out of committed `.tfvars` files. Use GitLab CI/CD variables or local environment variables for secrets like `ARM_CLIENT_SECRET`.

Common variables:
- `environment`: Deployment environment (dev/uat/prod)
- `project_name`: Project name for resource naming
- `location`: Azure region for resources
- `vm_size`: VM instance type
- `vm_count`: Number of VMs to create

## Best Practices

- Always run `terraform plan` before `terraform apply`
- Use variable validation for input constraints
- Keep sensitive data in environment variables, not in tfvars
- Use consistent naming conventions via `locals.tf`
- Lock provider versions in production environments
- Review `.gitignore` to prevent committing sensitive files

## Troubleshooting

### Backend State Not Found
Ensure the storage account and container exist, and credentials are correctly set.

### Provider Version Conflicts
Run `terraform init -upgrade` to update provider versions.

### Variable Not Set
Check that the `.tfvars` file path is correct and all required variables are defined.

## Support

For issues or questions, refer to the Terraform documentation or Azure provider docs.

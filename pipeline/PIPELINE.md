# GitLab CI/CD Pipeline Documentation

This document explains the GitLab CI/CD pipeline configuration for Terraform deployments.

## Pipeline Structure

The pipeline consists of three stages:
1. **Validate** - Validates Terraform syntax and configuration
2. **Plan** - Plans infrastructure changes for each environment
3. **Apply** - Applies infrastructure changes (manual trigger)

## Environments

The pipeline supports three environments:
- **dev** - Development environment (triggered on merge requests and main branch)
- **uat** - User Acceptance Testing (triggered on main branch)
- **prod** - Production (triggered on tags only)

## Prerequisites

### Service Principal Setup

Create an Azure Service Principal with appropriate permissions:

```bash
az ad sp create-for-rbac --name "terraform-ci" --role "Contributor"
```

### GitLab Variables

Configure the following variables in GitLab CI/CD settings:

- `ARM_CLIENT_ID` - Service Principal Client ID
- `ARM_CLIENT_SECRET` - Service Principal Client Secret (masked)
- `ARM_SUBSCRIPTION_ID` - Azure Subscription ID
- `ARM_TENANT_ID` - Azure Tenant ID

## Pipeline Workflow

### Development Deployment

```
Merge Request → Validate → Plan (dev) → Apply (dev, manual)
```

1. Validation runs on all merge requests
2. Planning creates a plan artifact
3. Developer manually triggers apply when ready

### UAT Deployment

```
Merge to Main → Validate → Plan (uat) → Apply (uat, manual)
```

Only runs when changes are merged to main branch.

### Production Deployment

```
Tag Push → Validate → Plan (prod) → Apply (prod, manual)
```

Only triggered by git tags for production releases.

## Jobs

### validate
- Runs on: Merge requests and main branch
- Action: Validates Terraform configuration
- Duration: ~2 minutes

### plan:dev
- Runs on: Merge requests and main branch
- Action: Creates execution plan for dev environment
- Artifacts: `tfplan-dev` (expires in 1 week)
- Duration: ~5 minutes

### plan:uat
- Runs on: Main branch only
- Action: Creates execution plan for UAT environment
- Artifacts: `tfplan-uat` (expires in 1 week)
- Duration: ~5 minutes

### plan:prod
- Runs on: Git tags only
- Action: Creates execution plan for production
- Artifacts: `tfplan-prod` (expires in 1 week)
- Duration: ~5 minutes

### apply:dev
- Triggered: Manual (after plan:dev succeeds)
- Action: Applies dev infrastructure changes
- Duration: ~10 minutes

### apply:uat
- Triggered: Manual (after plan:uat succeeds)
- Action: Applies UAT infrastructure changes
- Duration: ~10 minutes

### apply:prod
- Triggered: Manual (after plan:prod succeeds)
- Action: Applies production infrastructure changes
- Duration: ~15 minutes

## Remote State Management

State files are stored in Azure Blob Storage:

```
Storage Account: terraformstateaccount
Containers:
  - tfstate-dev
  - tfstate-uat
  - tfstate-prod
```

Configuration is in `environments/<env>/backend.tfvars`

## Best Practices

1. **Always review plan before apply** - The apply stage requires manual trigger
2. **Use tags for production** - Only tag commits ready for production
3. **Test in dev first** - Deploy to dev environment before UAT/prod
4. **Lock production** - Consider adding approval rules for production applies
5. **Monitor state files** - Ensure backup and locking are configured

## Troubleshooting

### Authentication Errors
- Verify Azure credentials in GitLab variables
- Check Service Principal has required permissions
- Ensure ARM_USE_OIDC matches your authentication method

### State Lock Errors
- Check if another apply is running
- Verify blob storage is accessible
- Review backend configuration in `backend.tfvars`

### Plan Artifacts Not Found
- Ensure plan stage completed successfully
- Check job dependencies are correct
- Verify artifacts haven't expired

## Local Development

For local testing, use the Makefile:

```bash
make init ENV=dev
make plan ENV=dev
make apply ENV=dev
```

See Makefile for all available commands.

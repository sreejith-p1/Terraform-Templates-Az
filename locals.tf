# Local values are computed once and reused to keep naming and tags consistent.
locals {
  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = var.project_name
    CreatedAt   = timestamp()
  }

  # Used to build consistent names for resources across the deployment.
  resource_prefix = "${var.project_name}-${var.environment}"
}

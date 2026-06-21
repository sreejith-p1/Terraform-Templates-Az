locals {
  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = var.project_name
    CreatedAt   = timestamp()
  }

  resource_prefix = "${var.project_name}-${var.environment}"
}

# Terraform version requirement and backend configuration for state storage.
terraform {
  required_version = ">= 1.0"

  backend "azurerm" {}
}

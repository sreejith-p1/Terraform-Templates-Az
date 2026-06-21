variable "environment" {
  type        = string
  description = "Deployment environment (dev/uat/prod)"

  validation {
    condition     = contains(["dev", "uat", "prod"], var.environment)
    error_message = "Environment must be dev, uat, or prod."
  }
}

variable "project_name" {
  type        = string
  description = "Project name for resource naming"

  validation {
    condition     = length(var.project_name) <= 10
    error_message = "Project name must be 10 characters or less."
  }
}

variable "resource_group_name" {
  type        = string
  description = "Name of the Azure Resource Group"
}

variable "location" {
  type        = string
  description = "Azure region for resources"
  default     = "eastus"
}

variable "subscription_id" {
  type        = string
  sensitive   = true
  description = "Azure Subscription ID"
}

variable "client_id" {
  type        = string
  sensitive   = true
  description = "Azure Client ID (Service Principal)"
}

variable "client_secret" {
  type        = string
  sensitive   = true
  description = "Azure Client Secret (Service Principal)"
}

variable "tenant_id" {
  type        = string
  sensitive   = true
  description = "Azure Tenant ID"
}

variable "vm_size" {
  type        = string
  default     = "Standard_DS2_v2"
  description = "Size of the Windows VMs"
}

variable "mysql_sku" {
  type        = string
  default     = "GP_Gen5_2"
  description = "SKU for Azure MySQL"
}

variable "vm_count" {
  type        = number
  default     = 3
  description = "Number of VMs to create"

  validation {
    condition     = var.vm_count >= 1 && var.vm_count <= 10
    error_message = "VM count must be between 1 and 10."
  }
}

variable "vmss_instance_count" {
  type        = number
  default     = 5
  description = "Number of instances in VMSS"

  validation {
    condition     = var.vmss_instance_count >= 1 && var.vmss_instance_count <= 100
    error_message = "VMSS instance count must be between 1 and 100."
  }
}

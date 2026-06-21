variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure location for resources"
}

variable "environment" {
  type        = string
  description = "Environment name (dev/uat/prod)"
}

variable "project_name" {
  type        = string
  description = "Project name for resource naming"
}

variable "storage_tier" {
  type        = string
  default     = "Standard"
  description = "Storage account tier"
}

variable "storage_replication_type" {
  type        = string
  default     = "GRS"
  description = "Storage account replication type"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
}

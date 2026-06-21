# Front Door module input variables describe the backend resources and context used to build the endpoint.
variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "environment" {
  type        = string
  description = "Environment name (dev/uat/prod)"
}

variable "project_name" {
  type        = string
  description = "Project name for resource naming"
}

variable "backend_vm_ids" {
  type        = list(string)
  description = "List of backend VM IDs for Front Door"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
}

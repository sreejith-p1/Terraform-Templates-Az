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

variable "vnet_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR block for the virtual network"
}

variable "subnet_cidrs" {
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
  description = "CIDR blocks for subnets"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
}

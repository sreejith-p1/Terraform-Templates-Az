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

variable "instance_count" {
  type        = number
  description = "Number of instances in VMSS"
  default     = 5
}

variable "vm_size" {
  type        = string
  description = "VM instance size"
  default     = "Standard_DS1_v2"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID where VMSS will be deployed"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
}

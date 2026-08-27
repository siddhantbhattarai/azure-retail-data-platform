variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "azure-retail-data-platform"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "Environment must be dev, test, or prod."
  }
}

variable "location" {
  description = "Azure region where resources will be deployed"
  type        = string
  default     = "southeastasia"
}

variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
  default     = "rg-azure-retail-data-platform-dev"
}

variable "storage_account_name" {
  description = "Globally unique Azure Storage Account name"
  type        = string
}

variable "tags" {
  description = "Common tags applied to Azure resources"
  type        = map(string)

  default = {
    project     = "azure-retail-data-platform"
    environment = "dev"
    managed_by  = "terraform"
  }
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "location" {
  description = "The Azure region to deploy resources."
  type        = string
  default     = "eastus"
}

variable "storage_account_name" {
  description = "The globally unique name of the Azure Storage account."
  type        = string
}

variable "container_name" {
  description = "The name of the Azure Storage container."
  type        = string
}

variable "app_registration_name" {
  description = "The name of the Azure AD App Registration."
  type        = string
}

variable "create" {
  description = "Controls if terraform resources should be created (it affects almost all resources)"
  default = true
}

variable "environment" {
  description = "The nick name identifying the type of environment (i.e. test, staging, production)"
}

variable "location" {
  description = "The data center location where all resources will be put into."
}

variable "resource_name_prefix" {
  description = "The prefix used to name all resources created."
}

locals {
  # Define resource names based on the following convention:
  # {azurerm_resource_name_prefix}-RESOURCE_TYPE-{environment}
  azurerm_apim_name = "${var.resource_name_prefix}-apim-${var.environment}"
}

# TF_VAR_ADB2C_TENANT_ID
variable "ADB2C_TENANT_ID" {
  type        = "string"
  description = "Name of the Active Directory B2C tenant used in the API management portal authentication flow"
  default     = "agidweb"
}
<<<<<<< HEAD

=======
>>>>>>> 42a8218922e926da89c74396b34b96a9e107e4fe
variable "apim_configuration_path" {
  default     = "common/apim.json"
  description = "Path of the (json) file that contains the configuration settings for the API management resource"
}

variable "notification_sender_email" {
  type        = "string"
  description = "Email address for notifications"
}

variable "resource_group_name" {
  type        = "string"
  description = "Resource group name"
}

<<<<<<< HEAD
=======

>>>>>>> 42a8218922e926da89c74396b34b96a9e107e4fe
variable "publisher_email" {
  type        = "string"
  description = "Publisher email address"
}

variable "publisher_name" {
  type        = "string"
  description = "Publisher name"
}

variable "sku_name" {
  type        = "string"
  description = ""
  default = "Consumption"
}


variable "sku_capacity" {
  description = ""
  default = 1
}

variable "key_vault_id" {
  description = ""
}

variable "azurerm_function_app_name" {
  default = "undefined"
 }

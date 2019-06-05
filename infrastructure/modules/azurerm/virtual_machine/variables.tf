# General Variables

variable "environment" {
  description = "The nick name identifying the type of environment (i.e. test, staging, production)"
}

variable "location" {
  description = "The data center location where all resources will be put into."
}

variable "resource_name_prefix" {
  description = "The prefix used to name all resources created."
}

variable "infra_resource_group_name" {
  description = "The name of the infrastructure resource group."
}

# Network Variables

variable "vnet_name" {
  description = "The name of the virtual network connecting all resources."
}

variable "subnet_name" {
  description = "The name of the virtual network subnet."
}

variable "azurerm_network_interface_ip_configuration_private_ip_address" {
  description = "The static private IP address to assign to the VM. It must be compatible with the subnet specified."
}

# Storage account for VM boot diagnostics

variable "storage_account_name" {
  description = "The suffix used to identify the specific Azure storage account"
}

# Virtual Machine Variables

variable "vm_name" {
  description = "The name of the virtual machine."
}

variable "azurerm_virtual_machine_size" {
  description = "The size of the virtual machine."
}

variable "azurerm_virtual_machine_storage_os_disk_type" {
  description = "The managed OS disk type of the virtual machine."
  default     = "Standard_LRS"
}

variable "default_admin_username" {
  description = "The username of the administrator of the virtual machine."
}

variable "azurerm_key_vault_name" {
  description = "The Azure key vault name."
}

variable "azurerm_key_vault_secret_default_admin_password_name" {
  description = "The vault key containing the default Linux admin password."
}

variable "ssh_public_key_path" {
  description = "The path to the SSH public key file, used to authorize initial SSH access to the machine."
}

variable "ssh_private_key_path" {
  description = "The path to the SSH private key file, used to authorize initial SSH access to the machine."
}

variable "public_ip" {
  description = "If a public IP should or should not be associated to the VM."
}

variable "azurerm_network_security_rules" {
  type        = "list"
  description = "The list of network security rules."
}

locals {
  azurerm_virtual_machine_os_profile_computer_name = "${var.vm_name}"

  # Define resource names based on the following convention:
  # {azurerm_resource_name_prefix}-RESOURCE_TYPE-{environment}
  azurerm_resource_group_name                      = "${var.resource_name_prefix}-rg-${var.environment}"
  azurerm_storage_account_name                     = "${var.resource_name_prefix}${var.storage_account_name}${var.environment}"
  azurerm_virtual_machine_name                     = "${var.resource_name_prefix}-vm-${var.vm_name}-${var.environment}"
  azurerm_public_ip_name                           = "${var.resource_name_prefix}-pip-${var.vm_name}-${var.environment}"
  azurerm_network_security_group_name              = "${var.resource_name_prefix}-sg-${var.vm_name}-${var.environment}"
  azurerm_network_interface_name                   = "${var.resource_name_prefix}-nic-${var.vm_name}-${var.environment}"
  azurerm_network_interface_ip_configuration_name  = "${var.resource_name_prefix}-nic-ip-config-${var.vm_name}-${var.environment}"
  azurerm_virtual_machine_storage_os_disk_name     = "${var.resource_name_prefix}-disk-os-${var.vm_name}-${var.environment}"
}

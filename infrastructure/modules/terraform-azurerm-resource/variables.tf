variable "api_version" {
  description = "Version of the REST API to use for creating the resource."
}

variable "deployment_mode" {
  default     = "Incremental"
  description = "Specifies the mode that is used to deploy resources. This value could be either Incremental or Complete."
}

variable "kind" {
  default     = ""
  description = "Some resources allow a value that defines the type of resource you deploy. For example, you can specify the type of Cosmos DB to create."
}

variable "location" {
  default     = ""
  description = "Some resources allow a value that defines the type of resource you deploy. For example, you can specify the type of Cosmos DB to create."
}

variable "name" {
  description = "Name of the resource. The name must follow URI component restrictions defined in RFC3986."
}

variable "plan" {
  default     = {}
  description = "Some resources allow values that define the plan to deploy. For example, you can specify the marketplace image for a virtual machine."
}

variable "properties" {
  default     = {}
  description = "Resource-specific configuration settings. The values for the properties are the same as the values you provide in the request body for the REST API operation (PUT method) to create the resource."
}

variable "resource_group_name" {
  description = " The name of the resource group in which to create the template deployment."
}

variable "sku" {
  default     = {}
  description = "Some resources allow values that define the SKU to deploy. For example, you can specify the type of redundancy for a storage account."
}

variable "tags" {
  default     = {}
  description = "Tags that are associated with the resource."
}

variable "type" {
  description = "Type of the resource. This value is a combination of the namespace of the resource provider and the resource type (such as Microsoft.Storage/storageAccounts)."
}

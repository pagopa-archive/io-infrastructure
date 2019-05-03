# Create any Azure resource

Create or update any Azure resource.

This module provisions the following resources:

- [`azurerm_template_deployment`](https://www.terraform.io/docs/providers/azurerm/r/template_deployment.html)

**Tip💡** Use native Terraform resources where possible rather than ARM Templates.

**Note⚠️** Due to the way the underlying Azure API is designed, Terraform can only manage the deployment of the ARM Template - and not any resources which are created by it. This means that when deleting the [`azurerm_template_deployment`](https://www.terraform.io/docs/providers/azurerm/r/template_deployment.html) resource, Terraform will only remove the reference to the deployment, whilst leaving any resources created by that ARM Template Deployment. One workaround for this is to use a unique Resource Group for each ARM Template Deployment, which means deleting the Resource Group would contain any resources created within it - however this isn't ideal.

## Usage

Example 1 (Integration Account):

```hcl
resource "azurerm_resource_group" "integration_account" {
  name     = "my-integration-account-rg"
  location = "westeurope"
}

module "integration_account" {
  source              = "innovationnorway/resource/azurerm"
  api_version         = "2016-06-01"
  type                = "Microsoft.Logic/IntegrationAccounts"
  name                = "my-integration-account"
  resource_group_name = "${azurerm_resource_group.integration_account.name}"
  location            = "${azurerm_resource_group.integration_account.location}"

  sku {
    name = "Standard"
  }
}

output "integration_account_id" {
  value = "${module.integration_account.id}"
}
```

Example 2 (API Management Service):

```hcl
resource "azurerm_resource_group" "api_management" {
  name     = "my-api-management-rg"
  location = "westeurope"
}

module "api_management" {
  source              = "innovationnorway/resource/azurerm"
  api_version         = "2018-01-01"
  type                = "Microsoft.ApiManagement/service"
  name                = "my-api-management-service"
  resource_group_name = "${azurerm_resource_group.api_management.name}"
  location            = "${azurerm_resource_group.api_management.location}"

  properties {
    publisherEmail = "name@example.com"
    publisherName  = "ACME Corp"
  }

  sku {
    name     = "Developer"
    capacity = 1
  }
}

output "api_management_service_id" {
  value = "${module.integration_account.id}"
}
```

## Inputs

### name

(Required) Name of the resource.

### resource_group_name

(Required) The name of the resource group in which to create the template deployment.


### location

(Optional) Specifies the supported Azure location. Most resource types require a location, but some types (such as a role assignment) don't require a location.

### api_version

(Required) Version of the REST API to use for creating the resource.

### deployment_mode

Specifies the mode that is used to deploy resources. This value could be either `Incremental` or `Complete`. Note that you will almost always want this to be set to `Incremental` otherwise the deployment will destroy all infrastructure not specified within the template, and Terraform will not be aware of this. Default is `Incremental`.

### type

(Required) Type of the resource. This value is a combination of the namespace of the resource provider and the resource type (such as `Microsoft.Storage/storageAccounts`).

### plan

(Optional) Some resources allow values that define the plan to deploy. For example, you can specify the marketplace image for a virtual machine.

### properties

(Optional) Resource-specific configuration settings. The values for the properties are the same as the values you provide in the request body for the REST API operation (PUT method) to create the resource.

### sku

(Optional) Some resources allow values that define the SKU to deploy. For example, you can specify the type of redundancy for a storage account.

### kind

(Optional) Some resources allow a value that defines the type of resource you deploy. For example, you can specify the type of Cosmos DB to create.

### tags

Tags that are associated with the resource.

## Outputs

### id

The resource ID.

### template_deployment_id

The template deployment ID.


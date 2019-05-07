# terraform-azurerm-function-app

## Create a Function App in Azure

This terraform module deploys a Function App on dedicated app service plan, with autoscaling, in Azure.

Installs following resources
- Storage account
- App service plan
- Function app
- Auto scale settings for app service plan. 


## Usage

```hcl

resource "azurerm_resource_group" "image_resizer" {
  name     = "image-resizer-func-rg"
  location = "westeurope"
}

module "function_app" {
  source                   = "innovationnorway/function-app/azurerm"
  function_app_name        = "image-resizer-func"
  resource_group_name      = "${azurerm_resource_group.image_resizer.name}"
  location                 = "${azurerm_resource_group.image_resizer.location}"
  environment              = "lab"
  function_verion          = "beta"
  release                  = "release 2018-07-21.001"
  account_replication_type = "LRS"
  
  app_settings {
    "FUNCTIONS_WORKER_RUNTIME" = "dotnet"
  }

  tags {
      a       = "b",
      project = "image-resizing"
  }
}

```

## Inputs

### resource_group_name
The resource group where the resources should be created.

### location
The azure datacenter location where the resources should be created.

### function_app_name
The name for the function app. Without environment naming.

### account_replication_type
The Storage Account replication type. See azurerm_storage_account module for posible values.
Defaults to "LRS"

### app_settings
Application settings to insert on creating the function app. Following updates will be ignored, and has to be set manually. Updates done on application deploy or in portal will not affect terraform state file.

### tags
A map of tags to add to all resources
Defaults to "westeurope"
 
### tags
A map of tags to add to all resources. Release and Environment will be auto tagged. 

### environment
The environment where the infrastructure is deployed.

### release
The release the deploy is based on

### function_version
The runtime version the function app should have.
Defaults to "beta"

## Outputs

### identity
The MSI identities set on the function app. Returns a list of identities.

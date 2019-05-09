# API management

## Create and configure the API management service

# resource "azurerm_api_management" "azurerm_apim" {
#   count = "${var.create ? 1 : 0}"

#   name                      = "${local.azurerm_apim_name}"
#   location                  = "${var.location}"
#   resource_group_name       = "${var.resource_group_name}"
#   publisher_name            = "${var.publisher_name}"
#   publisher_email           = "${var.publisher_email}"
#   notification_sender_email = "${var.notification_sender_email}"

#   sku {
#     name     = "${var.sku_name}"
#     capacity = "${var.sku_capacity}"
#   }

#   hostname_configuration {}
# }

module "azurerm_api_management" {
  source              = "../terraform-azurerm-resource"
  api_version         = "2019-01-01"
  type                = "Microsoft.ApiManagement/service/apis"
  name                = "${local.azurerm_apim_name}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  tags = "${var.tags}" 

  properties {
    publisherEmail     = "${var.publisher_email}"
    publisherName      = "${var.publisher_name}"
    virtualNetworkType = "${var.virtualNetworkType}"
    virtualNetworkConfiguration = "${var.virtualNetworkConfiguration}"
customProperties = "${var.customProperties}"
  }

  sku {
    name     = "${var.sku_name}"
    capacity = "${var.sku_capacity}"
  }
}

resource "null_resource" "azurerm_apim" {
  count = "${var.create ? 1 : 0}"

  triggers = {
    # azurerm_function_app_id     = "${azurerm_function_app.azurerm_function_app.id}"
    # azurerm_resource_group_name = "${azurerm_resource_group.azurerm_resource_group.name}"
    azurerm_function_app_name = "${var.azurerm_function_app_name}"
    provisioner_version = "${var.provisioner_version}"
  }

  provisioner "local-exec" {
    command = "${join(" ", list(
      "ts-node azurerm_apim.ts",
      "--environment ${var.environment}",
      "--azurerm_resource_group ${var.resource_group_name}",
      "--azurerm_apim ${local.azurerm_apim_name}",
      "--azurerm_apim_scm_url ${lookup(module.azurerm_api_management.outputs, "scm_url")}",
      "--azurerm_functionapp ${var.azurerm_function_app_name}",
      "--apim_configuration_path ${var.apim_configuration_path}"))
    }"

    environment = {
      ENVIRONMENT                     = "${var.environment}"
      TF_VAR_ADB2C_TENANT_ID          = "${var.ADB2C_TENANT_ID}"
      TF_VAR_DEV_PORTAL_CLIENT_ID     = "${data.azurerm_key_vault_secret.dev_portal_client_id.value}"
      TF_VAR_DEV_PORTAL_CLIENT_SECRET = "${data.azurerm_key_vault_secret.dev_portal_client_secret.value}"
    }
  }
}

# Client ID of an application used in the API management portal authentication flow
data "azurerm_key_vault_secret" "dev_portal_client_id" {
  name         = "dev-portal-client-id-${var.environment}"
  key_vault_id = "${var.key_vault_id}"
}

# Client secret of the application used in the API management portal authentication flow
data "azurerm_key_vault_secret" "dev_portal_client_secret" {
  name         = "dev-portal-client-secret-${var.environment}"
  key_vault_id = "${var.key_vault_id}"
}

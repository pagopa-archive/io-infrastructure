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
  source              = "innovationnorway/resource/azurerm"
  api_version         = "2019-01-01"
  type                = "Microsoft.ApiManagement/service"
  name                = "${local.azurerm_apim_name}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  # tags                = "${var.tags}"

  properties {
    publisherEmail              = "${var.publisher_email}"
    publisherName               = "${var.publisher_name}"
    virtualNetworkType          = "${var.virtualNetworkType}"
    # virtualNetworkConfiguration = "${var.virtualNetworkConfiguration}"
    # customProperties            = "${var.customProperties}"
  }

  sku {
    name     = "${var.sku_name}"
    capacity = "${var.sku_capacity}"
  }
}

# locals {
#   # Common tags to be assigned to all resources
# "${merge(map("Name", (var.single_nat_gateway ? "${var.name}-${var.private_subnet_suffix}" : format("%s-${var.private_subnet_suffix}-%s", var.name, element(var.azs, count.index)))), var.tags, var.private_route_table_tags)}"
#   apim_properties = {
#     publisherEmail              = "${var.publisher_email}"
#     publisherName               = "${var.publisher_name}"
#     virtualNetworkType          = "${var.virtualNetworkType}"
#     # TODO: need a conditional to remove name when value is null
#     # virtualNetworkConfiguration = "${var.virtualNetworkConfiguration}"
#     # customProperties            = "${var.customProperties}"
#   }
# }

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
      "ts-node --files ${var.apim_provisioner}",
      "--environment ${var.environment}",
      "--azurerm_resource_group ${var.resource_group_name}",
      "--azurerm_apim ${local.azurerm_apim_name}",
      "--azurerm_apim_scm_url https://${local.azurerm_apim_name}.scm.azure-api.net/",
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




## Connect API management developer portal authentication to Active Directory B2C

resource "null_resource" "azurerm_apim_adb2c" {
  count = "${var.environment == "production" ? 1 : 0}"

  triggers = {
    azurerm_function_app_id     = "${azurerm_function_app.azurerm_function_app.id}"
    azurerm_resource_group_name = "${azurerm_resource_group.azurerm_resource_group.name}"
    azurerm_apim_id             = "${azurerm_api_management.azurerm_apim.id}"
    provisioner_version         = "1"
  }

  depends_on = ["azurerm_api_management.azurerm_apim"]

  provisioner "local-exec" {
    command = "${join(" ", list(
      "ts-node ${var.apim_adb2c_provisioner}",
      "--environment ${var.environment}",
      "--azurerm_resource_group ${azurerm_resource_group.azurerm_resource_group.name}",
      "--azurerm_apim ${local.azurerm_apim_name}",
      "--apim_configuration_path ${var.apim_configuration_path}",
      "--adb2c_tenant_id ${var.ADB2C_TENANT_ID}",
      "--adb2c_portal_client_id ${data.azurerm_key_vault_secret.dev_portal_client_id.value}",
      "--adb2c_portal_client_secret '${data.azurerm_key_vault_secret.dev_portal_client_secret.value}'"))
    }"

    environment = {
      ENVIRONMENT = "${var.environment}"
      TF_VAR_ADB2C_TENANT_ID = "${var.ADB2C_TENANT_ID}"
      TF_VAR_DEV_PORTAL_CLIENT_ID = "${data.azurerm_key_vault_secret.dev_portal_client_id.value}"
      TF_VAR_DEV_PORTAL_CLIENT_SECRET = "${data.azurerm_key_vault_secret.dev_portal_client_secret.value}"
    }
  }
}

## Connect the API management resource with the EventHub logger

resource "null_resource" "azurerm_apim_logger" {
  count = "${var.environment == "production" ? 1 : 0}"

  triggers = {
    azurerm_function_app_id            = "${azurerm_function_app.azurerm_function_app.id}"
    azurerm_resource_group_name        = "${azurerm_resource_group.azurerm_resource_group.name}"
    azurerm_apim_eventhub_id           = "${azurerm_eventhub.azurerm_apim_eventhub.id}"
    azurerm_eventhub_connection_string = "${azurerm_eventhub_authorization_rule.azurerm_apim_eventhub_rule.primary_connection_string}"
    azurerm_apim_id                    = "${azurerm_api_management.azurerm_apim.id}"
    provisioner_version                = "1"
  }

  depends_on = ["azurerm_api_management.azurerm_apim"]

  provisioner "local-exec" {
    command = "${join(" ", list(
      "ts-node ${var.apim_logger_provisioner}",
      "--environment ${var.environment}",
      "--azurerm_resource_group ${azurerm_resource_group.azurerm_resource_group.name}",
      "--azurerm_apim ${local.azurerm_apim_name}",
      "--azurerm_apim_eventhub ${azurerm_eventhub.azurerm_apim_eventhub.name}",
      "--apim_configuration_path ${var.apim_configuration_path}",
      "--azurerm_apim_eventhub_connstr ${azurerm_eventhub_authorization_rule.azurerm_apim_eventhub_rule.primary_connection_string}"))
    }"

    environment = {
      ENVIRONMENT = "${var.environment}"
      TF_VAR_ADB2C_TENANT_ID = "${var.ADB2C_TENANT_ID}"
      TF_VAR_DEV_PORTAL_CLIENT_ID = "${data.azurerm_key_vault_secret.dev_portal_client_id.value}"
      TF_VAR_DEV_PORTAL_CLIENT_SECRET = "${data.azurerm_key_vault_secret.dev_portal_client_secret.value}"
    }
  }
}

## Setup OpenAPI in API management service from swagger specs exposed by Functions

resource "null_resource" "azurerm_apim_api" {
  count = "${var.environment == "production" ? 1 : 0}"

  triggers = {
    azurerm_function_app_id     = "${azurerm_function_app.azurerm_function_app.id}"
    azurerm_resource_group_name = "${azurerm_resource_group.azurerm_resource_group.name}"
    azurerm_apim_id             = "${azurerm_api_management.azurerm_apim.id}"
    provisioner_version         = "1"
  }

  depends_on = ["null_resource.azurerm_apim_logger"]

  provisioner "local-exec" {
    command = "${join(" ", list(
      "ts-node ${var.apim_api_provisioner}",
      "--environment ${var.environment}",
      "--azurerm_resource_group ${azurerm_resource_group.azurerm_resource_group.name}",
      "--azurerm_apim ${local.azurerm_apim_name}",
      "--azurerm_functionapp ${azurerm_function_app.azurerm_function_app.name}",
      "--apim_configuration_path ${var.apim_configuration_path}",
      "--apim_include_policies",
      "--apim_include_products"))
    }"

    environment = {
      ENVIRONMENT = "${var.environment}"
      TF_VAR_ADB2C_TENANT_ID = "${var.ADB2C_TENANT_ID}"
      TF_VAR_DEV_PORTAL_CLIENT_ID = "${data.azurerm_key_vault_secret.dev_portal_client_id.value}"
      TF_VAR_DEV_PORTAL_CLIENT_SECRET = "${data.azurerm_key_vault_secret.dev_portal_client_secret.value}"
    }
  }
}
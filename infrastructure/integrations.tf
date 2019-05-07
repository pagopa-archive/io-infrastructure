## Create and configure the API management service
module "azurerm_function_app" {
    source               = "./modules/azurerm_function_app"
    environment          = "${var.environment_short}"
    resource_name_prefix = "${var.azurerm_resource_name_prefix}"
    location             = "${azurerm_resource_group.azurerm_resource_group.location}"
    resource_group_name  = "${azurerm_resource_group.azurerm_resource_group.name}"
       azurerm_functionapp_git_repo   = "${var.azurerm_functionapp_git_repo}"
    azurerm_functionapp_git_branch = "${var.azurerm_functionapp_git_branch}"
    website_git_provisioner = "${var.website_git_provisioner}"

  key_vault_id = "${var.key_vault_id}"
    app_settings = {
    # "AzureWebJobsStorage" = "${azurerm_storage_account.azurerm_functionapp_storage_account.primary_connection_string}"

    "COSMOSDB_NAME" = "${local.azurerm_cosmosdb_documentdb_name}"

    "QueueStorageConnection" = "${azurerm_storage_account.azurerm_storage_account.primary_connection_string}"

    "APPINSIGHTS_INSTRUMENTATIONKEY" = "${azurerm_application_insights.azurerm_application_insights.instrumentation_key}"

    # Avoid edit functions code from the Azure portal
    "FUNCTION_APP_EDIT_MODE" = "readonly"

    # AzureWebJobsSecretStorageType may be `disabled` or `Blob`
    # When set to `Blob` the API manager task won't be able
    # to retrieve the master key
    "AzureWebJobsSecretStorageType" = "disabled"

    "WEBSITE_HTTPLOGGING_RETENTION_DAYS" = "3"

    "DIAGNOSTICS_AZUREBLOBRETENTIONINDAYS" = "1"

    "WEBSITE_NODE_DEFAULT_VERSION" = "6.11.2"

    "SCM_USE_FUNCPACK_BUILD" = "1"

    "MESSAGE_CONTAINER_NAME" = "${azurerm_storage_blob.azurerm_message_blob.name}"

    "MAILUP_USERNAME" = "${data.azurerm_key_vault_secret.mailup_username.value}"

    "MAILUP_SECRET" = "${data.azurerm_key_vault_secret.mailup_secret.value}"

    "MAIL_FROM_DEFAULT" = "${var.default_sender_email}"

    "WEBHOOK_CHANNEL_URL" = "${var.webhook_channel_url}${data.azurerm_key_vault_secret.webhook_channel_url_token.value}"

    "PUBLIC_API_URL" = "${coalesce(var.functions_public_api_url, local.default_functions_public_api_url)}"

    # API management API-Key (Ocp-Apim-Subscription-Key)
    # set the value manually or with a local provisioner
    "PUBLIC_API_KEY" = "${data.azurerm_key_vault_secret.functions_public_api_key.value}"
    }

    connection_string = [
    {
    name  = "COSMOSDB_KEY"
    type  = "Custom"
    value = "${azurerm_cosmosdb_account.azurerm_cosmosdb.primary_master_key}"
    },
    {
    name  = "COSMOSDB_URI"
    type  = "Custom"
    value = "https://${azurerm_cosmosdb_account.azurerm_cosmosdb.name}.documents.azure.com:443/"
    },
    ]

  #   key_vault_id = "${var.key_vault_id}"
  #   sku_name = "Developer"
  #   # sku_capacity = 1
}

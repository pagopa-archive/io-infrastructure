output "identity_principal_id" {
  description = "The MSI identity principal id set on the function app."
  value       = "${azurerm_function_app.functionapp.identity.0.principal_id}"
}

output "identity_tenant_id" {
  description = "The MSI identity tenant id set on the function app."
  value       = "${azurerm_function_app.functionapp.identity.0.tenant_id}"
}

output "storage_account_name" {
  description = "The name of the storage account created for the function app"
  value       = "${azurerm_storage_account.funcsta.name}"
}

output "storage_account_connection_string" {
  description = "Connection string to the storage account created for the function app"
  value       = "${azurerm_storage_account.funcsta.primary_connection_string}"
  sensitive   = true
}

output "storage_account_primary_access_key" {
  description = "Primary access key to the storage account created for the function app"
  value       = "${azurerm_storage_account.funcsta.primary_access_key}"
  sensitive   = true
}

output "id" {
  description = "The Azure resource group id"
  value       = "${module.azurerm_api_management.id}"
}

output "outputs" {
  description = "The Azure resource group id"
  value       = "${jsonencode(module.azurerm_api_management.outputs)}"
}

# output "gateway_url" {
#   value = "${azurerm_api_management.azurerm_apim.*.gateway_url}"
# }

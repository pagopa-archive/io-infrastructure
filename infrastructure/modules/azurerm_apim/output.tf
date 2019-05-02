output "id" {
  description = "The Azure resource group id"
  value       = "${azurerm_api_management.azurerm_apim.*.id}"
}

output "gateway_url " {
   value = ""
}

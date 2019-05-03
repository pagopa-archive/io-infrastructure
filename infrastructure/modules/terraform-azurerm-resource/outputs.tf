output "id" {
  description = "The resource ID."
  value       = "${lookup(azurerm_template_deployment.resource.outputs, "id", "")}"
}

output "template_deployment_id" {
  description = "The template deployment ID."
  value       = "${azurerm_template_deployment.resource.id}"
}


output "outputs" {
  description = "The Azure resource group id"
  value       = "${azurerm_template_deployment.resource.outputs}"

  # value       = "${jsonencode(azurerm_template_deployment.resource.outputs)}"
}
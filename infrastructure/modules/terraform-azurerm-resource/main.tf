provider "azurerm" {
  version = "~> 1.13"
}

resource "azurerm_template_deployment" "resource" {
  name                = "${var.name}"
  resource_group_name = "${var.resource_group_name}"
  deployment_mode     = "${var.deployment_mode}"

  template_body = <<DEPLOY
{
    "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "apiVersion": {
            "type": "string"
        },
        "kind": {
            "type": "string"
        },
        "location": {
            "type": "string"
        },
        "name": {
            "type": "string"
        },
        "plan": {
            "type": "string"
        },
        "properties": {
            "type": "string"
        },
        "sku": {
            "type": "string"
        },
        "tags": {
            "type": "string"
        }
    },
    "resources": [
        {
            "apiVersion": "[parameters('apiVersion')]",
            "name": "[parameters('name')]",
            "type": "${var.type}",
            ${var.location != "" ? "\"location\":\"[parameters('location')]\"," : ""}
            "properties": "[json(parameters('properties'))]",
            ${var.kind != "" ? "\"kind\":\"[parameters('kind')]\"," : ""}
            ${length(var.plan) > 0 ? "\"plan\":\"[json(parameters('plan'))]\"," : ""}
            ${length(var.sku) > 0 ? "\"sku\":\"[json(parameters('sku'))]\"," : ""}
            "tags": "[json(parameters('tags'))]"
        }
    ],
    "outputs": {
        "id": {
            "type": "string",
            "value": "[resourceId('${var.type}', parameters('name'))]"
        }
    }
}
DEPLOY

  parameters {
    "apiVersion" = "${var.api_version}"
    "kind"       = "${var.kind}"
    "location"   = "${var.location}"
    "name"       = "${var.name}"
    "plan"       = "${jsonencode(var.plan)}"
    "properties" = "${jsonencode(var.properties)}"
    "sku"        = "${jsonencode(var.sku)}"
    "tags"       = "${jsonencode(var.tags)}"
  }
}

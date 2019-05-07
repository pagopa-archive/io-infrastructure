resource "azurerm_storage_account" "funcsta" {
  name                     = "${local.storage_account_name}"
  resource_group_name      = "${var.resource_group_name}"
  location                 = "${var.location}"
  account_tier             = "Standard"
  account_replication_type = "${var.account_replication_type}"
  enable_blob_encryption   = "true"
  enable_file_encryption   = "true"

  tags = "${merge(var.tags, map("environment", var.environment), map("release", var.release))}"
}

resource "azurerm_app_service_plan" "serviceplan" {
  name                = "${local.app_service_plan_name}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  sku {
    tier = "Standard"
    size = "S1"
  }

  tags = "${merge(var.tags, map("environment", var.environment), map("release", var.release))}"
}

resource "azurerm_function_app" "functionapp" {
  name                      = "${local.function_app_name}"
  location                  = "${var.location}"
  resource_group_name       = "${var.resource_group_name}"
  app_service_plan_id       = "${azurerm_app_service_plan.serviceplan.id}"
  storage_connection_string = "${azurerm_storage_account.funcsta.primary_connection_string}"
  https_only                = true
  version                   = "${var.function_version}"
  client_affinity_enabled   = false

  tags = "${merge(var.tags, map("environment", var.environment), map("release", var.release))}"

  site_config {
    always_on = true
  }

  identity {
    type = "SystemAssigned"
  }

  app_settings = "${var.app_settings}"

  lifecycle {
    ignore_changes = ["app_settings"]
  }
}

resource "azurerm_autoscale_setting" "app_service_auto_scale" {
  name                = "${local.autoscale_settings_name}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  target_resource_id  = "${azurerm_app_service_plan.serviceplan.id}"

  profile {
    name = "Scale on CPU usage"

    capacity {
      default = 1
      minimum = 1
      maximum = "${azurerm_app_service_plan.serviceplan.maximum_number_of_workers}"
    }

    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = "${azurerm_app_service_plan.serviceplan.id}"
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 70
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT10M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = "${azurerm_app_service_plan.serviceplan.id}"
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 25
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }

  notification {
    # operation = "Scale"

    email {
      send_to_subscription_administrator    = true
      send_to_subscription_co_administrator = true
    }
  }
}

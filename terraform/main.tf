# FUNCTION APP
resource "azurerm_function_app" "funcy_function_app" {
  name                       = var.function_name
  resource_group_name        = var.target_resource_group_name
  location                   = var.default_location
  app_service_plan_id        = azurerm_app_service_plan.funcy_app_service_plan.id
  storage_account_name       = azurerm_storage_account.funcy_storage.name
  storage_account_access_key = azurerm_storage_account.funcy_storage.primary_access_key
  # os_type                    = "linux"
  version    = "~3"
  https_only = true
  identity {
    type = "SystemAssigned"
  }
  site_config {
    # always_on = true
  }
  
  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY  = azurerm_application_insights.funcy_application_insights.instrumentation_key
    WEBSITE_RUN_FROM_PACKAGE        = "1"
    WEBSITE_ENABLE_SYNC_UPDATE_SITE = true
  }
  lifecycle {
    ignore_changes = [
      # Ignore changes to tags because additional tags are applied via policies
      tags
    ]
  }
}

resource "azurerm_app_service_plan" "funcy_app_service_plan" {
  name                = local.plan_name
  resource_group_name = var.target_resource_group_name
  location            = var.default_location
  kind                = "Windows"
  # reserved            = true

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_storage_account" "funcy_storage" {
  name                     = local.storage_name
  resource_group_name      = var.target_resource_group_name
  location                 = var.default_location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

# APPLICATION INSIGHTS
resource "azurerm_log_analytics_workspace" "funcy_log_analytics_workspace" {
  name                = local.appi_name
  resource_group_name = var.target_resource_group_name
  location            = var.default_location
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_application_insights" "funcy_application_insights" {
  name                = local.workspace_name
  resource_group_name = var.target_resource_group_name
  location            = var.default_location
  workspace_id        = azurerm_log_analytics_workspace.funcy_log_analytics_workspace.id
  application_type    = "web"
}

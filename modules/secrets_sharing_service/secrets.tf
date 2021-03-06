resource "azurerm_resource_group" "rg" {
  name      = var.secrets_rg_name
  location  = var.secrets_location
}

resource "azurerm_management_lock" "rg_lock" {
  name  = var.secrets_rg_lock_name
  scope = azurerm_resource_group.rg.id
  lock_level = "ReadOnly"
  notes = "This lock prevents before accident removal the resource group or before manual changes in resource configuration."
}

resource "azurerm_app_service_plan" "secrets_asp" {
  name                  = var.secrets_asp_name
  location              = var.secrets_location
  resource_group_name   = var.secrets_rg_name

  kind = "Linux"
  reserved = true
  sku {
    tier = "Free"
    size = "F1"
  }

  depends_on = [
    azurerm_resource_group.rg
  ]
}

resource "azurerm_app_service" "secrets_as" {
  name                  = var.secrets_as_name
  location              = var.secrets_location
  resource_group_name   = var.secrets_rg_name
  app_service_plan_id   = azurerm_app_service_plan.secrets_asp.id
  https_only = true

  site_config {
    linux_fx_version = "DOCKER|privatebin/nginx-fpm-alpine"
    always_on = false
    use_32_bit_worker_process = true
  }
}
resource "azurerm_resource_group" "rg" {
  name      = var.secrets_rg_name
  location  = var.secrets_location
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
}

resource "azurerm_app_service" "secrets_as" {
  name                  = var.secrets_as_name
  location              = var.secrets_location
  resource_group_name   = var.secrets_rg_name
  app_service_plan_id   = azurerm_app_service_plan.secrets_asp.id

  site_config {
    linux_fx_version = "DOCKER|privatebin/nginx-fpm-alpine"
    always_on = false
    use_32_bit_worker_process = true
  }
}
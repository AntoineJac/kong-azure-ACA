provider "azurerm" {
  features {}
}

module "konnect-external-dp" {
  source = "./konnect-external-dp"

  resource_group_name                     = var.resource_group_name
  # container_app_environment_id            = var.container_app_environment_id
  container_app_environment_id  = azurerm_container_app_environment.main.id
  container_registry_login_server         = var.container_registry_login_server
  environment_name                        = var.environment_name

  konnect_external_cp_endpoint            = var.konnect_external_cp_endpoint
  konnect_external_telemetry_endpoint     = var.konnect_external_telemetry_endpoint
  konnect_external_tls_crt                = var.konnect_external_tls_crt
  konnect_external_tls_key                = var.konnect_external_tls_key

  kong_container_image_repo               = var.kong_container_image_repo
  kong_container_image_tag                = var.kong_container_image_tag
  kong_container_image_tag_traffic        = var.kong_container_image_tag_traffic
  kong_container_max_replicas             = var.kong_container_max_replicas
  kong_container_nginx_worker_processes   = var.kong_container_nginx_worker_processes
  kong_container_cpu                      = var.kong_container_cpu
  kong_container_memory                   = var.kong_container_memory

  depends_on = [azurerm_container_app_environment.main]
}

module "konnect-internal-dp" {
  source = "./konnect-internal-dp"

  resource_group_name                     = var.resource_group_name
  #container_app_environment_id            = var.container_app_environment_id
  container_app_environment_id  = azurerm_container_app_environment.main.id
  container_registry_login_server         = var.container_registry_login_server
  environment_name                        = var.environment_name

  konnect_internal_cp_endpoint            = var.konnect_internal_cp_endpoint
  konnect_internal_telemetry_endpoint     = var.konnect_internal_telemetry_endpoint
  konnect_internal_tls_crt                = var.konnect_internal_tls_crt
  konnect_internal_tls_key                = var.konnect_internal_tls_key

  kong_container_image_repo               = var.kong_container_image_repo
  kong_container_image_tag                = var.kong_container_image_tag
  kong_container_image_tag_traffic        = var.kong_container_image_tag_traffic
  kong_container_max_replicas             = var.kong_container_max_replicas
  kong_container_nginx_worker_processes   = var.kong_container_nginx_worker_processes
  kong_container_cpu                      = var.kong_container_cpu
  kong_container_memory                   = var.kong_container_memory

  depends_on = [azurerm_container_app_environment.main]
}

resource "azurerm_container_app_environment" "main" {
  name     = "konnect-environment"
  location = "francecentral"
  resource_group_name = var.resource_group_name

  # log_analytics_workspace_id      = azurerm_log_analytics_workspace.main.id
  # infrastructure_subnet_id        = data.azurerm_subnet.infrastructure.id
  # internal_load_balancer_enabled  = true
  # zone_redundancy_enabled         = true
  # depends_on = [azurerm_log_analytics_workspace.main]
}

# data "azurerm_subnet" "infrastructure" {
#   name                 = "XXXXX"
#   virtual_network_name = "XXXXX"
#   resource_group_name  = "XXXXX"
# }

# resource "azurerm_log_analytics_workspace" "main" {
#   name                = var.workspaceName
#   location            = var.workspaceLocation
#   resource_group_name = var.resourceGroup
#   retention_in_days   = 30
#   sku                 = "PerGB2018"
# }


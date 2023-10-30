output "aca-server-url" {
  value = azurerm_container_app.konnect-internal-dp.ingress[0].fqdn
}
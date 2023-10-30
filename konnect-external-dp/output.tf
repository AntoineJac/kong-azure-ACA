output "aca-server-url" {
  value = azurerm_container_app.konnect-external-dp.ingress[0].fqdn
}
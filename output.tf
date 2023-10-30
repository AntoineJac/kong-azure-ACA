output "konnect-external-dp-url" {
  value = module.konnect-external-dp.aca-server-url
  description = "Konnect external url"
}

output "konnect-internal-dp-url" {
 value = module.konnect-internal-dp.aca-server-url
 description = "Konnect internal url"
}

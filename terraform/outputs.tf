output "app_url" {
  description = "URL of the deployed web app"
  value       = "https://${azurerm_linux_web_app.app.default_hostname}"
}

output "staging_slot_url" {
  description = "URL of the staging deployment slot"
  value       = "https://${azurerm_linux_web_app_slot.recovery.default_hostname}"
}
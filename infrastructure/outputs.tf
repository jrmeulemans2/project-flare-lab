output "storage_account_name" {
  value = azurerm_storage_account.web.name
}

output "storage_primary_web_endpoint" {
  value = azurerm_storage_account.web.primary_web_endpoint
}

output "frontdoor_profile_id" {
  value = azurerm_cdn_frontdoor_profile.fd.id
}


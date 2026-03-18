locals {
  tags = merge(var.tags, {
    environment = var.environment
    region      = var.location
  })
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = local.tags
}

resource "azurerm_log_analytics_workspace" "law" {
  name                = var.log_analytics_workspace_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  sku               = var.log_analytics_sku
  retention_in_days = var.log_retention_in_days

  tags = local.tags
}

resource "azurerm_storage_account" "web" {
  name                = var.storage_account_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location

  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # Enterprise security posture (public data plane must be on for local Terraform blob uploads)
  enable_https_traffic_only       = true
  min_tls_version                 = "TLS1_2"
  public_network_access_enabled   = var.storage_public_network_access_enabled

  # Static website settings (files will be uploaded to $web)
  static_website {
    index_document     = "index.html"
    error_404_document = "index.html"
  }

  tags = local.tags
}

# The $web container is created automatically when static_website is enabled; do not create it
# explicitly (avoids 403 and conflicts with the static website feature).

# Sample landing page deployment (Terraform reads the local file at plan/apply time).
resource "azurerm_storage_blob" "index_html" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.web.name
  storage_container_name = "$web"
  type                   = "Block"
  source_content         = file("${path.module}/../site/index.html")
  # Without text/html, browsers download the page; Front Door may also serve odd behavior.
  content_type           = "text/html; charset=utf-8"
  cache_control          = "public, max-age=300"
}

#
# Azure Front Door (Premium recommended for WAF/private-link scenarios)
#
resource "azurerm_cdn_frontdoor_profile" "fd" {
  name                = var.frontdoor_profile_name
  resource_group_name = azurerm_resource_group.rg.name

  sku_name = "Standard_AzureFrontDoor"
}

resource "azurerm_cdn_frontdoor_endpoint" "fd_endpoint" {
  name                = var.frontdoor_endpoint_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd.id
}

resource "azurerm_cdn_frontdoor_origin_group" "origin_group" {
  name                = "flare-origin-group"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd.id

  session_affinity_enabled = false

  # Required by the provider schema.
  load_balancing {
    sample_size                 = 16
    successful_samples_required = 3
  }

  health_probe {
    interval_in_seconds = 60
    path                = "/"
    protocol            = "Https"
    request_type        = "GET"
  }
}

resource "azurerm_cdn_frontdoor_origin" "storage_origin" {
  name                          = "flare-storage-origin"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.origin_group.id

  # NOTE: For static website + public_network_access_enabled=false, you should
  # use Front Door Private Link to reach the Storage Private Endpoint.
  # This sample uses the storage static website endpoint host directly.
  # API requires hostname only (no scheme or path).
  host_name          = trim(trimprefix(azurerm_storage_account.web.primary_web_endpoint, "https://"), "/")
  origin_host_header = trim(trimprefix(azurerm_storage_account.web.primary_web_endpoint, "https://"), "/")
  http_port          = 80
  https_port         = 443

  # Required: azurerm 3.x can leave origin disabled without this; routes then fail with
  # "at least one enabled origin is created under the origin group".
  enabled  = true
  priority = 1
  weight   = 1000

  certificate_name_check_enabled = false
}

resource "azurerm_cdn_frontdoor_route" "route" {
  name                          = var.frontdoor_route_name
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.fd_endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.origin_group.id

  forwarding_protocol    = "HttpsOnly"
  patterns_to_match      = ["/*"]
  link_to_default_domain = true

  cdn_frontdoor_origin_ids = [azurerm_cdn_frontdoor_origin.storage_origin.id]
  supported_protocols      = ["Https"]
  https_redirect_enabled   = false
}

#
# Security: WAF policy (sample configuration)
#
# WAF policy. managed_rule is only supported with sku Premium_AzureFrontDoor; omitted for Standard.
resource "azurerm_cdn_frontdoor_firewall_policy" "waf" {
  name                 = var.frontdoor_waf_policy_name
  resource_group_name  = azurerm_resource_group.rg.name
  sku_name             = "Standard_AzureFrontDoor"

  mode = "Prevention"
}

#
# Observability: Diagnostic settings to Log Analytics
#
resource "azurerm_monitor_diagnostic_setting" "frontdoor_to_law" {
  name               = "fd-diagnostics-to-law"
  target_resource_id = azurerm_cdn_frontdoor_profile.fd.id

  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  # NOTE: Verify exact category names for Front Door in your provider version.
  enabled_log {
    category = "FrontDoorAccessLog"
  }
  enabled_log {
    category = "FrontDoorHealthProbeLog"
  }
}

# Storage diagnostics: log categories are supported on blob service, not the storage account resource.
resource "azurerm_monitor_diagnostic_setting" "storage_to_law" {
  name               = "storage-diagnostics-to-law"
  target_resource_id = "${azurerm_storage_account.web.id}/blobServices/default"

  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  enabled_log {
    category = "StorageRead"
  }
  enabled_log {
    category = "StorageWrite"
  }
  enabled_log {
    category = "StorageDelete"
  }
}


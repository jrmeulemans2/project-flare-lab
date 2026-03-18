variable "location" {
  description = "Azure region (East US2 per constitution)"
  type        = string
  default     = "eastus2"
}

variable "environment" {
  description = "Deployment environment name"
  type        = string
  default     = "production"
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
  default     = "rg-project-flare"
}

variable "tags" {
  description = "Tags applied to resources"
  type        = map(string)
  default = {
    project = "project-flare"
  }
}

variable "storage_account_name" {
  description = "Storage account name (must be globally unique in Azure)"
  type        = string
  default     = "stflareprodjrmeu2001"
}

variable "log_analytics_workspace_name" {
  description = "Log Analytics workspace name"
  type        = string
  default     = "law-flare-prod"
}

variable "log_analytics_sku" {
  description = "Log Analytics workspace SKU"
  type        = string
  default     = "PerGB2018"
}

variable "log_retention_in_days" {
  description = "Log retention in days"
  type        = number
  default     = 30
}

variable "frontdoor_profile_name" {
  description = "Azure Front Door profile name"
  type        = string
  default     = "cdn-flare-prod"
}

variable "frontdoor_endpoint_name" {
  description = "Azure Front Door endpoint name"
  type        = string
  default     = "flare-endpoint-001"
}

variable "frontdoor_route_name" {
  description = "Azure Front Door route name"
  type        = string
  default     = "flare-route"
}

variable "frontdoor_waf_policy_name" {
  description = "Azure Front Door WAF policy name"
  type        = string
  default     = "fdwafpolicyflare001"
}

variable "storage_public_network_access_enabled" {
  description = "Allow public network access to the storage data plane. Required for Terraform blob uploads from your machine unless you run apply from a network that can reach a private endpoint."
  type        = bool
  default     = true
}

variable "storage_private_endpoint_enabled" {
  description = "Whether to create a Private Endpoint for Storage (recommended when public_network_access_enabled is false)."
  type        = bool
  default     = false
}

variable "storage_private_endpoint_subnet_id" {
  description = "Subnet ID for the Storage Private Endpoint"
  type        = string
  default     = null
}


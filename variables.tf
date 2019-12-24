# AWS Provider Variables
variable "region_primary" {
  description = "AWS Region to deploy to"
}

variable "region_secondary" {
  description = "Secondary DR AWS Regio"
}

variable "name" {
  description = "Name of the account"
}

variable "role_name" {
  description = "AWS role name to assume"
}

# Account Variables
variable "account_id" {
  description = "The ID of the working account"
}

variable "account_type" {
  description = "The Account Type of working account"
  default     = "core"
}

variable "okta_provider_domain" {
  description = "The domain name of the IDP.  This is concatenated with the app name and should be in the format 'site.domain.tld' (no protocol or trailing /)."
}

variable "okta_app_id" {
  description = "The Okta app ID for SSO configuration."
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "tfe_host_name" {
  description = "host_name for ptfe"
}

variable "tfe_org_name" {
  description = "ptfe organization name"
}

variable "tfe_avm_workspace_name" {
  description = "Name of avm workspace"
}

variable "tfe_core_logging_workspace_name" {
  description = "Name of logging workspace"
}

variable "okta_token" {
  type = "string"
  description = "Okta API token (sensitive)"
}

variable "users_tlz_organization_admin" {
  type        = "list"
  description = "list of user emails to provide access to this role (via okta)"
}

variable "users_tlz_billing_admin" {
  description = "list of user emails to provide access to the billing admin role (via okta)"
  type        = "list"
}

resource "azurerm_resource_group" "primary" {
  name     = format("%s-rg-%s", local.org, local.resource_suffix)
  location = module.primary_region.location

  tags = local.tags
}

module "primary_region" {
  #checkov:skip=CKV_TF_1: TODO: external location download
  source  = "claranet/regions/azurerm"
  version = "8.0.2"

  azure_region = local.primary_location
}

resource "azurerm_key_vault" "main" {
  #checkov:skip=CKV_AZURE_109: TODO: consider firewall settings, route traffic via VNet
  #checkov:skip=CKV_AZURE_189: TODO: public network access enabled check
  #checkov:skip=CKV2_AZURE_32: TODO: private endpoint configuration
  name                        = format("%s-kv-%s", local.org, local.resource_suffix)
  location                    = module.primary_region.location
  resource_group_name         = azurerm_resource_group.primary.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = true
  enable_rbac_authorization   = true

  sku_name = "standard"

  tags = local.tags
}

# # secrets to be manually populated
resource "azurerm_key_vault_secret" "manual_secrets" {
  #checkov:skip=CKV_AZURE_41: expiration not valid
  for_each = toset(local.secrets)

  key_vault_id = azurerm_key_vault.main.id
  name         = each.value
  value        = "<terraform_placeholder>"
  content_type = "plaintext"

  tags = local.tags

  lifecycle {
    ignore_changes = [
      value
    ]
  }
}
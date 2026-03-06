data "azurerm_client_config" "current" {}

data "azurerm_container_registry" "acr" {
  name                = "pinscrsharedtoolinguks"
  resource_group_name = "pins-rg-shared-tooling-uks"

  provider = azurerm.tooling
}

data "azurerm_private_dns_zone" "keyvault" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = var.tooling_config.network_rg

  provider = azurerm.tooling
}

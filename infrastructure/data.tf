data "azurerm_client_config" "current" {}

data "azurerm_container_registry" "acr" {
  name                = "pinscrsharedtoolinguks"
  resource_group_name = "pins-rg-shared-tooling-uks"

  provider = azurerm.tooling
}
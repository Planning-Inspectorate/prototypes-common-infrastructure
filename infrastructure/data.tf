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

data "azurerm_machine_learning_workspace" "ml_workspace" {
  name                = var.rrtm.rbac.ml_workspace_name
  resource_group_name = var.rrtm.ml_workspace_rg
}

data "azurerm_storage_account" "ml_storage" {
  name                = var.rrtm.st_account.st_name
  resource_group_name = var.rrtm.st_account.resource_group_name
}

data "azurerm_virtual_network" "tooling" {
  name                = var.tooling_config.network_name
  resource_group_name = var.tooling_config.network_rg

  provider = azurerm.tooling
}

data "azurerm_private_dns_zone" "storage" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = var.tooling_config.network_rg

  provider = azurerm.tooling
}

data "azurerm_private_dns_zone" "app_service" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = var.tooling_config.network_rg

  provider = azurerm.tooling
}

data "azurerm_monitor_action_group" "common" {
  for_each = tomap(var.common_config.action_group_names)

  resource_group_name = var.common_config.resource_group_name
  name                = each.value
}

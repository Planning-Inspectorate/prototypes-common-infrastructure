resource "azurerm_private_dns_zone_virtual_network_link" "keyvault" {
  name                  = "${local.org}-vnetlink-keyvault-${local.resource_suffix}"
  resource_group_name   = var.tooling_config.network_rg
  private_dns_zone_name = data.azurerm_private_dns_zone.keyvault.name
  virtual_network_id    = azurerm_virtual_network.main.id

  provider = azurerm.tooling
}

resource "azurerm_service_plan" "apps" {
  #checkov:skip=CKV_AZURE_212: Ensure App Service has a minimum number of instances for failover
  #checkov:skip=CKV_AZURE_225: Ensure the App Service Plan is zone redundant
  #checkov:skip=CKV_AZURE_211: plan not suitable for production
  name                = "${local.org}-asp-${local.resource_suffix}"
  resource_group_name = azurerm_resource_group.primary.name
  location            = module.primary_region.location

  os_type  = "Linux"
  sku_name = "B1"

  tags = local.tags
}

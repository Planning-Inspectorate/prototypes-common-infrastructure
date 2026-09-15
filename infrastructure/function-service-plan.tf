resource "azurerm_service_plan" "functions" {
  #checkov:skip=CKV_AZURE_212: TODO: Ensure App Service has a minimum number of instances for failover
  #checkov:skip=CKV_AZURE_225: TODO: Ensure the App Service Plan is zone redundant
  name                = "${local.org}-asp-${local.service_name}-funcs-${var.environment}"
  resource_group_name = azurerm_resource_group.primary.name
  location            = module.primary_region.location

  os_type  = "Linux"
  sku_name = var.apps_config.functions_service_plan_sku

  tags = local.tags
}

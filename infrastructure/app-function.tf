resource "azurerm_linux_function_app" "function_app" {
  name                          = "pins-func-${local.service_name}-idas-python-${var.environment}"
  location                      = module.primary_region.location
  resource_group_name           = azurerm_resource_group.primary.name
  service_plan_id               = azurerm_service_plan.functions.id
  storage_account_name          = azurerm_storage_account.functions.name
  storage_account_access_key    = azurerm_storage_account.functions.primary_access_key
  https_only                    = true
  public_network_access_enabled = false

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME       = "python"
    SCM_DO_BUILD_DURING_DEPLOYMENT = "true"
    BUILD_FLAGS                    = "UseExpressBuild"
    ENABLE_ORYX_BUILD              = "true"
    ENABLE_PROFILING_ENDPOINT      = "1"
    GLICLASS_MODEL_REVISION        = "e065d1844f913a9aa611cf33623a9538b8aa8841"
    GLICLASS_THRESHOLD             = "0.1"
    MKL_NUM_THREADS                = "2"
    OMP_NUM_THREADS                = "2"
    TEXT_CHUNK_OVERLAP             = "256"
    TEXT_CHUNK_SIZE                = "2048"
    XDG_CACHE_HOME                 = "/tmp/.cache"
  }

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on     = true
    http2_enabled = true

    application_stack {
      python_version = var.function_python_version
    }

    application_insights_key = azurerm_application_insights.main.instrumentation_key
  }

  tags = local.tags

  virtual_network_subnet_id = azurerm_subnet.apps.id

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_storage_account" "functions" {
  #checkov:skip=CKV_AZURE_33: Logging not implemented yet
  #checkov:skip=CKV_AZURE_43: "Ensure Storage Accounts adhere to the naming rules"
  #checkov:skip=CKV_AZURE_206: "Ensure that Storage Accounts use replication"
  #checkov:skip=CKV2_AZURE_1: Customer Managed Keys not implemented yet
  #checkov:skip=CKV2_AZURE_8: Logging not implemented yet
  #checkov:skip=CKV2_AZURE_18: Customer Managed Keys not implemented yet
  #checkov:skip=CKV2_AZURE_38: "Ensure soft-delete is enabled on Azure storage account"
  #checkov:skip=CKV2_AZURE_40: "Ensure storage account is not configured with Shared Key authorization"
  #checkov:skip=CKV2_AZURE_41: "Ensure storage account is configured with SAS expiration policy"
  name                             = "pinsstfuncidas${var.environment}"
  resource_group_name              = azurerm_resource_group.primary.name
  location                         = module.primary_region.location
  account_tier                     = "Standard"
  account_replication_type         = "GRS"
  allow_nested_items_to_be_public  = false
  cross_tenant_replication_enabled = false
  https_traffic_only_enabled       = true
  min_tls_version                  = "TLS1_2"
  public_network_access_enabled    = false

  network_rules {
    default_action = "Deny"
    bypass         = ["AzureServices"]
  }

  tags = local.tags
}

resource "azurerm_private_endpoint" "function_app_pe" {
  name                = "${local.org}-pe-${local.service_name}-idas-python-${var.environment}"
  location            = module.primary_region.location
  resource_group_name = azurerm_resource_group.primary.name
  subnet_id           = azurerm_subnet.main.id

  private_dns_zone_group {
    name                 = "${local.org}-pdns-${local.service_name}-funcapp-python-${var.environment}"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.app_service.id]
  }

  private_service_connection {
    name                           = "${local.org}-psc-funcapp-python-${var.environment}"
    private_connection_resource_id = azurerm_linux_function_app.function_app.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  tags = local.tags
}

resource "azurerm_private_endpoint" "functions_storage" {
  name                = "${local.org}-pe-st-funcstorage-${local.resource_suffix}"
  location            = module.primary_region.location
  resource_group_name = azurerm_resource_group.primary.name
  subnet_id           = azurerm_subnet.main.id

  private_dns_zone_group {
    name                 = "${local.org}-pdns-${local.service_name}-funcstorage-${var.environment}"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.storage.id]
  }

  private_service_connection {
    name                           = "${local.org}-psc-funcstorage-${local.resource_suffix}"
    private_connection_resource_id = azurerm_storage_account.functions.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  tags = local.tags
}

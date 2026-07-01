
resource "azurerm_linux_web_app" "web_app_rrtm" {
  #checkov:skip=CKV_AZURE_17: Disabling FTP(S) to be tested
  #checkov:skip=CKV_AZURE_63: Azure App service HTTP logging is disabled
  #checkov:skip=CKV_AZURE_65: App service disables detailed error messages
  #checkov:skip=CKV_AZURE_66: App service does not enable failed request tracing
  #checkov:skip=CKV_AZURE_78: TLS mutual authentication may not be required
  #checkov:skip=CKV_AZURE_88: Azure Files mount may not be required
  #checkov:skip=CKV_AZURE_213: App Service health check may not be required
  #checkov:skip=CKV_AZURE_222: Ensure that Azure Web App public network access is disabled

  name                = "pins-app-relevant-reps-topic-modelling-dev"
  resource_group_name = azurerm_resource_group.primary.name
  location            = module.primary_region.location

  #Service plan
  service_plan_id = azurerm_service_plan.apps.id

  #Networking
  client_certificate_enabled    = false
  https_only                    = true
  public_network_access_enabled = true
  virtual_network_subnet_id     = azurerm_subnet.apps.id

  identity {
    type = "SystemAssigned"
  }

  #Authentication
  auth_settings_v2 {
    auth_enabled             = true
    require_authentication   = true
    default_provider         = "azureactivedirectory"
    runtime_version          = "~1"
    unauthenticated_action   = "RedirectToLoginPage" #default: RedirectToLoginPage other:Return403
    require_https            = true
    forward_proxy_convention = "Standard"
    active_directory_v2 {
      client_id                  = var.rrtm.auth_config.auth_client_id
      client_secret_setting_name = "MICROSOFT_PROVIDER_AUTHENTICATION_SECRET"
      tenant_auth_endpoint       = "https://login.microsoftonline.com/${data.azurerm_client_config.current.tenant_id}/v2.0"
      allowed_groups             = var.rrtm.auth_config.allowed_groups
      allowed_audiences = [
        "https://pins-app-relevant-reps-topic-modelling-dev.azurewebsites.net/.auth/login/aad/callback"
      ]
      allowed_applications = [
        var.rrtm.auth_config.allowed_applications
      ]
    }
    login {
      token_store_enabled            = true
      allowed_external_redirect_urls = []
    }
  }

  app_settings = {
    NODE_ENV                       = "production"
    PORT                           = 8050
    SCM_DO_BUILD_DURING_DEPLOYMENT = true

    #Auth
    MICROSOFT_PROVIDER_AUTHENTICATION_SECRET = local.key_vault_refs["relevant-reps-topic-modelling-auth-secret"]
    WEBSITE_AUTH_AAD_ALLOWED_TENANTS         = data.azurerm_client_config.current.tenant_id
    WEBSITE_AUTH_DISABLE_IDENTITY_FLOW       = "true"
  }

  site_config {
    always_on                               = true
    http2_enabled                           = true
    container_registry_use_managed_identity = true

    app_command_line = "python pipelines/norwich_tilbury/classifier/launch_dashboard.py"

    ip_restriction_default_action = "Allow"

    application_stack {
      python_version = "3.14"
    }
  }

  tags = local.tags

  lifecycle {
    ignore_changes = [
      # ignore any changes to "hidden-link" and other tags
      # see https://github.com/hashicorp/terraform-provider-azurerm/issues/16569
      tags
    ]
  }
}

## RBAC for secrets
resource "azurerm_role_assignment" "rrtm_secrets_user" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_linux_web_app.web_app_rrtm.identity[0].principal_id
}

#RBAC for storage account
resource "azurerm_role_assignment" "rrtm_storage_blob_data_reader" {
  scope                = "${data.azurerm_storage_account.ml_storage.id}/blobServices/default/containers/${var.rrtm.st_account.container_name}"
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azurerm_linux_web_app.web_app_rrtm.identity[0].principal_id
}
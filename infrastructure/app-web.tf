resource "azurerm_linux_web_app" "web_app" {
  #checkov:skip=CKV_AZURE_13: App Service authentication may not be required
  #checkov:skip=CKV_AZURE_17: Disabling FTP(S) to be tested
  #checkov:skip=CKV_AZURE_78: TLS mutual authentication may not be required
  #checkov:skip=CKV_AZURE_88: Azure Files mount may not be required
  #checkov:skip=CKV_AZURE_213: App Service health check may not be required
  #checkov:skip=CKV_AZURE_222: Ensure that Azure Web App public network access is disabled
  #checkov:skip=CKV_AZURE_63: Azure App service HTTP logging is disabled
  #checkov:skip=CKV_AZURE_65: App service disables detailed error messages
  #checkov:skip=CKV_AZURE_66: App service does not enable failed request tracing

  #Loops
  for_each = local.app_services
  name     = each.value["name"]


  app_settings = {
    NODE_ENV                            = "production"
    PASSWORD                            = each.value["password"]
    WEBSITE_RUN_FROM_PACKAGE            = 0
    PORT                                = 8080
    WEBSITES_CONTAINER_START_TIME_LIMIT = 600
  }

  resource_group_name = azurerm_resource_group.primary.name
  location            = module.primary_region.location

  #Service plan
  service_plan_id = azurerm_service_plan.apps.id

  #Networking
  client_certificate_enabled    = false
  https_only                    = true
  public_network_access_enabled = true

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on        = true
    http2_enabled    = true
    app_command_line = "npm ci && npm run start"

    application_stack {
      node_version = "20-lts"
    }

    ip_restriction_default_action = "Allow"
  }

  tags = local.tags

  lifecycle {
    ignore_changes = [
      # ignore any changes to the docker image, since the image tag changes per deployment
      # all other site_config and application_stack changes should be tracked
      # see state file to check structure: site_config and application_stack are arrays in state, with a single entry
      # ignore any changes to "hidden-link" and other tags
      # see https://github.com/hashicorp/terraform-provider-azurerm/issues/16569
      tags
    ]
  }
}

## RBAC for secrets
resource "azurerm_role_assignment" "app_web_secrets_user" {
  for_each             = local.app_services
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_linux_web_app.web_app[each.key].identity[0].principal_id
}

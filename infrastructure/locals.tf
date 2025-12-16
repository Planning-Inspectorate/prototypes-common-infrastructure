locals {
  org              = "pins"
  service_name     = "prototypes"
  primary_location = "uk-south"
  resource_suffix  = "${local.service_name}-${var.environment}"

  #App_services
  app_services = {
    appeals_front_office = {
      name       = "pins-app-prototype-appeals-front-office"
      password   = local.key_vault_refs["appeals-front-office"]
      image_name = "prototypes/applications-front-office"
    }

    appelas_back_office = {
      name       = "pins-app-prototype-appeals-back-office"
      password   = local.key_vault_refs["appeals-back-office"]
      image_name = "prototypes/appeals-back-office"
    }

    applications_front_office = {
      name       = "pins-app-prototype-applications-front-office"
      password   = local.key_vault_refs["applications-front-office"]
      image_name = "prototypes/applications-front-office"
    }

    applications_back_office = {
      name       = "pins-app-prototype-applications-back-office"
      password   = local.key_vault_refs["applications-back-office"]
      image_name = "prototypes/applications-back-office"
    }

    applications_dco_portal = {
      name       = "pins-app-prototype-applications-dco-portal"
      password   = local.key_vault_refs["applications-dco-portal"]
      image_name = "prototypes/applications-dco-portal"
    }

    crown_dev = {
      name       = "pins-app-prototype-crown-dev"
      password   = local.key_vault_refs["crown-dev"]
      image_name = "prototypes/crown-dev"
    }

    design_patterns = {
      name       = "pins-app-prototype-design-patterns"
      password   = local.key_vault_refs["design-patterns"]
      image_name = "prototypes/design-patterns"
    }
    local_plans = {
      name       = "pins-app-prototype-local-plans"
      password   = local.key_vault_refs["local-plans"]
      image_name = "prototypes/local-plans"
    }
  }

  secrets = [
    "appeals-front-office",
    "appeals-back-office",
    "applications-front-office",
    "applications-back-office",
    "applications-dco-portal",
    "crown-dev",
    "design-patterns",
    "local-plans",
  ]

  key_vault_refs = merge(
    {
      for k, v in azurerm_key_vault_secret.manual_secrets : k => "@Microsoft.KeyVault(SecretUri=${v.versionless_id})"
    },
  )

  tags = merge(
    var.tags,
    {
      CreatedBy   = "Terraform"
      Environment = var.environment
      location    = local.primary_location
      Owner       = "DevOps"
      ServiceName = local.service_name
    }
  )
}

# app_settings = {
#   PASSWORD                 = local.key_vault_refs["appeals-front-office"]
# }
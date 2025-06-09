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

    crown_dev = {
      name       = "pins-app-prototype-crown-dev"
      password   = local.key_vault_refs["crown-dev"]
      image_name = "prototypes/crown-dev"
    }
  }

  secrets = [
    "appeals-front-office",
    "appeals-back-office",
    "applications-front-office",
    "applications-back-office",
    "crown-dev",
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
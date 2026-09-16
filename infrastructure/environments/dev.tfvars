apps_config = {
  app_service_plan = {
    sku                      = "P0v3"
    per_site_scaling_enabled = false
    worker_count             = 1
    zone_balancing_enabled   = false
  }

  node_environment           = "development"
  private_endpoint_enabled   = true
  functions_node_version     = 22
  functions_service_plan_sku = "P0v3"
  auth = {
    client_id                = "1625a9b6-a214-4fea-a683-e17f7099e964" # idas reps poc - dev
    group_application_access = "ab2e4b5a-4807-4c81-8ce0-3eba310f7cc6" # idas reps poc - app access - dev 
    # groups = {
    #   inspectors    = ""
    #   team_leads    = ""
    #   national_team = ""
    #   api_inspector_groups = []
    # }
  }

  logging = {
    level = "info"
  }
}

common_config = {
  resource_group_name = "pins-rg-common-dev-ukw-001"
  action_group_names = {
    iap      = "pins-ag-odt-iap-dev"
    its      = "pins-ag-odt-its-dev"
    info_sec = "pins-ag-odt-info-sec-dev"
  }
}

environment = "dev"

monitoring_config = {
  app_insights_web_test_enabled = false
  log_daily_cap                 = 0.1
}

rrtm = {
  ml_workspace_rg = "pins-rg-azure-ml-dev"
  auth_config = {
    auth_client_id       = "caa25811-8b39-49e3-a4b0-d26ecc4bdb0d"
    allowed_applications = "e9638718-8b49-4a6a-a005-9d10664c34ea"
    allowed_groups = [
      "cd9e8a38-5b37-423f-9b0c-7122cea8d763"
    ]
  }
  st_account = {
    st_name             = "pinsstdsamldev"
    resource_group_name = "pins-rg-azure-ml-dev"
    container_name      = "azureml-blobstore-d0776d72-7d3d-4bb3-b5e1-b00d64cf10f6"
  }
  rbac = {
    ml_workspace_name = "pins-aml-workspace-ds-dev"
  }
}

vnet_config = {
  address_space             = "10.37.0.0/16"
  main_subnet_address_space = "10.37.1.0/24"
  apps_subnet_address_space = "10.37.0.0/24"
}

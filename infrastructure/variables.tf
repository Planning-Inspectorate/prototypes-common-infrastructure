variable "apps_config" {
  description = "Config for the apps"
  type = object({
    app_service_plan = object({
      sku                      = string
      per_site_scaling_enabled = bool
      worker_count             = number
      zone_balancing_enabled   = bool
    })

    functions_node_version     = number
    functions_service_plan_sku = string
    node_environment           = string
    private_endpoint_enabled   = bool
  })
}

variable "environment" {
  description = "The name of the environment in which resources will be deployed"
  type        = string
  default     = "dev"
}

variable "monitoring_config" {
  description = "Config for monitoring"
  type = object({
    app_insights_web_test_enabled = bool
    log_daily_cap                 = number
  })
}

variable "rrtm" {

  description = "Config for the auth settings of relevant-reps-topic-modelling"
  type = object({
    ml_workspace_rg = string
    auth_config = object({
      auth_client_id       = string
      allowed_applications = string
      allowed_groups       = list(string)
    })
    st_account = object({
      st_name             = string
      resource_group_name = string
      container_name      = string
    })
    rbac = object({
      ml_workspace_name = string
    })
  })
}

variable "tags" {
  description = "A collection of tags to assign to taggable resources"
  type        = map(string)
  default     = {}
}

variable "tooling_config" {
  description = "Config for the tooling subscription resources"
  type = object({
    network_name    = string
    network_rg      = string
    subscription_id = string
  })
}

variable "vnet_config" {
  description = "VNet configuration"
  type = object({
    address_space             = string
    main_subnet_address_space = string
    apps_subnet_address_space = string
  })
}

variable "function_python_version" {
  default     = "3.13"
  description = "Python version for the function app"
  type        = string
}

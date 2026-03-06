variable "environment" {
  description = "The name of the environment in which resources will be deployed"
  type        = string
  default     = "dev"
}

variable "tags" {
  description = "A collection of tags to assign to taggable resources"
  type        = map(string)
  default     = {}
}

variable "vnet_config" {
  description = "VNet configuration"
  type = object({
    address_space                       = string
    main_subnet_address_space           = string
  })
}

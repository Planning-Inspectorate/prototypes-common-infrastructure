environment = "dev"

rrtm = {
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
}

vnet_config = {
  address_space             = "10.37.0.0/16"
  main_subnet_address_space = "10.37.1.0/24"
  apps_subnet_address_space = "10.37.0.0/24"
}

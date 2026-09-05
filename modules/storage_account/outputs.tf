output "storage_accounts" {
  description = "Map of created Storage Accounts"
  value = {
    for k, v in azurerm_storage_account.sa : k => {
      id                        = v.id
      name                      = v.name
      primary_blob_endpoint     = v.primary_blob_endpoint
      primary_connection_string = v.primary_connection_string
    }
  }
  sensitive = true
}

output "containers" {
  description = "Map of created Storage Containers"
  value = {
    for k, v in azurerm_storage_container.container : k => {
      id   = v.id
      name = v.name
    }
  }
}

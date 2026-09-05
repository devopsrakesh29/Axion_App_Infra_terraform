output "registries" {
  description = "Map of created Azure Container Registries"
  value = {
    for k, v in azurerm_container_registry.acr : k => {
      id             = v.id
      name           = v.name
      login_server   = v.login_server
      admin_username = v.admin_username
    }
  }
}

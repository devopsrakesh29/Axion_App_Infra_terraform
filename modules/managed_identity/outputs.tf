output "managed_identities" {
  description = "Map of created User Assigned Managed Identities"
  value = {
    for k, v in azurerm_user_assigned_identity.identity : k => {
      id           = v.id
      name         = v.name
      principal_id = v.principal_id
      client_id    = v.client_id
    }
  }
}

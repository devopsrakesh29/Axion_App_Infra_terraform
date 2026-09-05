output "key_vaults" {
  description = "Map of created Key Vaults"
  value = {
    for k, v in azurerm_key_vault.kv : k => {
      id        = v.id
      name      = v.name
      vault_uri = v.vault_uri
    }
  }
}

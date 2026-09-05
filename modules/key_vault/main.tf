resource "azurerm_key_vault" "kv" {
  for_each = var.key_vaults

  name                       = each.value.name
  resource_group_name        = each.value.resource_group_name
  location                   = each.value.location
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = each.value.sku_name
  soft_delete_retention_days = each.value.soft_delete_retention_days
  purge_protection_enabled   = each.value.purge_protection_enabled
  enable_rbac_authorization  = each.value.enable_rbac_authorization
  tags                       = each.value.tags
}

locals {
  policy_list = flatten([
    for kv_key, kv_val in var.key_vaults : [
      for p_key, p_val in kv_val.access_policies : {
        kv_key                  = kv_key
        policy_key              = p_key
        object_id               = p_val.object_id
        tenant_id               = p_val.tenant_id
        key_permissions         = p_val.key_permissions
        secret_permissions      = p_val.secret_permissions
        certificate_permissions = p_val.certificate_permissions
      }
    ]
  ])
  policies_map = {
    for item in local.policy_list : "${item.kv_key}-${item.policy_key}" => item
  }
}

resource "azurerm_key_vault_access_policy" "policy" {
  for_each = local.policies_map

  key_vault_id            = azurerm_key_vault.kv[each.value.kv_key].id
  tenant_id               = each.value.tenant_id
  object_id               = each.value.object_id
  key_permissions         = each.value.key_permissions
  secret_permissions      = each.value.secret_permissions
  certificate_permissions = each.value.certificate_permissions
}

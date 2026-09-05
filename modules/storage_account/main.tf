resource "azurerm_storage_account" "sa" {
  for_each = var.storage_accounts

  name                          = each.value.name
  resource_group_name           = each.value.resource_group_name
  location                      = each.value.location
  account_tier                  = each.value.account_tier
  account_replication_type      = each.value.account_replication_type
  public_network_access_enabled = each.value.public_network_access_enabled
  tags                          = each.value.tags
}

locals {
  container_list = flatten([
    for sa_key, sa_val in var.storage_accounts : [
      for c_key, c_val in sa_val.containers : {
        sa_key                = sa_key
        container_name        = c_val.name
        container_access_type = c_val.container_access_type
      }
    ]
  ])
  containers_map = {
    for item in local.container_list : "${item.sa_key}-${item.container_name}" => item
  }
}

resource "azurerm_storage_container" "container" {
  for_each = local.containers_map

  name                  = each.value.container_name
  storage_account_name  = azurerm_storage_account.sa[each.value.sa_key].name
  container_access_type = each.value.container_access_type
}

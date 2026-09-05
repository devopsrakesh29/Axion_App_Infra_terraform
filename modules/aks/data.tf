data "azurerm_subnet" "aks_subnet" {
  for_each = var.clusters

  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.resource_group_name
}

data "azurerm_user_assigned_identity" "aks_identity" {
  for_each = var.clusters

  name                = each.value.user_assigned_identity_name
  resource_group_name = coalesce(each.value.identity_resource_group_name, each.value.resource_group_name)
}

data "azurerm_virtual_network" "vnet" {
  for_each = var.subnets

  name                = each.value.virtual_network_name
  resource_group_name = each.value.resource_group_name
}

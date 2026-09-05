output "vnets" {
  description = "Map of created Virtual Networks"
  value = {
    for k, v in azurerm_virtual_network.vnet : k => {
      id            = v.id
      name          = v.name
      address_space = v.address_space
    }
  }
}

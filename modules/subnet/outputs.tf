output "subnets" {
  description = "Map of created Subnets"
  value = {
    for k, v in azurerm_subnet.subnet : k => {
      id   = v.id
      name = v.name
    }
  }
}

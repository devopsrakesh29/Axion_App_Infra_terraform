variable "registries" {
  description = "Map of Public Azure Container Registries"
  type = map(object({
    name                          = string
    resource_group_name           = string
    location                      = string
    sku                           = optional(string, "Standard")
    admin_enabled                 = optional(bool, true)
    public_network_access_enabled = optional(bool, true)
    tags                          = optional(map(string), {})
  }))
  default = {}
}

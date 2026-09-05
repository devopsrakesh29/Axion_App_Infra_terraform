variable "managed_identities" {
  description = "Map of User Assigned Managed Identities"
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    tags                = optional(map(string), {})
  }))
  default = {}
}

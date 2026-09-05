variable "key_vaults" {
  description = "Map of Key Vaults and Access Policies"
  type = map(object({
    name                       = string
    resource_group_name        = string
    location                   = string
    sku_name                   = optional(string, "standard")
    soft_delete_retention_days = optional(number, 7)
    purge_protection_enabled   = optional(bool, false)
    enable_rbac_authorization  = optional(bool, false)
    access_policies = optional(map(object({
      object_id               = string
      tenant_id               = string
      key_permissions         = optional(list(string), [])
      secret_permissions      = optional(list(string), ["Get", "List", "Set", "Delete"])
      certificate_permissions = optional(list(string), [])
    })), {})
    tags = optional(map(string), {})
  }))
  default = {}
}

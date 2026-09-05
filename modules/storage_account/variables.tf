variable "storage_accounts" {
  description = "Map of Storage Accounts and Blob Containers"
  type = map(object({
    name                          = string
    resource_group_name           = string
    location                      = string
    account_tier                  = optional(string, "Standard")
    account_replication_type      = optional(string, "LRS")
    public_network_access_enabled = optional(bool, true)
    containers = optional(map(object({
      name                  = string
      container_access_type = optional(string, "private")
    })), {})
    tags = optional(map(string), {})
  }))
  default = {}
}

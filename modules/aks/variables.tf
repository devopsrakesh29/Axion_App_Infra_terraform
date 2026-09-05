variable "clusters" {
  description = "Map of AKS clusters to create"
  type = map(object({
    name                         = string
    resource_group_name          = string
    location                     = string
    dns_prefix                   = string
    subnet_name                  = string
    vnet_name                    = string
    user_assigned_identity_name  = string
    identity_resource_group_name = optional(string)
    kubernetes_version           = optional(string)

    api_server_access_profile = optional(object({
      authorized_ip_ranges = optional(set(string), [])
    }))

    key_vault_secrets_provider = optional(object({
      secret_rotation_enabled  = optional(bool, true)
      secret_rotation_interval = optional(string, "2m")
    }))

    default_node_pool = object({
      name            = string
      node_count      = optional(number, 1)
      vm_size         = string
      os_disk_size_gb = optional(number, 30)
      type            = optional(string, "VirtualMachineScaleSets")
    })

    user_node_pools = optional(map(object({
      name            = string
      vm_size         = string
      node_count      = optional(number, 1)
      os_disk_size_gb = optional(number, 30)
      mode            = optional(string, "User")
    })), {})

    network_profile = optional(object({
      network_plugin      = optional(string, "azure")
      network_plugin_mode = optional(string, "overlay")
      network_policy      = optional(string, "azure")
      pod_cidr            = optional(string, "10.244.0.0/16")
      service_cidr        = optional(string, "10.0.0.0/16")
      dns_service_ip      = optional(string, "10.0.0.10")
      load_balancer_sku   = optional(string, "standard")
    }))

    tags = optional(map(string), {})
  }))
  default = {}
}

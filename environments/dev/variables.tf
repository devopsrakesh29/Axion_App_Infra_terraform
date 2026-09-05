variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  default     = "b27f17ae-3823-4fb4-99e5-a1b53312cb1e"
}

variable "environment" {
  description = "Deployment Environment Name"
  type        = string
  default     = "dev"
}

variable "resource_groups" {
  description = "Map of Resource Groups to create"
  type = map(object({
    name     = string
    location = string
    tags     = optional(map(string), {})
  }))
  default = {}
}

variable "vnets" {
  description = "Map of Virtual Networks to create"
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    address_space       = list(string)
    dns_servers         = optional(list(string), [])
    tags                = optional(map(string), {})
  }))
  default = {}
}

variable "subnets" {
  description = "Map of Subnets to create"
  type = map(object({
    name                 = string
    resource_group_name  = string
    virtual_network_name = string
    address_prefixes     = list(string)
    service_endpoints    = optional(list(string), [])
    delegation = optional(object({
      name = string
      service_delegation = object({
        name    = string
        actions = optional(list(string), [])
      })
    }))
  }))
  default = {}
}

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

variable "storage_accounts" {
  description = "Map of Storage Accounts and Containers"
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

    ingress_application_gateway = optional(object({
      gateway_id   = optional(string)
      gateway_name = optional(string)
      subnet_id    = optional(string)
      subnet_cidr  = optional(string)
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

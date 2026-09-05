# ==============================================================================
# INT ENVIRONMENT TERRAFORM VARIABLES FILE
# ==============================================================================

subscription_id = "b27f17ae-3823-4fb4-99e5-a1b53312cb1e"
environment     = "int"

# ------------------------------------------------------------------------------
# 1. Resource Groups
# ------------------------------------------------------------------------------
resource_groups = {
  "rg1" = {
    name     = "rakesh-axion-int-rg-01"
    location = "centralindia"
    tags = {
      Environment = "int"
      Project     = "Axion"
    }
  }
}

# ------------------------------------------------------------------------------
# 2. Virtual Networks
# ------------------------------------------------------------------------------
vnets = {
  "vnet1" = {
    name                = "rakesh-axion-int-vnet-01"
    resource_group_name = "rakesh-axion-int-rg-01"
    location            = "centralindia"
    address_space       = ["10.1.0.0/16"]
    dns_servers         = []
    tags = {
      Environment = "int"
      Project     = "Axion"
    }
  }
}

# ------------------------------------------------------------------------------
# 3. Subnets
# ------------------------------------------------------------------------------
subnets = {
  "subnet1" = {
    name                 = "aks-axion-int-subnet-01"
    resource_group_name  = "rakesh-axion-int-rg-01"
    virtual_network_name = "rakesh-axion-int-vnet-01"
    address_prefixes     = ["10.1.1.0/24"]
    service_endpoints    = ["Microsoft.Storage", "Microsoft.KeyVault", "Microsoft.ContainerRegistry"]
    delegation           = null
  }
}

# ------------------------------------------------------------------------------
# 4. User Assigned Managed Identities
# ------------------------------------------------------------------------------
managed_identities = {
  "mi1" = {
    name                = "rakesh-axion-int-identity-01"
    resource_group_name = "rakesh-axion-int-rg-01"
    location            = "centralindia"
    tags = {
      Environment = "int"
      Project     = "Axion"
    }
  }
}

# ------------------------------------------------------------------------------
# 5. Storage Accounts & Blob Containers (Unique Random Numbers Added)
# ------------------------------------------------------------------------------
storage_accounts = {
  "sa1" = {
    name                          = "axionintsa739102"
    resource_group_name           = "rakesh-axion-int-rg-01"
    location                      = "centralindia"
    account_tier                  = "Standard"
    account_replication_type      = "LRS"
    public_network_access_enabled = true
    containers = {
      "c1" = {
        name                  = "tfstate-int"
        container_access_type = "private"
      }
    }
    tags = {
      Environment = "int"
      Project     = "Axion"
    }
  }
}

# ------------------------------------------------------------------------------
# 6. Azure Key Vault
# ------------------------------------------------------------------------------
key_vaults = {
  "kv1" = {
    name                       = "rakesh-axion-int-kv01"
    resource_group_name        = "rakesh-axion-int-rg-01"
    location                   = "centralindia"
    sku_name                   = "standard"
    soft_delete_retention_days = 7
    purge_protection_enabled   = false
    enable_rbac_authorization  = false
    access_policies            = {}
    tags = {
      Environment = "int"
      Project     = "Axion"
    }
  }
}

# ------------------------------------------------------------------------------
# 7. Public Azure Container Registry (ACR)
# ------------------------------------------------------------------------------
registries = {
  "acr1" = {
    name                          = "axionintacr01"
    resource_group_name           = "rakesh-axion-int-rg-01"
    location                      = "centralindia"
    sku                           = "Standard"
    admin_enabled                 = true
    public_network_access_enabled = true
    tags = {
      Environment = "int"
      Project     = "Axion"
    }
  }
}

# ------------------------------------------------------------------------------
# 8. Azure Kubernetes Service (AKS) - Standard_D2as_v5 & Greenfield AGIC
# ------------------------------------------------------------------------------
clusters = {
  "aks1" = {
    name                        = "rakesh-axion-int-aks-01"
    resource_group_name         = "rakesh-axion-int-rg-01"
    location                    = "centralindia"
    dns_prefix                  = "rakesh-axion-int-aks"
    subnet_name                 = "aks-axion-int-subnet-01"
    vnet_name                   = "rakesh-axion-int-vnet-01"
    user_assigned_identity_name = "rakesh-axion-int-identity-01"
    kubernetes_version          = "1.34"

    api_server_access_profile = {
      authorized_ip_ranges = ["122.161.50.13/32"]
    }

    ingress_application_gateway = {
      gateway_name = "rakesh-axion-int-appgw-01"
      subnet_cidr  = "10.1.2.0/24"
    }

    key_vault_secrets_provider = {
      secret_rotation_enabled  = true
      secret_rotation_interval = "2m"
    }

    default_node_pool = {
      name            = "systempool01"
      node_count      = 1
      vm_size         = "Standard_D2as_v5"
      os_disk_size_gb = 30
    }

    user_node_pools = {
      "userpool1" = {
        name            = "userpool01"
        vm_size         = "Standard_D2as_v5"
        node_count      = 1
        os_disk_size_gb = 30
        mode            = "User"
      }
    }

    network_profile = {
      network_plugin      = "azure"
      network_plugin_mode = "overlay"
      network_policy      = "azure"
      pod_cidr            = "100.65.0.0/16"
      service_cidr        = "172.17.0.0/16"
      dns_service_ip      = "172.17.0.10"
      load_balancer_sku   = "standard"
    }

    tags = {
      Environment = "int"
      Project     = "Axion"
    }
  }
}

resource "azurerm_kubernetes_cluster" "aks" {
  for_each = var.clusters

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  dns_prefix          = each.value.dns_prefix
  kubernetes_version  = each.value.kubernetes_version
  tags                = each.value.tags

  identity {
    type         = "UserAssigned"
    identity_ids = [data.azurerm_user_assigned_identity.aks_identity[each.key].id]
  }

  dynamic "api_server_access_profile" {
    for_each = each.value.api_server_access_profile != null ? [each.value.api_server_access_profile] : []
    content {
      authorized_ip_ranges = api_server_access_profile.value.authorized_ip_ranges
    }
  }

  default_node_pool {
    name            = each.value.default_node_pool.name
    node_count      = each.value.default_node_pool.node_count
    vm_size         = each.value.default_node_pool.vm_size
    os_disk_size_gb = each.value.default_node_pool.os_disk_size_gb
    vnet_subnet_id  = data.azurerm_subnet.aks_subnet[each.key].id
    type            = each.value.default_node_pool.type
  }

  dynamic "key_vault_secrets_provider" {
    for_each = each.value.key_vault_secrets_provider != null ? [each.value.key_vault_secrets_provider] : []
    content {
      secret_rotation_enabled  = key_vault_secrets_provider.value.secret_rotation_enabled
      secret_rotation_interval = key_vault_secrets_provider.value.secret_rotation_interval
    }
  }

  dynamic "network_profile" {
    for_each = each.value.network_profile != null ? [each.value.network_profile] : []
    content {
      network_plugin      = network_profile.value.network_plugin
      network_plugin_mode = network_profile.value.network_plugin_mode
      network_policy      = network_profile.value.network_policy
      pod_cidr            = network_profile.value.pod_cidr
      service_cidr        = network_profile.value.service_cidr
      dns_service_ip      = network_profile.value.dns_service_ip
      load_balancer_sku   = network_profile.value.load_balancer_sku
    }
  }
}

locals {
  user_node_pool_list = flatten([
    for cluster_key, cluster_val in var.clusters : [
      for pool_key, pool_val in cluster_val.user_node_pools : {
        cluster_key     = cluster_key
        pool_name       = pool_val.name
        vm_size         = pool_val.vm_size
        node_count      = pool_val.node_count
        os_disk_size_gb = pool_val.os_disk_size_gb
        mode            = pool_val.mode
      }
    ]
  ])
  user_node_pools_map = {
    for item in local.user_node_pool_list : "${item.cluster_key}-${item.pool_name}" => item
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "user_pool" {
  for_each = local.user_node_pools_map

  name                  = each.value.pool_name
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks[each.value.cluster_key].id
  vm_size               = each.value.vm_size
  node_count            = each.value.node_count
  os_disk_size_gb       = each.value.os_disk_size_gb
  vnet_subnet_id        = data.azurerm_subnet.aks_subnet[each.value.cluster_key].id
  mode                  = each.value.mode
}

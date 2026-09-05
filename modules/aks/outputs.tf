output "clusters" {
  description = "Map of created AKS clusters"
  value = {
    for k, v in azurerm_kubernetes_cluster.aks : k => {
      id                  = v.id
      name                = v.name
      kube_config_raw     = v.kube_config_raw
      oidc_issuer_url     = v.oidc_issuer_url
      identity_principal_id = try(v.identity[0].principal_id, null)
    }
  }
  sensitive = true
}

output "user_node_pools" {
  description = "Map of created User Node Pools"
  value = {
    for k, v in azurerm_kubernetes_cluster_node_pool.user_pool : k => {
      id   = v.id
      name = v.name
    }
  }
}

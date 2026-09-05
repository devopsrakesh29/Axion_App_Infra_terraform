output "resource_groups" {
  description = "Created Resource Groups"
  value       = module.resource_group.resource_groups
}

output "vnets" {
  description = "Created Virtual Networks"
  value       = module.vnet.vnets
}

output "subnets" {
  description = "Created Subnets"
  value       = module.subnet.subnets
}

output "managed_identities" {
  description = "Created User Assigned Managed Identities"
  value       = module.managed_identity.managed_identities
}

output "storage_accounts" {
  description = "Created Storage Accounts"
  value       = module.storage_account.storage_accounts
  sensitive   = true
}

output "key_vaults" {
  description = "Created Key Vaults"
  value       = module.key_vault.key_vaults
}

output "registries" {
  description = "Created Public Azure Container Registries"
  value       = module.acr.registries
}

output "clusters" {
  description = "Created Azure Kubernetes Service (AKS) Clusters"
  value       = module.aks.clusters
  sensitive   = true
}

module "resource_group" {
  source          = "../../modules/resource_group"
  resource_groups = var.resource_groups
}

module "vnet" {
  source     = "../../modules/vnet"
  vnets      = var.vnets
  depends_on = [module.resource_group]
}

module "subnet" {
  source     = "../../modules/subnet"
  subnets    = var.subnets
  depends_on = [module.vnet]
}

module "managed_identity" {
  source             = "../../modules/managed_identity"
  managed_identities = var.managed_identities
  depends_on         = [module.resource_group]
}

module "storage_account" {
  source           = "../../modules/storage_account"
  storage_accounts = var.storage_accounts
  depends_on       = [module.resource_group]
}

module "key_vault" {
  source     = "../../modules/key_vault"
  key_vaults = var.key_vaults
  depends_on = [module.resource_group]
}

module "acr" {
  source     = "../../modules/acr"
  registries = var.registries
  depends_on = [module.resource_group]
}

module "aks" {
  source     = "../../modules/aks"
  clusters   = var.clusters
  depends_on = [module.resource_group, module.vnet, module.subnet, module.managed_identity]
}

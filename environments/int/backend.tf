terraform {
  backend "azurerm" {
    resource_group_name  = "rakesh-tfstate-rg"
    storage_account_name = "tfstateaxioninfrasa"
    container_name       = "tfstate-int"
    key                  = "int.terraform.tfstate"
    subscription_id      = "b27f17ae-3823-4fb4-99e5-a1b53312cb1e"
  }
}

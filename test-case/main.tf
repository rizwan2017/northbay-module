module "aks_acr" {
  source              = "../"
  resource_group_name = "northbay-resouce-group"
  location            = "East US"
  aks_name            = "northbay-aks-cluster"
  dns_prefix          = "northbay-aks-dns"
  acr_name            = "northbayacr"
  agent_pool_vm_size  = "Standard_DS2_v2"
} 
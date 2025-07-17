

locals {
  node_pools = {
    worker1 = {
      zone         = "1"
      subnet_index = 0
      node_count   = 1
    }
  }
}

resource "azurerm_resource_group" "aks_rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = local.default_tags
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = var.dns_prefix
  tags                = local.default_tags

  default_node_pool {
    name                        = "systempool"
    node_count                  = 1
    vm_size                     = var.agent_pool_vm_size
    vnet_subnet_id              = azurerm_subnet.private_subnets[0].id
    temporary_name_for_rotation = "tempnp01"
    orchestrator_version        = null
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    service_cidr   = "10.240.0.0/16"
    dns_service_ip = "10.240.0.10"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "zonal_pools" {
  for_each              = local.node_pools
  name                  = each.key
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = var.agent_pool_vm_size
  node_count            = each.value.node_count
  vnet_subnet_id        = azurerm_subnet.private_subnets[each.value.subnet_index].id
  orchestrator_version  = null
  mode                  = "User"
  tags                  = local.default_tags
}

resource "azurerm_container_registry" "acr" {
  name                          = var.acr_name
  resource_group_name           = azurerm_resource_group.aks_rg.name
  location                      = azurerm_resource_group.aks_rg.location
  sku                           = "Basic"
  admin_enabled                 = true
  public_network_access_enabled = true
  tags                          = local.default_tags
} 
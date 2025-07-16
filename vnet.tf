resource "azurerm_virtual_network" "vnet" {
  name                = "aks-vnet"
  address_space       = ["10.0.0.0/8"]
  location            = var.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  tags                = local.default_tags
}

# PUBLIC SUBNETS (one per AZ)
resource "azurerm_subnet" "public_subnets" {
  count                = 3
  name                 = "public-subnet-${count.index + 1}"
  resource_group_name  = azurerm_resource_group.aks_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.${count.index}.0/24"]
}

# PRIVATE SUBNETS (for AKS)
resource "azurerm_subnet" "private_subnets" {
  count                = 3
  name                 = "private-subnet-${count.index + 1}"
  resource_group_name  = azurerm_resource_group.aks_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.${count.index + 10}.0/24"]
}

# NSG for Private Subnets
resource "azurerm_network_security_group" "private_nsg" {
  name                = "aks-private-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  tags                = local.default_tags
}

# Attach NSG to private subnets
resource "azurerm_subnet_network_security_group_association" "private_assoc" {
  count = 3
  subnet_id = azurerm_subnet.private_subnets[count.index].id
  network_security_group_id = azurerm_network_security_group.private_nsg.id
}
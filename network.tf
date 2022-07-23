resource "azurerm_virtual_network" "ResVnet" {
  name                = var.vnet_name
  location            = azurerm_resource_group.ResGroup.location
  resource_group_name = azurerm_resource_group.ResGroup.name
  address_space       = var.address_vnet
  tags                = merge(var.tags, { treinamento = "terraform" }, )
}
resource "azurerm_subnet" "ResSubnetSub01" {
  name                 = var.subnet_name_SUB01
  resource_group_name  = azurerm_resource_group.ResGroup.name
  virtual_network_name = azurerm_virtual_network.ResVnet.name
  address_prefixes     = var.address_prefix_subnet_SUB01
}

resource "azurerm_subnet" "ResSubnetSub02" {
  name                 = var.subnet_name_SUB02
  resource_group_name  = azurerm_resource_group.ResGroup.name
  virtual_network_name = azurerm_virtual_network.ResVnet.name
  address_prefixes     = var.address_prefix_subnet_SUB02
}
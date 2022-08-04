resource "azurerm_resource_group" "ResGroup" {
  name     = local.resource_group
  location = local.location
  tags = merge(var.tags, {
    Lab = "${local.prefix-lab}-RG"
  }, )
}
#Network
resource "azurerm_virtual_network" "ResVnet" {
  name                = var.vnet_name
  location            = azurerm_resource_group.ResGroup.location
  resource_group_name = azurerm_resource_group.ResGroup.name
  address_space       = var.address_vnet
  depends_on = [
    azurerm_resource_group.ResGroup
  ]
  tags = {
    Lab = "${local.prefix-lab}-VNET"
  }
}
resource "azurerm_subnet" "ResSubnets" {
  count                = length(var.subnet_names)
  name                 = var.subnet_names[count.index]
  resource_group_name  = azurerm_resource_group.ResGroup.name
  virtual_network_name = azurerm_virtual_network.ResVnet.name
  address_prefixes     = [var.address_prefix_subnets[count.index]]
  depends_on = [
    azurerm_virtual_network.ResVnet
  ]
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "ResNGS" {
  name                = var.nsg_name
  location            = azurerm_resource_group.ResGroup.location
  resource_group_name = azurerm_resource_group.ResGroup.name

  security_rule {
    name                         = "Port_80"
    priority                     = 100
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_range       = "80"
    source_address_prefix        = "*"
    destination_address_prefixes = azurerm_network_interface.nic-web.*.private_ip_address

  }
  tags = {
    Lab = "${local.prefix-lab}-NSG"
  }
}

resource "azurerm_subnet_network_security_group_association" "ResNSG" {
  count                     = "2"
  subnet_id                 = azurerm_subnet.ResSubnets[count.index].id
  network_security_group_id = azurerm_network_security_group.ResNGS.id
}
resource "azurerm_availability_set" "avset" {
  name                         = "avset"
  location                     = azurerm_resource_group.ResGroup.location
  resource_group_name          = azurerm_resource_group.ResGroup.name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true
}

resource "azurerm_network_interface" "nic-web" {
  count               = "2"
  name                = "NIC-VM-WEB0${count.index + 1}"
  location            = azurerm_resource_group.ResGroup.location
  resource_group_name = azurerm_resource_group.ResGroup.name

  ip_configuration {
    name                          = "nic-ipconfig-${count.index + 1}"
    subnet_id                     = azurerm_subnet.ResSubnets[count.index].id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_windows_virtual_machine" "vm-web" {
  count               = "2"
  name                = "VM-WEB0${count.index + 1}"
  location            = azurerm_resource_group.ResGroup.location
  resource_group_name = azurerm_resource_group.ResGroup.name
  availability_set_id = azurerm_availability_set.avset.id
  size                = var.vmsize_web
  admin_username      = var.admin_login
  admin_password      = var.admin_password
  tags = {
    Lab = "${local.prefix-lab}-VM"
  }
  network_interface_ids = [element(azurerm_network_interface.nic-web.*.id, count.index)]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}



resource "azurerm_virtual_machine_extension" "vm_extension_install_iis" {
  count                      = "2"
  name                       = "vm_extension_install_iis"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm-web[count.index].id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.8"
  auto_upgrade_minor_version = true
  settings                   = <<SETTINGS
    {      
      "commandToExecute": "powershell -encodedCommand ${textencodebase64(file("script.ps1"), "UTF-16LE")}"
    }
SETTINGS

}

resource "azurerm_public_ip" "ResPIPAPPGW" {
  # (resource arguments)
  name                = var.pip_appgw_az104
  resource_group_name = azurerm_resource_group.ResGroup.name
  location            = azurerm_resource_group.ResGroup.location
  allocation_method   = "Static"
  sku                 = "Standard"
  sku_tier            = "Regional"

}

resource "azurerm_subnet" "ResSubnetAPPGWs" {
  name                 = var.subnet_name_appgw
  resource_group_name  = azurerm_resource_group.ResGroup.name
  virtual_network_name = azurerm_virtual_network.ResVnet.name
  address_prefixes     = var.address_prefix_subnet_appgw
}
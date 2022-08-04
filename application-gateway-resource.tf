resource "azurerm_application_gateway" "resappgw" {
  # (resource arguments)
  resource_group_name = azurerm_resource_group.ResGroup.name
  location            = azurerm_resource_group.ResGroup.location
  name = local.applicationGatewayName
  tags = merge(var.tags, {
    Lab = "${local.prefix-lab}-APPGW"
  }, )

    sku {
    name     = local.sku_name
    tier     = local.sku_tier
    capacity = 2
  }

  gateway_ip_configuration {
    name = "appGatewayIpConfig"
    subnet_id = local.subnet_id
  } 

  frontend_port {    
    name = "port_80"
    port = "80"
  }

  frontend_ip_configuration {
    name = "appGwPublicFrontendIp"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.ResPIPAPPGW.id
    
  }

  backend_address_pool {
    name = "Pool-tfteconline"
  }
  
  backend_address_pool {  
    name = "Pool-tftecrs"
  }
       
  backend_http_settings {
    cookie_based_affinity = "Disabled"
    name = "http-stg-tftecrs"
    pick_host_name_from_backend_address = false
    port = 80
    protocol = "Http"
    request_timeout = 20
 }
  backend_http_settings {
    cookie_based_affinity = "Disabled"
    name = "http-stgtfteconline.com"
    pick_host_name_from_backend_address = false
    port = 80
    protocol = "Http"
    request_timeout = 20
   
 }
  http_listener {
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name = "port_80"
    host_name = "www.tftecrs.com"
    name = "lst-tftecrs"
    protocol = "Http"
              }
  http_listener {
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name = "port_80"
    host_name = "www.tfteconline.com"
    name = "lst-tfteconline"
    protocol = "Http"
}

  request_routing_rule {
    name = "Rule01-tfteconline"        
    rule_type = "Basic"
    http_listener_name = "lst-tfteconline"
    backend_address_pool_name = "Pool-tfteconline"
    backend_http_settings_name = "http-stgtfteconline.com"
    priority = 1
  }
  request_routing_rule {
    name = "Rule01-tftecrs"
    rule_type = "Basic"
    http_listener_name = "lst-tftecrs"
    backend_address_pool_name = "Pool-tftecrs"
    backend_http_settings_name = "http-stg-tftecrs"
    priority = 2
  }

}
resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "nic-assoc01" {
  count = "1"
  network_interface_id    = azurerm_network_interface.nic-web[count.index].id
  ip_configuration_name   = "nic-ipconfig-${count.index+1}"
  backend_address_pool_id = tolist(azurerm_application_gateway.resappgw.backend_address_pool).0.id  
}
resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "nic-assoc02" {
  count = "1"
  network_interface_id    = azurerm_network_interface.nic-web[count.index+1].id
  ip_configuration_name   = "nic-ipconfig-${count.index+2}"
  backend_address_pool_id = tolist(azurerm_application_gateway.resappgw.backend_address_pool).1.id  
}

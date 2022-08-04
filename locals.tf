locals {
  prefix-lab             = "appgw"
  prefix                 = "appgw"
  resource_group         = "RG-AZ-104"
  location               = "brazilsouth"
  applicationGatewayName = "APPGW"
  publicIpAddressName    = "PIP-APPGW"
  sku_name               = "Standard_v2" #Sku with WAF is : WAF_v2
  sku_tier               = "Standard_v2"
  subnet_id                      = azurerm_subnet.ResSubnetAPPGWs.id
  network_interface_id = azurerm_application_gateway.resappgw.backend_address_pool
  backend_address_pool_name1     = "Pool-tfteconline"
  backend_address_pool_name2     = "Pool-tftecrs"
  frontend_port_name             = "port_80"
  frontend_ip_configuration_name = "appGwPublicFrontendIp"
  listener_name                  = "${azurerm_virtual_network.ResVnet.name}-httplstn"
  redirect_configuration_name    = "${azurerm_virtual_network.ResVnet.name}-rdrcfg"
  gateway_ip_configuration_name  = "appGatewayIpConfig"
  http_setting_name1             = "http-stg-tfteconline.com"
  http_setting_name2             = "http-stg-tftecrs"
  rule_type                      = "Basic"

}

output "vnet_name" {
  value = var.vnet_name
}

output "rg_name" {
  value = var.rg_name
}

output "network_interface_private_ip" {
  value       = azurerm_network_interface.nic-web.*.private_ip_address
  description = "The private IP address of the main server instance."
  sensitive   = false

  depends_on = [
    azurerm_network_security_group.ResNGS
  ]
}

output "public_ip_address" {
  value       = azurerm_public_ip.ResPIPAPPGW.ip_address
  description = "The public IP address of the main load balancer."
  sensitive   = false
}

output "appgw_backend_address_pool_ids" {
  description = "List of backend address pool Ids."
  value       = azurerm_application_gateway.resappgw.backend_address_pool.*.id
}
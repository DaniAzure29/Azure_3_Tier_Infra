output "subnet_ids" {
  value = { for k, s in azurerm_subnet.subnet : k => s.id }
  description = "Map of subnet IDs keyed by subnet name"
}

output "public_ip_id" {
  value       = azurerm_public_ip.public_ip.id
  description = "The ID of the Public IP Address associated with the Application Gateway"
}

output "vnet_id" {
  value       = azurerm_virtual_network.vnet.id
  description = "The ID of the Virtual Network"
}

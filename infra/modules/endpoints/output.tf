output "dns_zone_id" {
    value = { for k, s in azurerm_private_dns_zone.azurerm_private_dns_zone.private_dns : k => s.id }
  description = "Map of DNS zone IDs keyed by DNS zone name"
}
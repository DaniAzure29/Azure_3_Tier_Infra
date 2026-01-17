resource "azurerm_private_endpoint" "endpoint" {
  for_each = var.private_endpoints

  name                = "${var.private_endpoints[each.key]}-pe"
  location            = var.rgrp_location
  resource_group_name = var.rgrp_name
  subnet_id           = var.private_endpoints[each.key].subnet_id

  private_service_connection {
    name                           = "${var.private_endpoints[each.key]}-psc"
    private_connection_resource_id = var.private_endpoints[each.key].private_resource_id
    subresource_names              = [var.private_endpoints[each.key].subresource_name]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "${var.private_endpoints[each.key]}-pdzg"
    private_dns_zone_ids = [var.private_endpoints[each.key].private_dns_zone_id]
  }
}

resource "azurerm_private_dns_zone" "private_dns" {
 for_each = var.private_endpoints
  name                = "privatelink.${var.private_endpoints[each.key]}.windows.net"
  resource_group_name = var.rgrp_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "link" {
  for_each = var.private_endpoints
  name                  = "${var.private_endpoints[each.key]}-link"
  resource_group_name   = var.rgrp_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns[each.key].name
  virtual_network_id    = var.private_endpoints[each.key].vnet_id
}
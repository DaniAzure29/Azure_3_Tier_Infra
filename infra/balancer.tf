resource "azurerm_public_ip" "balancer_ip" {
  name                = "balancer_ip"
  location            = azurerm_resource_group.projectgrp.location
  resource_group_name = azurerm_resource_group.projectgrp.name
  allocation_method   = "Static"
  sku = "Standard"
}

resource "azurerm_lb" "balancer" {
  for_each = var.load_balancer_config
  name                = each.value.name
  location            = azurerm_resource_group.projectgrp.location
  resource_group_name = azurerm_resource_group.projectgrp.name
  sku = each.value.sku

  frontend_ip_configuration {
    name                 = "${each.value.name}-ip"
    public_ip_address_id = each.value.is_public ? azurerm_public_ip.balancer_ip.id : null
    subnet_id = each.value.is_public ? null : azurerm_subnet.infra_subnets[each.value.subnet_id].id
  }
}

resource "azurerm_lb_backend_address_pool" "vm_pool" {
  for_each = var.load_balancer_config
  loadbalancer_id = azurerm_lb.balancer[each.value.name].id
  name            = "${each.value.name}-pool"
}

resource "azurerm_lb_rule" "example" {
  for_each = var.load_balancer_config
  loadbalancer_id                = azurerm_lb.balancer[each.value.name].id
  name                           = "${each.value.name}-rule"
  protocol                       = each.value.rules.protocol
  frontend_port                  = each.value.rules.frontend_port
  backend_port                   = each.value.rules.backend_port
  frontend_ip_configuration_name = "${each.value.name}-ip"
}

resource "azurerm_lb_probe" "probes" {
  for_each = var.load_balancer_config
  loadbalancer_id = azurerm_lb.balancer[each.value.name].id
  name            = "${each.value.name}-probe"
  protocol        = each.value.health_probe.protocol
  request_path    = each.value.health_probe.request_path
  port            = each.value.health_probe.port
}


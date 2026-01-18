output "gateway_pool_id" {
  value = azurerm_application_gateway.gateway.backend_address_pool.id
}
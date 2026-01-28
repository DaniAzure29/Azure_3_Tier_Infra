
resource "azurerm_application_gateway" "gateway" {
  name                = var.gateway_config.name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name = var.gateway_config.sku.name
    tier = var.gateway_config.sku.tier  
    capacity = var.gateway_config.sku.capacity
  }

  gateway_ip_configuration {
    name      = "${var.gateway_config.name}-ipconfig"
    subnet_id = var.subnet_id
  }

  frontend_port {
    name = "${var.gateway_config.name}-frontend-port"
    port = var.gateway_config.frontend_port
  }

  frontend_ip_configuration {
    name                 = "${var.gateway_config.name}-frontend-ip"
    public_ip_address_id = var.public_ip_address_id
  }

  backend_address_pool {
    name = var.gateway_config.backend_address_pool.name
  }

  backend_http_settings {
    name                  = "${var.gateway_config.name}-http-setting"
    cookie_based_affinity = var.gateway_config.backend_http_settings.cookie_based_affinity
    path                  = var.gateway_config.backend_http_settings.path
    port                  = var.gateway_config.backend_http_settings.port
    protocol              = var.gateway_config.backend_http_settings.protocol
    request_timeout       = var.gateway_config.backend_http_settings.request_timeout
    trusted_root_certificate_names = ["application-cert"]
  }

  trusted_root_certificate {
    name = "application-cert"
    data = var.gateway_config.trusted_root_certificate_data
  }

  http_listener {
    name                           = "${var.gateway_config.name}-listener"
    frontend_ip_configuration_name = "${var.gateway_config.name}-frontend-ip"
    frontend_port_name             = "${var.gateway_config.name}-frontend-port"
    protocol                       = var.gateway_config.http_listener.protocol
  }

  request_routing_rule {
    name                       = "${var.gateway_config.name}-routing-rule"
    priority                   = var.gateway_config.request_routing_rule.priority
    rule_type                  = var.gateway_config.request_routing_rule.rule_type
    http_listener_name         = "${var.gateway_config.name}-listener"
    backend_address_pool_name  = "${var.gateway_config.name}-backend-pool"
    backend_http_settings_name = "${var.gateway_config.name}-http-setting"
  }
  identity {
    type = "SystemAssigned"
  }

  enable_http2 = true
  firewall_policy_id = azurerm_web_application_firewall_policy.gateway-waf.id
}

resource "azurerm_web_application_firewall_policy" "gateway-waf" {
  name                = "gateway-wafpolicy"
  resource_group_name = var.resource_group_name
  location            = var.location

  policy_settings {
    enabled            = true
    mode               = "Prevention"
    request_body_check = true
  }

  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = "3.2"
    }
  }
}



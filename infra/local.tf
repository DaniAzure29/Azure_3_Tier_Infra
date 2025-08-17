locals {
  subnet_rules = flatten([
    for subnet_key, subnet in var.subnet_nsg_config : [
      for rule in subnet.nsg_rules : {
        key      = "${subnet_key}-${rule.name}"
        nsg_name = subnet.nsg_name
        rule     = rule
      }
    ]
  ])
}
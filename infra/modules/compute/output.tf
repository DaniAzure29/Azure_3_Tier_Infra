output "linux_vm_principal_id" {
  value = azurerm_linux_virtual_machine.linux_vm.identity[0].principal_id
  description = "The principal ID of the Linux VM's system assigned identity"
}
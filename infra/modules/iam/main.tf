resource "azurerm_role_assignment" "storage_reader_assignment" {
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.linux_vm_principal_id
  scope                = var.storage_account_id
}
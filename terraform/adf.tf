resource "azurerm_data_factory" "retail" {
  name                = "adf-retail-dp-lab2-2026"
  location            = azurerm_resource_group.retail.location
  resource_group_name = azurerm_resource_group.retail.name

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

resource "azurerm_role_assignment" "adf_storage" {
  scope                = azurerm_storage_account.retail.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_data_factory.retail.identity[0].principal_id
}

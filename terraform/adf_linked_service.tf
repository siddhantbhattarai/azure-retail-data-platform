resource "azurerm_data_factory_linked_service_data_lake_storage_gen2" "adls" {
  name            = "LS_ADLS_Gen2"
  data_factory_id = azurerm_data_factory.retail.id
  url             = azurerm_storage_account.retail.primary_dfs_endpoint

  use_managed_identity = true
}

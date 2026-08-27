resource "azurerm_storage_account" "retail" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.retail.name
  location                 = azurerm_resource_group.retail.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  is_hns_enabled = true

  min_tls_version = "TLS1_2"

  tags = var.tags
}

resource "azurerm_storage_data_lake_gen2_filesystem" "bronze" {
  name               = "bronze"
  storage_account_id = azurerm_storage_account.retail.id
}

resource "azurerm_storage_data_lake_gen2_filesystem" "silver" {
  name               = "silver"
  storage_account_id = azurerm_storage_account.retail.id
}

resource "azurerm_storage_data_lake_gen2_filesystem" "gold" {
  name               = "gold"
  storage_account_id = azurerm_storage_account.retail.id
}

resource "azurerm_storage_data_lake_gen2_filesystem" "landing" {
  name               = "landing"
  storage_account_id = azurerm_storage_account.retail.id
}

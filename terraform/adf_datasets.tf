resource "azurerm_data_factory_dataset_delimited_text" "adls_csv" {
  name                = "DS_ADLS_CSV"
  data_factory_id     = azurerm_data_factory.retail.id
  linked_service_name = azurerm_data_factory_linked_service_data_lake_storage_gen2.adls.name

  folder = "Common"

  parameters = {
    fileSystem = "string"
    folderPath = "string"
    fileName   = "string"
  }

  azure_blob_fs_location {
    file_system                 = "@dataset().fileSystem"
    dynamic_file_system_enabled = true

    path                 = "@dataset().folderPath"
    dynamic_path_enabled = true

    filename                 = "@dataset().fileName"
    dynamic_filename_enabled = true
  }

  column_delimiter    = ","
  row_delimiter       = "\n"
  first_row_as_header = true
  encoding            = "UTF-8"
}

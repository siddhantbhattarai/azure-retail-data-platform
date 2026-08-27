resource "azurerm_data_factory_pipeline" "bronze_ingestion" {
  name            = "PL_Bronze_Ingestion"
  data_factory_id = azurerm_data_factory.retail.id

  parameters = {
    sourceFileSystem      = "string"
    sourceFolder          = "string"
    sourceFile            = "string"
    destinationFolder     = "string"
    destinationFileSystem = "string"
  }

  activities_json = jsonencode([
    {
      name = "Copy_To_Bronze"
      type = "Copy"

      inputs = [
        {
          referenceName = "DS_ADLS_CSV"
          type          = "DatasetReference"

          parameters = {
            fileSystem = "@pipeline().parameters.sourceFileSystem"
            folderPath = "@pipeline().parameters.sourceFolder"
            fileName   = "@pipeline().parameters.sourceFile"
          }
        }
      ]

      outputs = [
        {
          referenceName = "DS_ADLS_CSV"
          type          = "DatasetReference"

          parameters = {
            fileSystem = "@pipeline().parameters.destinationFileSystem"
            folderPath = "@pipeline().parameters.destinationFolder"
            fileName   = "@pipeline().parameters.sourceFile"
          }
        }
      ]

      typeProperties = {
        source = {
          type = "DelimitedTextSource"
        }

        sink = {
          type = "DelimitedTextSink"
        }
      }
    }
  ])
}

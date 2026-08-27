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

resource "azurerm_data_factory_pipeline" "bronze_ingestion_all" {
  name            = "PL_Bronze_Ingestion_All"
  data_factory_id = azurerm_data_factory.retail.id

  activities_json = jsonencode([
    {
      name = "Get_Landing_Files"
      type = "GetMetadata"

      typeProperties = {
        dataset = {
          referenceName = "DS_ADLS_CSV"
          type          = "DatasetReference"

          parameters = {
            fileSystem = "landing"
            folderPath = "sales"
            fileName   = ""
          }
        }

        fieldList = [
          "childItems"
        ]
      }
    },

    {
      name = "ForEach_File"
      type = "ForEach"

      dependsOn = [
        {
          activity = "Get_Landing_Files"
          dependencyConditions = [
            "Succeeded"
          ]
        }
      ]

      typeProperties = {
        items = {
          type  = "Expression"
          value = "@activity('Get_Landing_Files').output.childItems"
        }

        activities = [
          {
            name = "Copy_File_To_Bronze"
            type = "ExecutePipeline"

            typeProperties = {
              pipeline = {
                referenceName = "PL_Bronze_Ingestion"
                type          = "PipelineReference"
              }

              waitOnCompletion = true

              parameters = {
                sourceFileSystem      = "landing"
                sourceFolder          = "sales"
                sourceFile            = "@item().name"
                destinationFileSystem = "bronze"
                destinationFolder     = "sales"
              }
            }
          }
        ]
      }
    }
  ])
}

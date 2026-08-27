# ETL DEMO PROJECT
Azure DATA Factory and Azure Databricks Examples

Local Generated CSV
        │
        │ Azure CLI upload
        ▼
┌──────────────────────┐
│ ADLS Gen2             │
│ landing/sales/        │
│                      │
│ 13 CSV files         │
└──────────┬───────────┘
           │
           │ ADF
           ▼
┌──────────────────────┐
│ PL_Bronze_Ingestion_All
│                      │
│ Get_Landing_Files    │
│        │             │
│        ▼             │
│ ForEach_File         │
│        │             │
│        ▼             │
│ PL_Bronze_Ingestion  │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│ ADLS Gen2             │
│ bronze/sales/         │
│                      │
│ 13 CSV files         │
└──────────────────────┘



SOURCE DATA
    │
    ▼
Local CSV generation
    │
    ▼
ADLS Gen2 LANDING
    │
    │ 13 CSV files
    ▼
ADF PL_Bronze_Ingestion_All
    │
    ├── Get_Landing_Files
    │
    ├── ForEach_File
    │
    └── PL_Bronze_Ingestion
    │
    ▼
ADLS Gen2 BRONZE
    │
    │ 13 CSV files
    ▼
READY FOR SILVER

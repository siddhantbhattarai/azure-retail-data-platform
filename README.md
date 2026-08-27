# Azure Retail Data Platform

A cloud-based retail data engineering project built on **Microsoft Azure** using Terraform, Azure Data Factory, and ADLS Gen2.

## Architecture

```text
Source CSV
   ↓
ADLS Gen2 — Landing
   ↓
Azure Data Factory
   ↓
ADLS Gen2 — Bronze
   ↓
Databricks — Silver
   ↓
Databricks / SQL — Gold
   ↓
Analytics & Reporting
```

## Current Progress

* Generated 1,000 retail transactions.
* Created customer, product, store, and sales datasets.
* Provisioned Azure infrastructure using **Terraform**.
* Created ADLS Gen2 containers:

  * `landing`
  * `bronze`
  * `silver`
  * `gold`
* Configured ADF Managed Identity and RBAC.
* Implemented `PL_Bronze_Ingestion` for individual files.
* Implemented `PL_Bronze_Ingestion_All` for automated multi-file ingestion.
* Successfully ingested **13 CSV files** from Landing to Bronze.

## Technologies

* Azure Data Lake Storage Gen2
* Azure Data Factory
* Azure Databricks
* Terraform
* Azure CLI
* Python
* CSV
* Git/GitHub

## Project Structure

```text
azure-retail-data-platform/
├── adf/
├── databricks/
├── data/
├── docs/
├── sql/
├── terraform/
├── generate-source-data.py
├── product-distribution.py
└── README.md
```

## Status

**Landing → Bronze: Completed ✅**


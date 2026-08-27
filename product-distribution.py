import pandas as pd

file = "data/source/retail/retail_sales_dataset.csv"

df = pd.read_csv(file)

print("\n===== CUSTOMERS =====")
print(df[[
    "Customer ID",
    "Gender",
    "Age"
]].head(20).to_string(index=False))

print("\n===== PRODUCTS =====")
print(df[[
    "Product Category",
    "Price per Unit"
]].drop_duplicates().sort_values(
    ["Product Category", "Price per Unit"]
).to_string(index=False))

print("\n===== TRANSACTIONS BY DATE =====")
print(
    df.groupby("Date")
      .size()
      .head(20)
      .to_string()
)

print("\n===== TOTAL REVENUE =====")
print(df["Total Amount"].sum())

print("\n===== TOTAL QUANTITY =====")
print(df["Quantity"].sum())

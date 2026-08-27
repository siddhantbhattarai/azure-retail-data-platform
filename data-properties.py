import pandas as pd

file = "data/source/retail/retail_sales_dataset.csv"

df = pd.read_csv(file)

print("\n===== SHAPE =====")
print(df.shape)

print("\n===== COLUMNS =====")
print(df.columns.tolist())

print("\n===== DATA TYPES =====")
print(df.dtypes)

print("\n===== NULL VALUES =====")
print(df.isnull().sum())

print("\n===== DUPLICATES =====")
print(df.duplicated().sum())

print("\n===== UNIQUE CUSTOMERS =====")
print(df["Customer ID"].nunique())

print("\n===== PRODUCT CATEGORIES =====")
print(df["Product Category"].value_counts())

print("\n===== GENDER =====")
print(df["Gender"].value_counts())

print("\n===== DATE RANGE =====")
print(df["Date"].min(), "→", df["Date"].max())

print("\n===== NUMERIC SUMMARY =====")
print(df[["Age", "Quantity", "Price per Unit", "Total Amount"]].describe())


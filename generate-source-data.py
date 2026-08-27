import pandas as pd
from pathlib import Path

# ============================================================
# Configuration
# ============================================================

SOURCE_FILE = Path("data/source/retail/retail_sales_dataset.csv")

OUTPUT_BASE = Path("data/generated")

CUSTOMER_DIR = OUTPUT_BASE / "customers"
PRODUCT_DIR = OUTPUT_BASE / "products"
STORE_DIR = OUTPUT_BASE / "stores"
SALES_DIR = OUTPUT_BASE / "sales"


# ============================================================
# Create directories
# ============================================================

for directory in [
    CUSTOMER_DIR,
    PRODUCT_DIR,
    STORE_DIR,
    SALES_DIR,
]:
    directory.mkdir(parents=True, exist_ok=True)


# ============================================================
# Read original dataset
# ============================================================

df = pd.read_csv(SOURCE_FILE)

print(f"Loaded {len(df)} transactions")


# ============================================================
# Customers
# ============================================================

customers = (
    df[
        [
            "Customer ID",
            "Gender",
            "Age",
        ]
    ]
    .drop_duplicates(subset=["Customer ID"])
    .rename(
        columns={
            "Customer ID": "customer_id",
            "Gender": "gender",
            "Age": "age",
        }
    )
    .sort_values("customer_id")
)

customers.to_csv(
    CUSTOMER_DIR / "customers.csv",
    index=False,
)

print(f"Created {len(customers)} customers")


# ============================================================
# Products
# ============================================================

product_prices = (
    df[
        [
            "Product Category",
            "Price per Unit",
        ]
    ]
    .drop_duplicates()
    .sort_values(
        [
            "Product Category",
            "Price per Unit",
        ]
    )
    .reset_index(drop=True)
)

product_prices["product_id"] = [
    f"PROD{i:03d}"
    for i in range(1, len(product_prices) + 1)
]

product_prices["product_name"] = (
    product_prices["Product Category"]
    + " Product "
    + product_prices.groupby("Product Category").cumcount().add(1).astype(str)
)

products = product_prices[
    [
        "product_id",
        "product_name",
        "Product Category",
        "Price per Unit",
    ]
].rename(
    columns={
        "Product Category": "category",
        "Price per Unit": "price_per_unit",
    }
)

products.to_csv(
    PRODUCT_DIR / "products.csv",
    index=False,
)

print(f"Created {len(products)} products")


# ============================================================
# Stores
# ============================================================

stores = pd.DataFrame(
    [
        {
            "store_id": "STORE001",
            "store_name": "Kathmandu Central",
            "city": "Kathmandu",
            "country": "Nepal",
            "region": "Bagmati",
        },
        {
            "store_id": "STORE002",
            "store_name": "Pokhara Lakeside",
            "city": "Pokhara",
            "country": "Nepal",
            "region": "Gandaki",
        },
        {
            "store_id": "STORE003",
            "store_name": "Biratnagar Main",
            "city": "Biratnagar",
            "country": "Nepal",
            "region": "Koshi",
        },
        {
            "store_id": "STORE004",
            "store_name": "Lalitpur Center",
            "city": "Lalitpur",
            "country": "Nepal",
            "region": "Bagmati",
        },
        {
            "store_id": "STORE005",
            "store_name": "Bharatpur Mall",
            "city": "Bharatpur",
            "country": "Nepal",
            "region": "Bagmati",
        },
    ]
)

stores.to_csv(
    STORE_DIR / "stores.csv",
    index=False,
)

print(f"Created {len(stores)} stores")


# ============================================================
# Sales
# ============================================================

sales = df.copy()

sales["Date"] = pd.to_datetime(sales["Date"])

# Deterministically assign stores
sales["store_id"] = (
    sales["Transaction ID"] % len(stores)
).map(
    lambda x: f"STORE{x + 1:03d}"
)

# Deterministically assign products
product_lookup = products[
    [
        "product_id",
        "category",
        "price_per_unit",
    ]
]

sales = sales.merge(
    product_lookup,
    left_on=[
        "Product Category",
        "Price per Unit",
    ],
    right_on=[
        "category",
        "price_per_unit",
    ],
    how="left",
)

sales = sales[
    [
        "Transaction ID",
        "Date",
        "Customer ID",
        "product_id",
        "store_id",
        "Quantity",
        "Price per Unit",
        "Total Amount",
    ]
].rename(
    columns={
        "Transaction ID": "transaction_id",
        "Date": "transaction_date",
        "Customer ID": "customer_id",
        "Quantity": "quantity",
        "Price per Unit": "price_per_unit",
        "Total Amount": "total_amount",
    }
)

# Split sales by month
sales["year_month"] = sales["transaction_date"].dt.strftime("%Y_%m")

for year_month, monthly_sales in sales.groupby("year_month"):
    output_file = SALES_DIR / f"sales_{year_month}.csv"

    monthly_sales.drop(
        columns=["year_month"]
    ).to_csv(
        output_file,
        index=False,
    )

    print(
        f"Created {output_file} "
        f"({len(monthly_sales)} records)"
    )


print("\nSource data generation completed successfully.")

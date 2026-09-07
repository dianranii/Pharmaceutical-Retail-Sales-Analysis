# Pharmaceutical-Retail-Sales-Analysis
Pharmaceutical retail sales analysis using SQL and Power BI to evaluate sales performance, customer transactions, product performance, and inventory.

# Pharmaceutical Retail Sales & Branch Performance Analysis

## Project Overview

This project analyzes pharmaceutical retail transaction, branch, product, and inventory data to evaluate business performance and identify key patterns that can support data-driven decision making.

The analysis covers pharmaceutical retail transactions from **2020 to 2023** and focuses on four main areas:

- Sales Performance
- Branch Performance
- Product Performance
- Inventory

The project uses **Excel** for initial data preparation, **MySQL** for data validation and SQL-based business analysis, and **Power BI** for data visualization and executive dashboard development.

The final output is an interactive Power BI dashboard supported by SQL analysis and business recommendations.

## Business Objective

The objective of this project is to understand pharmaceutical retail business performance by analyzing sales trends, branch performance, product contribution, and inventory records.

The analysis aims to:

- Evaluate revenue and transaction performance over time
- Identify differences in branch performance
- Examine the relationship between branch rating and revenue
- Identify high-contributing products and product categories
- Evaluate inventory distribution and zero-stock records
- Translate analytical findings into actionable business recommendations

---

## Business Questions

The analysis was designed to answer the following business questions:

1. How does sales performance develop over time?
2. Which branches or locations generate the highest and lowest revenue?
3. Is there a meaningful relationship between branch rating and revenue?
4. Which products and product categories contribute the most revenue?
5. How is inventory distributed, and how frequently do zero-stock records occur?

---

## Dataset

The project uses four main datasets:

| Table | Description | Records |
|---|---|---:|
| `transaction` | Pharmaceutical retail transaction records | 672,458 |
| `product` | Product master data | 150 |
| `cabang` | Branch master data | 1,725 |
| `inventory` | Inventory records by branch and product | 1,035,000 |

### Transaction Period

The transaction dataset covers:

**1 January 2020 – 30 December 2023**

### Main Fields

#### Transaction

- `transaction_id`
- `date`
- `branch_id`
- `customer_name`
- `product_id`
- `price`
- `discount_percentage`
- `rating`

#### Product

- `product_id`
- `product_name`
- `product_category`
- `price`

#### Branch

- `branch_id`
- `branch_category`
- `branch_name`
- `kota`
- `provinsi`
- `rating`

#### Inventory

- `Inventory_ID`
- `branch_id`
- `product_id`
- `product_name`
- `opname_stock`

---

## Tools & Technologies

| Tool | Purpose |
|---|---|
| **Excel** | Data cleaning and preparation |
| **MySQL** | Database management, validation, and SQL analysis |
| **Power BI** | Data visualization and executive dashboard |

---

## Data Preparation & Cleaning

Before importing the data into MySQL, the datasets were prepared and checked for structural consistency.

The data preparation process included:

- Checking column structures
- Standardizing date formats
- Checking numeric data types
- Removing unnecessary trailing empty columns
- Ensuring consistent CSV delimiters
- Preparing the datasets for MySQL import

The transaction data originally contained additional empty columns, which were removed before the final import.

---

## Data Validation

Data validation was performed after importing the datasets into MySQL.

The validation process included:

- Row count validation
- Duplicate record checks
- NULL value checks
- Primary key uniqueness checks
- Foreign key relationship checks
- Table grain validation
- Relationship validation
- Potential JOIN duplication checks

### Validation Results

No NULL values were found across the four main tables.

The key identifiers were also validated for uniqueness according to their respective table structures.

### Table Grain

`transaction` 1 row = 1 transaction for 1 product at 1 branch on 1 date |
`product` 1 row = 1 product |
`cabang` 1 row = 1 branch |
`inventory`  1 row = 1 inventory record for a product at a branch |

### Inventory Join Consideration

The inventory table contains multiple records for the same `branch_id` and `product_id` combination.

Therefore, directly joining transaction data with inventory at row level could create duplicate transaction records and inflate revenue calculations.

For this reason, the transaction table was treated as the primary sales fact table, while inventory was analyzed separately.


## 📘 GOLD LAYER – DATA DICTIONARY
### Overview
The Gold Layer is the business-level data representation, structured to support analytical and reporting use cases.
It consists of **dimension tables** and **fact tables** for specefic business meterics.

---

### 1️⃣ gold.dim_customers
**Purpose:** Stores customers details, enriched with demographic and geographic data.
**Columns:**
| Column Name     | Data Type | Description                                             | Example      |
| --------------- | --------- | ------------------------------------------------------- | ------------ |
| customer_key    | INTEGER   | Surrogate key generated in Gold layer for each customer | `101`        |
| customer_id     | INTEGER   | Unique customer ID from CRM system                      | `24567`      |
| customer_number | VARCHAR   | Business customer number used across systems            | `CUST_1023`  |
| first_name      | VARCHAR   | Customer first name                                     | `Jeevan`     |
| last_name       | VARCHAR   | Customer last name                                      | `Kumar`      |
| country         | VARCHAR   | Customer country derived from ERP location              | `India`      |
| material_status | VARCHAR   | Marital status of customer (standardized)               | `Married`    |
| gender          | VARCHAR   | Final gender derived from CRM and ERP                   | `Male`       |
| birthdate       | DATE      | Customer date of birth                                  | `1996-04-12` |
| create_date     | DATE      | Customer record creation date                           | `2023-08-15` |

---

### 2️⃣ gold.dim_products
**Purpose:** Provides information about the products and their attributes.
**Columns:**
| Column Name    | Data Type | Description                              | Example             |
| -------------- | --------- | ---------------------------------------- | ------------------- |
| product_key    | INTEGER   | Surrogate key generated for each product | `501`               |
| product_id     | INTEGER   | Product ID from CRM source               | `3101`              |
| product_number | VARCHAR   | Business product key                     | `BK-M68`            |
| product_nam    | VARCHAR   | Product name                             | `Mountain Bike Pro` |
| category_id    | VARCHAR   | Product category ID                      | `BK_M`              |
| category       | VARCHAR   | Product category name                    | `Bikes`             |
| subcategory    | VARCHAR   | Product subcategory                      | `Mountain Bikes`    |
| maintenance    | VARCHAR   | Maintenance indicator for product        | `Yes`               |
| cost           | NUMERIC   | Product cost                             | `1200.50`           |
| product_line   | VARCHAR   | Product line classification              | `Mountain`          |
| start_date     | DATE      | Product effective start date             | `2024-01-01`        |

---

### 3️⃣ gold.fact_sales
**Purpose:** Stores transactional data for analytical purposes.
**Columns:**
| Column Name   | Data Type | Description                           | Example      |
| ------------- | --------- | ------------------------------------- | ------------ |
| order_number  | INTEGER   | Unique sales order number             | `90001234`   |
| product_key   | INTEGER   | Foreign key referencing dim_products  | `501`        |
| customer_key  | INTEGER   | Foreign key referencing dim_customers | `101`        |
| order_date    | DATE      | Date when order was placed            | `2024-02-10` |
| shipping_date | DATE      | Date when order was shipped           | `2024-02-12` |
| due_date      | DATE      | Expected delivery date                | `2024-02-15` |
| sales_amount  | NUMERIC   | Total sales amount (quantity × price) | `2401.00`    |
| quantity      | INTEGER   | Number of units sold                  | `2`          |
| price         | NUMERIC   | Price per unit                        | `1200.50`    |

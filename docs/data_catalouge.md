## 📘 GOLD LAYER – DATA DICTIONARY
### Overview
The Gold Layer is the business-level data representation, structured to support analytical and reporting use cases.
It consists of **dimension tables** and **fact tables** for specefic business meterics.

---
#1️⃣ gold.dim_customers
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


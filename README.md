# Data Warehouse and Analytics Project

Welcome to the **Data Warehouse and Analytics Project** repository! 🚀
This project demonstrates a comprehensive data warehousing and analytics solution, from building a data ware house to generating actionable insights.Designed as protfolio project
highlights industry best practies in data engineering and analytics.


---


## 📋 Project Requirments

### Building tha Data Wareshouse (Data Engineering)

### Objective
Develop a modren data warehouse using SQL Server to consolidate sales data, analytical reporting and informed decision-making.

### Specifications
- **Data Source** : Import data form two source systems (ERP and CRM) provided as CSV files.
- **Data Quality** : Cleanse and resolve data quality issues prior to analysis.
- **Integration** : COmbine both sources into single, user-friendly data model designe for analytical queries.
- **Scope** : Focus on the latest only historization of data is not required.
- **Documentation** : Provide cler documentation of the data model to support both business stakeholders and analytics teams.


---


### 🧱 Project Overview
This project involves:
  1. **Data Architecture**: Designing a Modren Data Warehouse Using Architucture **Bronze,Silver,and Gold**
    Layer.
  2. **ETL Pipeline**: Extracting transforming and loading data from source systems into the warehouse.
  3. **Data Modeling**: Developing fact and dimension tables opyimized for analytical queries.
  4. **Analytics & Reporting**: Creating SQL-based reports and dashboards for actions insights.

 🎯This project showcases expertise.
-   SQL Development
-   Data Architect
-   Data Engineering
-   ETL Pipeling Developer
-   Data Modeling
-   Data Analytics


---


# 🏗️ Data Architecture

This data Architecture for this project follows Medallion Architecture **Bronze**,**Silver**,and **Gold** Layers

<img width="848" height="501" alt="Draw Architecture" src="https://github.com/user-attachments/assets/895e27f4-e635-49d6-a2be-4799ec35def2" />

1. **Bronze Layer**: Stores raw data as-in from source systems. Data in ingested from CSV files into SQL Server Database.
2. **Silver Layer**: This Layer includes data cleansing, standarzation and normalization processes to data for analysis.
3. **Gold Layer**: Houses business-ready data modeled into a star schema required for reporting and analytics.


---


## 📁 Repository Structure
The repository is organized by data layers (Bronze, Silver, Gold) 
to reflect a scalable and maintainable data warehouse architecture.

data-warehouse-project/
│
├── datasets/
│   ├── source_crm/
│   │   ├── cust_info.csv
│   │   ├── prd_info.csv
│   │   └── sales_details.csv
│   │
│   ├── source_erp/
│   │   ├── cust_az12.csv
│   │   ├── loc_a101.csv
│   │   └── px_cat_g1v2.csv
│   │
│   └── placeholder/
│
├── docs/
│   ├── data_architecture.md
│   ├── data_catalogue.md
│   ├── data_flow_diagram.md
│   ├── integration_model.md
│   └── placeholder/
│
├── scripts/
│   ├── init_database.sql
│   │
│   ├── bronze/
│   │   └── ddl_bronze.sql
│   │
│   ├── silver/
│   │   ├── ddl_silver.sql
│   │   ├── proc_load_silver.sql
│   │   └── quality_check_silver.sql
│   │
│   ├── gold/
│   │   ├── ddl_gold.sql
│   │   └── quality_check_gold.sql
│   │
│   └── placeholder/
│
├── tests/
│   └── placeholder/
│
├── LICENSE
└── README.md


---


## ⚖️ License

This project is licensed under the [MIT License].(LICENSE). You are free to use, modify, and share this project with proper attribution.


---


## 👨‍💻 About Me

Hi there! I'm **Jeevan Y D** SQL Developer & Data Analyst
Linked IN - https://www.linkedin.com/in/-jeevanyd/





















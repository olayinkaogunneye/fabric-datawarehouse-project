# Beginner‑Friendly Data Warehouse in Microsoft Fabric

*A step‑by‑step, metadata‑driven ETL project using Fabric Lakehouse, Warehouse SQL, and Pipelines.*

---

## 📌 Project Overview

This project is a small, end‑to‑end data warehouse built in **Microsoft Fabric**, designed to demonstrate the fundamentals of analytics engineering:

- ingesting raw data  
- cleaning and staging  
- building a dimensional model  
- automating ETL with metadata  
- orchestrating everything with Fabric Pipelines  

It’s intentionally simple, beginner‑friendly, and easy to reproduce — perfect for anyone learning Fabric or exploring modern data engineering patterns.

---

## 📂 Architecture

The warehouse follows a classic layered design:

```text
Raw → Staging → Dimension → Fact → Power BI
```

Raw: initial ingestion of CSV data

Staging: cleaned and standardized data

Dimension: business entities (e.g., customers)

Fact: sales transactions

Power BI: optional reporting layer

🧱 Data Model
The project uses a simple star schema:

DimCustomer

FactSales (linked by CustomerKey)

This keeps the model easy to understand while still demonstrating dimensional modeling concepts.

⚙️ Metadata‑Driven ETL
The ETL is controlled by a small metadata table called LoadControl, which defines:

which steps should run

in what order

whether they are active

This allows the pipeline to loop through ETL steps dynamically instead of hard‑coding each stored procedure.

### Example seed:

```sql
    INSERT INTO metadata.LoadControl (StepName, IsActive, StepOrder)
VALUES
    ('Clean_StgSales', 1, 1),
    ('Load_DimCustomer', 1, 2),
    ('Load_FactSales', 1, 3);
```
## 🚀 Pipeline Automation
A Fabric Pipeline orchestrates the ETL:

runs the ETL wrapper stored procedure

follows the LoadControl order

logs success/failure

can be scheduled or triggered manually

📸 Suggested screenshots:

Pipeline canvas

Stored Procedure activity

Successful run

## 📁 Repository Structure
text
fabric-datawarehouse-project/
│
├── sql/
│   ├── 01_load_raw_data.sql
│   ├── 02_clean_stgsales.sql
│   ├── 03_load_dimcustomer.sql
│   ├── 04_load_factsales.sql
│   ├── 05_loadcontrol_seed.sql
│   ├── 06_etl_wrapper.sql
│   └── exploration/
│       └── exploration_queries.sql
│
├── pipeline/
│   └── pipeline_export.json   (optional)
│
├── docs/
│   ├── architecture.png
│   ├── pipeline_screenshot.png
│   ├── loadcontrol_screenshot.png
│   └── model_screenshot.png
│
└── README.md
This structure keeps the project clean, reproducible, and easy to navigate.

## 📦 How to Run the Project
Create the tables in your Fabric Warehouse.

Load the raw CSV using 01_load_raw_data.sql.

Seed the metadata table using 05_loadcontrol_seed.sql.

Run the ETL wrapper manually or through the pipeline.

Verify the Dim and Fact tables.

(Optional) Connect Power BI to the Lakehouse.

## 📝 Medium Article
A full walkthrough of the project — including design decisions, Fabric limitations, and step‑by‑step explanations — is available here:

https://medium.com/@olayinkaogunneye/building-a-beginner-friendly-data-warehouse-in-microsoft-fabric-4a36074bcf54?postPublishedType=repub

✨ Future Enhancements
Add DimProduct and DimDate

Introduce Slowly Changing Dimensions (SCD)

Add event‑based triggers

Build a Power BI dashboard

Expand the dataset

📬 Contact
If you want to discuss Fabric, analytics engineering, or dashboard design, feel free to reach out.

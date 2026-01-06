# E-commerce SQL Analytics Project

## Project Overview
This is an end-to-end SQL analytics project built on a normalized e-commerce database.  
The project focuses on database design, relational modeling, and business-driven SQL analysis across sales, customers, sellers, payments, shipping, and inventory.

## Project Objective
The SQL analysis addresses key business questions such as:
- Top-selling products and categories
- Revenue contribution and customer lifetime value
- Customer behavior and return patterns
- Seller performance
- Inventory risk and shipping delays
- Payment success and failure trends

## Tools Used
- **SQL (MySQL)** – Database design and analytical querying  
- **MS Excel** – Initial data review and validation  
- **GitHub** – Version control and project documentation  

## Data Model Overview
- The project is built on a normalized relational data model designed to represent a real-world e-commerce business.
- The database schema and table relationships are documented in the ER diagram available [here](ecommerce_er_diagram/ecommerce_er_diagram.pdf)
- The database follows a **3NF (Third Normal Form)** structure to reduce redundancy and maintain data integrity.

## Repository Structure

```text
ecommerce-sql-analytics/
│
├── er-diagram/
│   └── ecommerce_er_diagram.pdf
│
├── schema/
│   └── create_tables.sql
│
├── sql/
│   └── analysis_queries.sql
│
├── data/
│   └── data_dictionary.md
│
├── insights/
│   └── key_business_insights.md
│
└── README.md

```
## Notes & Assumptions
- Raw CSV / Excel data files are intentionally excluded to keep the focus on database design and SQL analytics.
- All analysis is read-only and based on relational querying.
- The project is designed for interview discussion and analytical demonstration.

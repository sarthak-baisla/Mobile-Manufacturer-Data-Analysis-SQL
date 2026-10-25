# 📱 Mobile Manufacturer Data Analysis Using SQL

## 📌 Project Overview

This project focuses on analyzing mobile phone sales and customer transaction data using SQL Server. The objective is to extract meaningful business insights from transaction records, helping understand sales performance, customer purchasing behavior, manufacturer performance, and product pricing trends.

Using SQL queries, this case study explores real-world business questions related to mobile manufacturers, cellphone models, customer spending patterns, and year-over-year sales performance.

## 🎯 Project Objectives

- Analyze mobile phone sales across different states and locations.
- Identify top-performing manufacturers and cellphone models.
- Compare product prices and sales quantities.
- Understand customer purchasing behavior and spending patterns.
- Evaluate yearly sales trends and changes in customer spending.
- Generate data-driven insights to support business decisions.

## 🗂️ Database Schema

The database consists of one fact table and five dimension tables:

- **FACT_TRANSACTIONS:** Transaction details, total price, quantity, and related keys.
- **DIM_MANUFACTURER:** Manufacturer information.
- **DIM_MODEL:** Mobile model names, unit prices, and manufacturer IDs.
- **DIM_CUSTOMER:** Customer information.
- **DIM_DATE:** Date, year, quarter, and month details.
- **DIM_LOCATION:** Geographic information, including country, state, city, and ZIP code.

## 🔍 Key Business Questions

This case study answers 10 business questions, including:

- Which states have customers purchasing cellphones from 2005 onward?
- Which US state has the highest Samsung cellphone sales quantity?
- Which cellphone model is the cheapest?
- Which manufacturers and models perform best in terms of sales quantity?
- Which customers have high average transaction spending?
- Which models consistently rank among the top five across multiple years?
- Which manufacturers improved or changed their sales presence between 2009 and 2010?
- How do top customers' yearly spending and average purchase quantities change over time?

## 🛠️ Tools & Skills

- Microsoft SQL Server
- SQL / T-SQL
- JOINs and aggregate functions
- GROUP BY and HAVING
- Subqueries and Common Table Expressions (CTEs)
- Window Functions such as DENSE_RANK() and LAG()
- Year-over-year analysis and percentage-change calculations

## 💡 Key Learning Outcomes

This project demonstrates the application of SQL to solve business-oriented analytical problems, compare sales performance, rank products and manufacturers, and analyze customer spending trends over time.

It also strengthens practical skills in data aggregation, relational database analysis, and advanced SQL querying.

## 🚀 Conclusion

The project showcases how SQL can transform transaction data into actionable business insights. It is a practical demonstration of SQL-based data analysis and problem-solving skills for aspiring Data Analysts.

**Note:** This repository contains SQL analysis queries and the database schema image. The underlying dataset is not included.

## 📊 Database Schema

![Mobile Database Schema](Mobile%20database-schema.png)

## 👤 Author

**Sarthak Bansla**  
Aspiring Data Analyst

**Skills:** Excel | SQL | Power BI | Python 

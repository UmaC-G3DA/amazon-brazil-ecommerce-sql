# Amazon Brazil E-Commerce Data Analysis | MySQL

## Project Overview

This project explores business questions framed around Amazon India using Brazilian e-commerce data to analyse payment behaviour, product performance, customer purchasing patterns and sales trends.

I analysed five relational tables and worked through business questions using MySQL, progressing from basic queries to advanced SQL techniques.All monetary values are expressed in BRL.

## Business Objectives

- Understand customer payment preferences and payment-value patterns.
- Identify top-performing product categories and product-price differences.
- Examine customer purchasing frequency and repeat-order behaviour.
- Analyse monthly and seasonal sales trends.
- Identify products with strong sales performance and examine customer-linked payment patterns.

## Dataset & Tools

- **Dataset:** Brazilian E-Commerce
- **Tables:** Customers, Orders, Order Items, Products and Payments
- **Database:** MySQL
- **Environment:** MySQL Workbench

## Key Findings & Recommendations

1. **Payment preferences**:  Credit cards were the most frequently used payment method, appearing in 76.9% of orders, followed by boleto at 19.9%.Maintain convenient card-payment options while continuing to support alternative payment methods.
   
2. **Sales trends**: Spring and Summer contributed to majority sales value. April 2018 recorded the highest monthly sales value at BRL 996,648. Review seasonal demand when planning inventory, while investigating unusually low September 2018 sales of BRL 145.
   
3. **Product performance**: Beauty & Health(beleza_saude) was the leading category at BRL 1.26 million. These categories could be examined for potential expansion, subject to validation against Indian market demand.
   
4. **Product pricing**: The pcs category recorded the highest average product price at approximately BRL 1,098. Reviewing category-level pricing differences can help identify products that may require further pricing analysis.
   
5. **Customer analysis**: Occasional buyers accounted for 98,144 . Focus on developing customer loyalty strategies to convert first time buyers into repeat customers.

## Project Methodology

### Analysis 1 – Basic SQL Analysis 

- Calculated average payment values and payment-method distribution.
- Filtered products by price range and category.
- Analysed monthly sales patterns and product-category price differences.
- Compared payment-value variability using statistical functions.
- Identified missing or incomplete product-category names.

### Analysis 2 – Intermediate SQL Analysis 

- Grouped payment values into Low, Medium and High segments.
- Compared minimum, maximum and average product prices by category using three SQL approaches.
- Examined repeat-customer purchasing patterns using joins and grouping.
- Created customer purchase-frequency segments using a temporary table.
- Identified the top five product categories by item sales value.

### Analysis 3 – Advanced SQL Analysis

- Compared seasonal sales using subqueries and CTEs.
- Identified products with above-average sales-item counts.
- Analysed monthly sales trends for 2018.
- Explored customer purchasing-frequency segmentation.
- Ranked customer-linked records by average payment-record value.
- Calculated cumulative monthly sales for individual products using a recursive CTE.
- Analysed monthly payment trends using the 'LAG()' function.

## SQL Skills Demonstrated

- **Query fundamentals:** SELECT, WHERE, GROUP BY, HAVING, ORDER BY
- **Aggregations:** SUM(), AVG(), COUNT(), MIN(), MAX()
- **Joins:** INNER JOIN and multi-table joins
- **Conditional logic:** CASE statements
- **Advanced querying:** Subqueries, CTEs and recursive CTEs
- **Temporary tables:** CREATE TEMPORARY TABLE
- **Window functions:** RANK(), ROW_NUMBER(), LAG()
- **Statistical analysis:** VARIANCE(), STD()
- **Data handling:** NULL checks and date functions

## Repository Structure

```text
├── README.md
├── sql/
│   ├── Analysis_1.sql
│   ├── Analysis_2.sql
│   └── Analysis_3.sql
├── docs/
│   ├── Data_Analysis_using_SQL-_caase_study.docx
│   └── Amazonbrazil_Analysis_UMA_C_-G3_DASQL_.docx
└── data/
    └── Dataset .csv files
```

## How to Run

1. Open MySQL Workbench and create the database:
2. Import the five datasets into their respective tables: `customers`, `orders`, `order_items`, `products` and `payments`.
3. Open the SQL files in the `sql/` folder and execute the queries individually.
4. Ensure that business-question text is commented out before executing the SQL scripts.

**Requirement:** MySQL 8.0 or later.

## Project Outcome

Applied MySQL to investigate real-world e-commerce business questions, demonstrating practical skills in relational data analysis, payment analysis, product performance analysis, sales trends and advanced SQL querying.

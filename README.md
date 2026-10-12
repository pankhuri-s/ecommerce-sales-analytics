# E-Commerce Sales Analytics | MySQL & Power BI

## Project Overview

This project demonstrates an end-to-end data analytics workflow using MySQL and Microsoft Power BI. It focuses on cleaning and validating e-commerce data, analysing sales and product performance, understanding customer and regional patterns, and presenting business insights through interactive dashboards.

The project is designed to demonstrate practical SQL skills, data modelling, KPI development, data visualization, and business-oriented analytical thinking.

**Tools:** MySQL 8.0, MySQL Workbench, Microsoft Power BI, DAX

**Dataset:** Synthetically generated e-commerce data for portfolio and learning purposes. Results are illustrative and do not represent a real company.

## Business Objectives

- Measure overall sales and order performance.
- Analyse sales trends across products and categories.
- Evaluate product quantities, discounts, and subcategory performance.
- Understand customer demographics and regional distribution.
- Monitor order statuses, delivery performance, and delivered sales.
- Clean and validate data to improve analytical reliability.

## Dataset Structure

The project uses four relational tables:

| Table | Description |
|---|---|
| `Customers` | Customer details, demographics, and location |
| `Products` | Product names, categories, subcategories, and prices |
| `Orders` | Order dates, order statuses, and payment methods |
| `OrderDetails` | Products ordered, quantities, unit prices, and discounts |

### Final Cleaned Dataset

- **997** customers
- **150** products
- **5,000** orders
- **11,500** order-detail records

## SQL Workflow

The SQL work is organised into two scripts.

### 1. `Ecommerce_Data_Engineering_Cleaning.sql`

This script focuses on database preparation, data cleaning, and validation.

Key activities include:
- Creating and preparing database tables.
- Identifying and handling duplicate customer records.
- Addressing missing and inconsistent values.
- Standardising data and correcting data-quality issues.
- Validating product and customer references.
- Maintaining relationships between tables.
- Checking data consistency and reconciling sales calculations.

### 2. `Ecommerce_Data_Analysis.sql`

This script focuses on answering business questions using SQL.

Analytical areas include:
- Overall sales KPIs and average order value.
- Order-status and delivery analysis.
- Monthly sales trends.
- Product and category performance.
- Customer purchasing behaviour.
- Regional sales performance.
- Discount and payment-method analysis.
- Revenue rankings and percentage contributions.

The analysis uses SQL techniques such as joins, aggregations, conditional logic, subqueries, CTEs, and window functions where applicable.

## Power BI Dashboards

The Power BI report contains three dashboard pages.

### Dashboard 1 — Executive Sales Overview

Provides a high-level view of business performance through:
- Total Orders
- Net Sales
- Total Discount
- Average Order Value
- Delivery Rate
- Sales trends and order-status distribution
- Sales by category, payment method, state, and gender
- Top products by sales

### Dashboard 2 — Product & Discount Analysis

Explores product performance and discount patterns through:
- Top products by quantity sold
- Net sales by subcategory
- Average discount by category
- Quantity sold by category
- Delivered Sales KPI

### Dashboard 3 — Customer & Regional Analysis

Examines customer and operational patterns through:
- Customer count by state
- Order-status distribution
- Customer distribution by gender
- Delivered Orders KPI

## Key Findings

The following values were validated against the SQL analysis of the synthetic dataset.

### Overall Performance — All Order Statuses

| Metric | Result |
|---|---:|
| Total Orders | 5,000 |
| Gross Sales | 135,452,377.08 |
| Total Discounts | 7,242,847.41 |
| Net Sales After Discounts | 128,209,529.67 |
| Average Order Value | 25,641.91 |
| Overall Discount Rate | 5.35% |

### Delivered Orders

| Metric | Result |
|---|---:|
| Delivered Orders | 3,750 |
| Delivered Net Sales | 91,589,069.68 |
| Delivered Average Order Value | 24,423.75 |
| Delivered Order Share | 75% |

Electronics contributed **67.42%** of delivered net sales, followed by Fashion at **16.41%** in this dataset.

*Values are expressed in dataset currency units because no specific currency was defined.*

## Business Recommendations

Based on the illustrative findings, a business analyst could:

1. Monitor delivered sales separately from orders that have not been completed.
2. Investigate the high contribution of Electronics to delivered sales and assess category concentration.
3. Review discount patterns by category and product to support promotional decisions.
4. Track sales trends and regional performance to identify areas for further investigation.
5. Maintain regular data-quality checks and sales reconciliation before publishing dashboards.

These recommendations indicate areas for investigation; they do not establish causal relationships.

## Project Files

### SQL Scripts
- `Ecommerce_Data_Engineering_Cleaning.sql` — database preparation, data cleaning, and validation.
- `Ecommerce_Data_Analysis.sql` — SQL-based business analysis.

### Power BI and Documentation
- `Ecommerce_Sales_Analytics.pbix` — interactive Power BI report.
- `Ecommerce_Sales_Analytics.pdf` — exported report.
- `Dashboard_1_Executive_Overview.png` — executive dashboard preview.
- `Dashboard_2_Product_Discount.png` — product and discount dashboard preview.
- `Dashboard_3_Customer_Regional.png` — customer and regional dashboard preview.
- `README.md` — project documentation.

## Limitations

The dataset is synthetic and does not represent verified real-world transactions. It does not include verified product costs or operating expenses. Therefore, net sales after discounts should not be interpreted as profit, and the results should not be treated as real-world market benchmarks.

## Author

**Pankhuri**

GitHub Portfolio: https://github.com/pankhuri-s
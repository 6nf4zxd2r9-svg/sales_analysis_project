/*
==============================================
SALES DATABASE QUERIES
==============================================
Database: sales_db
Table: sales
Created: 2/10/2026
Author: Uddhav Kattel
Purpose: Analysis queries for 2024 sales data
Available Objects:
- Table: sales (raw sales data)
- View: product_performance (aggregated product metrics)
Usage:
Run queries individually to answer specific business questions.
Use product_performance view for quick product analysis.
==============================================
*/

CREATE TABLE sales(
	sale_id integer PRIMARY KEY, 
	date DATE NOT NULL, 
	product varchar(50) NOT NULL,
	quantity integer NOT NULL,
	price decimal(10,2) NOT NULL,
	total decimal (10,2) NOT NULL,
	region varchar(20)
);	
SELECT count(*) FROM sales;

--Total revenue and sales count
SELECT 
	count(*) AS total_transactions,
	sum(total) AS total_revenue,
	AVG(total) AS average_sale
FROM sales;

--Revenue By Product
SELECT 
	product,
	count(*) AS num_sales,
	SUM(quantity) AS units_sold,
	SUM(total) AS revenue
FROM sales 
GROUP BY product 
ORDER BY revenue DESC;

-- Sales by region
SELECT
region,
COUNT(*) as num_sales,
SUM(total) as revenue,
ROUND(AVG(total), 2) as avg_sale
FROM sales
GROUP BY region
ORDER BY revenue DESC;

-- Monthly sales trend
SELECT
TO_CHAR(date, 'YYYY-MM') as month,
COUNT(*) as num_sales,
SUM(total) as monthly_revenue
FROM sales
GROUP BY TO_CHAR(date, 'YYYY-MM')
ORDER BY month;

--Products by units sold
SELECT
product,
SUM(quantity) as total_units_sold,
SUM(total) as revenue
FROM sales
GROUP BY product
ORDER BY total_units_sold DESC
LIMIT 5;

--View for product performance
CREATE VIEW product_performance AS
SELECT
product,
COUNT(*) as transaction_count,
SUM(quantity) as total_units,
SUM(total) as total_revenue,
ROUND(AVG(total), 2) as avg_transaction_value,
ROUND(SUM(total) * 100.0 / (SELECT SUM(total) FROM sales), 2) as revenue_percentage
FROM sales
GROUP BY product
ORDER BY total_revenue DESC;

SELECT * FROM product_performance;

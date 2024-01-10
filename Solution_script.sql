-- Question (1)
/* Provide the list of markets in which customer "Atliq Exclusive" operates its business in the APAC region. */

SELECT DISTINCT market
FROM dim_customer
WHERE customer = "Atliq Exclusive" AND region = "APAC";

-- Question (2)
/* What is the percentage of unique product increase in 2021 vs. 2020?
The final output contains these fields:
unique_products_2020,
unique_products_2021,
percentage_chg */

WITH cte AS (SELECT
				(SELECT COUNT(DISTINCT product_code)
				 FROM fact_sales_monthly
				 WHERE fiscal_year = 2020) AS unique_products_2020,
				(SELECT COUNT(DISTINCT product_code)
				FROM fact_sales_monthly
				WHERE fiscal_year = 2021) AS unique_products_2021)
SELECT
	unique_products_2020,
    unique_products_2021,
    ROUND((unique_products_2021 - unique_products_2020)*100/unique_products_2020, 2) AS percentage_change
FROM cte;

-- Question (3)
/* Provide a report with all the unique product counts for each segment and sort them in descending order of product counts.
The final output contains 2 fields:
segment, product_count */

SELECT 
	segment,
    COUNT(DISTINCT product_code) AS unique_products
FROM dim_product
GROUP BY segment
ORDER BY unique_products DESC;

-- Question (4)
/* Follow-up: Which segment had the most increase in unique products in 2021 vs 2020?
The final output contains these fields:
segment, product_count_2020, product_count_2021, difference */

WITH cte_2020 AS (SELECT segment,
						 COUNT(DISTINCT product_code) product_counts_2020
				  FROM fact_sales_monthly
				  JOIN dim_product USING (product_code)
				  WHERE fiscal_year = 2020
				  GROUP BY segment),
	cte_2021 AS (SELECT segment,
						COUNT(DISTINCT product_code) product_counts_2021
				  FROM fact_sales_monthly
				  JOIN dim_product USING (product_code)
				  WHERE fiscal_year = 2021
				  GROUP BY segment)
	SELECT
		cte_2020.segment,
		cte_2020.product_counts_2020,
		cte_2021.product_counts_2021,
		(cte_2021.product_counts_2021 - cte_2020.product_counts_2020) AS difference
	FROM cte_2020
	JOIN cte_2021 USING(segment)
	ORDER BY difference DESC;
    
 -- Question (5)
/* Get the products that have the highest and lowest manufacturing costs.
The final output should contain these fields: product_code, product, manufacturing_cost */

SELECT 
	p.product_code,
    p.product,
    c.manufacturing_cost
FROM dim_product p
join fact_manufacturing_cost c
ON p.product_code = c.product_code
WHERE c.manufacturing_cost = (SELECT MAX(manufacturing_cost) FROM fact_manufacturing_cost)
UNION
SELECT 
	p.product_code,
    p.product,
    c.manufacturing_cost
FROM dim_product p
join fact_manufacturing_cost c
ON p.product_code = c.product_code
WHERE c.manufacturing_cost = (SELECT MIN(manufacturing_cost) FROM fact_manufacturing_cost);



 -- Question (6)
/* Generate a report which contains the top 5 customers who received an average high pre_invoice_discount_pct for the fiscal year 2021 and in the Indian market.
The final output contains these fields: customer_code, customer, average_discount_percentage */

SELECT
	d.customer_code,
    c.customer,
    AVG(pre_invoice_discount_pct) AS average_discount_percentage
FROM fact_pre_invoice_deductions d
JOIN dim_customer c
ON d.customer_code = c.customer_code
WHERE d.fiscal_year = 2021 AND market = "India"
GROUP BY d.customer_code, c.customer
ORDER BY average_discount_percentage DESC
LIMIT 5;


 -- Question (7)
/* Get the complete report of the Gross sales amount for the customer “Atliq Exclusive” for each month.
This analysis helps to get an idea of low and high-performing months and take strategic decisions.
The final report contains these columns: Month, Year, Gross sales Amount */









    
    
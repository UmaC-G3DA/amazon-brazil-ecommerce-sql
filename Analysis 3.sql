use amazonbrazil
1.	The marketing team wants to compare the total sales between different seasons. 
Use a subquery to calculate total sales for each season (Spring, Summer, Autumn, Winter) based on order purchase dates, 
and display the results. Spring is in the months of March, April and May. 
Summer is from June to August and Autumn is between September and November and rest months are Winter. 
o	Output: season, total_sales 

SELECT seasons, SUM(sales) AS total_sales
FROM (SELECT                                                                                        -- Inline subquery
(SELECT SUM(oi.price) FROM order_items AS oi WHERE o.order_id=oi.order_id)  AS sales,               -- Scalar subquery
CASE 
  WHEN MONTHNAME(o.order_purchase_timestamp) IN ('March','April','May') THEN 'Spring'
  WHEN MONTHNAME(o.order_purchase_timestamp) IN ('June','July','August') THEN 'Summer'
  WHEN MONTHNAME(o.order_purchase_timestamp) IN ('September','October','November') THEN 'Autumn'
  ELSE 'Winter'    
END AS seasons  
FROM orders AS o
) AS subquery
GROUP BY seasons;
   
(or) /*Using cte method*/

WITH season_cte AS (
SELECT (SELECT SUM(oi.price) FROM order_items AS oi WHERE o.order_id=oi.order_id)  AS sales,
CASE 
  WHEN MONTHNAME(o.order_purchase_timestamp) IN ('March','April','May') THEN 'Spring'
  WHEN MONTHNAME(o.order_purchase_timestamp) IN ('June','July','August') THEN 'Summer'
  WHEN MONTHNAME(o.order_purchase_timestamp) IN ('September','October','November') THEN 'Autumn'
  ELSE 'Winter'    END AS seasons  
FROM orders AS o
) 
SELECT seasons, SUM(sales) AS total_sales
FROM season_cte
GROUP BY seasons;


2.	The inventory team is interested in identifying products that have sales volumes above the overall average. 
Write a query that uses a subquery to filter products with a total quantity sold above the average quantity.
o	Output: product_id, total_quantity_sold

SELECT product_id, COUNT(order_id) AS total_quantity_sold
FROM order_items 
GROUP BY product_id
HAVING total_quantity_sold > (SELECT AVG( total_quantity_sold ) AS avg_qty
							    FROM (SELECT product_id, COUNT(order_id) AS total_quantity_sold
                                      FROM order_items  
                                      GROUP BY product_id) AS subquery     
                                      );
                                      
(or) /*(Using inline subquery method)*/

SELECT product_id,total_quantity,avg_quantity
FROM                                                                   
( SELECT product_id, COUNT(*) AS total_quantity, AVG(COUNT(*)) OVER () AS avg_quantity
  FROM order_items
  GROUP BY product_id
) AS product_sales_subquery
WHERE total_quantity > avg_quantity;

3.	To understand seasonal sales patterns, the finance team is analysing the monthly revenue trends over the past year (year 2018). 
Run a query to calculate total revenue generated each month and identify periods of peak and low sales.
Export the data to Excel and create a graph to visually represent revenue changes across the months. 
o	Output: month, total_revenue

SELECT MONTHNAME(o.order_purchase_timestamp) AS months,SUM(oi.price) AS total_revenue
FROM orders AS o
JOIN order_items AS oi 
ON o.order_id = oi.order_id
WHERE YEAR(o.order_purchase_timestamp) = 2018
GROUP BY months
ORDER BY total_revenue DESC;


4.	A loyalty program is being designed  for Amazon India. Create a segmentation based on purchase frequency:
 ‘Occasional’ for customers with 1-2 orders, ‘Regular’ for 3-5 orders, and ‘Loyal’ for more than 5 orders.
 Use a CTE to classify customers and their count and generate a chart in Excel to show the proportion of each segment.
o	Output: customer_type, count

WITH customer_segments AS (
SELECT c.customer_id, COUNT(o.order_id) AS order_count,
CASE 
WHEN  COUNT(o.order_id) IN (1,2) THEN 'Occasional'
WHEN  COUNT(o.order_id) BETWEEN 3 AND 5 THEN 'Regular'
WHEN COUNT(o.order_id)>5 THEN 'Loyal'
END AS customer_type
FROM orders AS o
INNER JOIN customers AS c ON c.customer_id=o.customer_id
GROUP BY c.customer_id
)
SELECT customer_type, COUNT(*) AS count_total
FROM customer_segments
GROUP BY customer_type;


5.	Amazon wants to identify high-value customers to target for an exclusive rewards program. 
You are required to rank customers based on their average order value (avg_order_value) to find the top 20 customers.
o	Output: customer_id, avg_order_value, and customer_rank

SELECT customer_id, avg_order_value,customer_rank
FROM ( SELECT o.customer_id, AVG(p.payment_value) AS avg_order_value,
			  RANK() OVER( ORDER BY AVG(p.payment_value)  DESC) AS customer_rank
       FROM payments AS p
       JOIN orders AS o 
       ON p.order_id=o.order_id
       GROUP BY o.customer_id 
       ) AS subquery
WHERE customer_rank <=20;


6.	Amazon wants to analyze sales growth trends for its key products over their lifecycle.
 Calculate monthly cumulative sales for each product from the date of its first sale. 
 Use a recursive CTE to compute the cumulative sales (total_sales) for each product month by month.
o	Output: product_id, sale_month, and total_sales

WITH RECURSIVE product_sales_cte AS (
SELECT oi.product_id, DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m-01') AS sale_month,
SUM(oi.price) AS monthly_sales,
ROW_NUMBER() OVER ( PARTITION BY oi.product_id ORDER BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m-01') ) AS month_no
FROM orders AS o
JOIN order_items AS oi
ON o.order_id = oi.order_id
GROUP BY oi.product_id, DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m-01')
),
cumulative_sales_cte AS (                            
SELECT product_id, sale_month, monthly_sales,
monthly_sales AS total_sales, month_no
FROM product_sales_cte
WHERE month_no = 1                                       -- First sale month of each product (Anchor member)
UNION ALL
SELECT p.product_id, p.sale_month, p.monthly_sales, c.total_sales + p.monthly_sales AS total_sales, p.month_no
FROM cumulative_sales_cte AS c
JOIN product_sales_cte AS p
ON p.product_id = c.product_id
AND p.month_no = c.month_no + 1                           -- Add the next month's sales (Recursive member)
)
SELECT product_id, sale_month, monthly_sales, total_sales
FROM cumulative_sales_cte
ORDER BY product_id, sale_month;


7.	To understand how different payment methods affect monthly sales growth, 
Amazon wants to compute the total sales for each payment method and 
calculate the month-over-month growth rate for the past year (year 2018). 
Write query to first calculate total monthly sales for each payment method, then compute the percentage change from the previous month.
o	Output: payment_type, sales_month, monthly_total, monthly_change.
        
WITH monthly_sales_cte AS (
SELECT p.payment_type,  MONTHNAME(o.order_purchase_timestamp) AS sales_month, 
       MONTH(o.order_purchase_timestamp) AS month_number,SUM(p.payment_value) AS monthly_total
FROM orders AS o
JOIN payments AS p 
ON p.order_id=o.order_id
WHERE YEAR(o.order_purchase_timestamp) = 2018 
GROUP BY p.payment_type, sales_month,month_number  )

SELECT payment_type, sales_month, monthly_total,
 ((monthly_total - LAG(monthly_total) OVER (PARTITION BY payment_type ORDER BY month_number ))
        / NULLIF(LAG(monthly_total) OVER (PARTITION BY payment_type ORDER BY month_number ),0)) * 100   AS monthly_change
FROM monthly_sales_cte
ORDER BY payment_type,month_number;

/*Percentage change = ((Current month - Previous month) / Previous month) *100    
 order by month_number is used because using monthname sorts it in alphabetical order then april appears first*/
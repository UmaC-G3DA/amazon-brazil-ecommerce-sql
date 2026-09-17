use amazonbrazil

1.	Amazon India wants to understand which payment types are most popular across different order value segments (e.g., low, medium, high). 
Segment order values into three ranges: orders less than 200 BRL, between 200 and 1000 BRL, and over 1000 BRL. 
Calculate the count of each payment type within these ranges and display the results in descending order of count.
o	Output: order_value_segment, payment_type, count

WITH customer_segments AS( 
SELECT  payment_type,
CASE 
  WHEN payment_value < 200 THEN 'Low'
  WHEN payment_value BETWEEN 200 AND 1000 THEN 'Medium'
  ELSE 'High'
  END AS order_value_segment 
FROM payments
)
SELECT  payment_type, COUNT(payment_type) AS payment_type_count, order_value_segment
FROM customer_segments
GROUP BY payment_type, order_value_segment
ORDER BY payment_type_count DESC;

/*(Each row represent Eg: segment low - customer spent <200 using credit card & this combination occured 60548 times)*/
    
  2.	Amazon India wants to analyse the price range and average price for each product category. 
  Calculate the minimum, maximum, and average price for each category, and list them in descending order by the average price.
  o	Output: product_category_name, min_price, max_price, avg_price

/*Using scalar subquery method */

SELECT (SELECT product_category_name FROM products AS p WHERE p.product_id= oi.product_id) AS product_category,
MIN(oi.price) AS min_price, MAX(oi.price) AS max_price, AVG(oi.price) AS avg_price
FROM order_items AS oi
GROUP BY product_category
ORDER BY avg_price DESC;

(or)

SELECT p.product_category_name,
MIN(oi.price) AS min_price, MAX(oi.price) AS max_price, AVG(oi.price) AS avg_price
FROM order_items AS oi
INNER JOIN products AS p
ON p.product_id=oi.product_id
GROUP BY product_category_name
ORDER BY avg_price DESC;

(or) /* Using cte method */

WITH category_pricing AS (
SELECT p.product_category_name,
MIN(oi.price) AS min_price, MAX(oi.price) AS max_price, AVG(oi.price) AS avg_price
FROM order_items AS oi
INNER JOIN products AS p
ON p.product_id=oi.product_id
GROUP BY product_category_name
)
SELECT product_category_name, min_price, max_price,avg_price 
FROM category_pricing
ORDER BY avg_price DESC;


3.	Amazon India wants to identify the customers who have placed multiple orders over time. 
Find all customers with more than one order, and display their customer unique IDs along with the total number of orders they have placed.
o	Output: customer_unique_id, total_orders

SELECT c.customer_unique_id, COUNT(o.order_id) AS total_orders
FROM customers AS c
JOIN orders AS o ON c.customer_id = o.customer_id
GROUP BY customer_unique_id
HAVING COUNT(o.order_id) > 1;

(or)

WITH customer_orders AS (
SELECT c.customer_unique_id, COUNT(o.order_id) AS total_orders
FROM customers AS c
JOIN orders AS o  ON c.customer_id = o.customer_id
GROUP BY customer_unique_id
HAVING total_orders > 1
)
SELECT *
FROM customer_orders;


4.	Amazon India wants to categorize customers into 
different types ('New – order qty. = 1' ;  'Returning' –order qty. 2 to 4;  'Loyal' – order qty. >4) based on their purchase history. 
Use a temporary table to define these categories and join it with the customers table to update and display the customer types.
o	Output: customer_unique_id, customer_type

CREATE TEMPORARY TABLE customer_category_temp AS
SELECT c.customer_unique_id,
CASE 
    WHEN COUNT(order_id) = 1 THEN 'New'
    WHEN COUNT(order_id) BETWEEN 2 AND 4 THEN 'Returning'
    WHEN COUNT(order_id)> 4 THEN 'Loyal'
    END     AS customer_type
FROM orders AS o
INNER JOIN customers AS c 
ON c.customer_id=o.customer_id
GROUP BY customer_unique_id ;

SELECT customer_unique_id, customer_type
FROM customer_category_temp;


5.	Amazon India wants to know which product categories generate the most revenue. 
Use joins between the tables to calculate the total revenue for each product category. Display the top 5 categories.
o	Output: product_category_name, total_revenue

SELECT p.product_category_name, SUM(oi.price) AS total_revenue
FROM products AS p
INNER JOIN order_items AS oi
ON p.product_id = oi.product_id
GROUP By product_category_name
ORDER By total_revenue DESC
LIMIT 5;
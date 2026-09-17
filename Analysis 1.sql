create schema amazonbrazil
use amazonbrazil

1.To simplify its financial reports, Amazon India needs to standardize payment values.
 Round the average payment values to integer (no decimal) for each payment type and display the results sorted in ascending order.
 Output: payment_type, rounded_avg_payment
 
SELECT payment_type, ROUND(AVG(payment_value), 0) AS rounded_avg_payment
FROM payments
GROUP BY payment_type
ORDER BY rounded_avg_payment ASC;


2.To refine its payment strategy, Amazon India wants to know the distribution of orders by payment type. 
  Calculate the percentage of total orders for each payment type, rounded to one decimal place, and display them in descending order.
  Output: payment_type, percentage_orders

SELECT payment_type,
ROUND(COUNT(DISTINCT order_id)*100/(SELECT(COUNT(DISTINCT order_id)) FROM payments),1)
AS percentage_orders
FROM payments
GROUP BY payment_type
ORDER BY percentage_orders DESC;


3.Amazon India seeks to create targeted promotions for products within specific price ranges. 
  Identify all products priced between 100 and 500 BRL that contain the word 'Smart' in their name.
  Display these products, sorted by price in descending order.
  Output: product_id, price
  
  SELECT oi.product_id, oi.price, product_category_name
  FROM order_items AS oi
  JOIN products AS p
  ON oi.product_id = p.product_id
  WHERE price BETWEEN 100 AND 500 
  AND product_category_name LIKE '%Smart%'
  ORDER BY price DESC;
  
  
4.To identify seasonal sales patterns, Amazon India needs to focus on the most successful months. 
  Determine the top 3 months with the highest total sales value, rounded to the nearest integer.
  Output: month, total_sales

  SELECT MONTHNAME(order_purchase_timestamp) AS month, ROUND(SUM(oi.price)) AS total_sales
  FROM orders AS o
  JOIN order_items AS oi
  ON o.order_id = oi.order_id
  GROUP BY month
  ORDER BY total_sales DESC
  LIMIT 3;
  
  
5.Amazon India is interested in product categories with significant price variations.
  Find categories where the difference between the maximum and minimum product prices is greater than 500 BRL.
  Output: product_category_name, price_difference

  SELECT p.product_category_name, (MAX(oi.price)-MIN(oi.price)) AS price_difference
  FROM products AS p
  JOIN order_items AS oi
  ON p.product_id = oi.product_id
  GROUP BY p.product_category_name
  HAVING price_difference > 500
  ORDER BY price_difference;
  
  
6.To enhance the customer experience, Amazon India wants to find which payment types have the most consistent transaction amounts. 
   Identify the payment types with the least variance in transaction amounts, sorting by the smallest standard deviation first.
   Output: payment_type, std_deviation
  
  SELECT payment_type, VARIANCE(payment_value) AS payment_variance,STD(payment_value) AS std_deviation 
  FROM payments
  GROUP BY payment_type
  ORDER BY std_deviation ASC;
  
  
7.Amazon India wants to identify products that may have incomplete name in order to fix it from their end. 
  Retrieve the list of products where the product category name is missing or contains only a single character.
  Output: product_id, product_category_name 
 
 SELECT product_id, product_category_name
 FROM products
 WHERE product_category_name IS NULL 
 OR LENGTH(product_category_name) = 1;
  
 
  
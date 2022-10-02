# Case Study #7 - Balanced Tree Clothing Co.
  <p align="center">
  <img src="https://github.com/David8523/Learning-SQL/blob/main/8%20Week%20SQL%20Challenge/Images/Case%207.png" /
</p>
	
## Introduction

Balanced Tree Clothing Company prides themselves on providing an optimised range of clothing and lifestyle wear for the modern adventurer!

Danny, the CEO of this trendy fashion company has asked you to assist the team’s merchandising teams analyse their sales performance and generate a basic financial report to share with the wider business.

## Available Data

For this case study there is a total of 4 datasets for this case study - however you will only need to utilise 2 main tables to solve all of the regular questions, and the additional 2 tables are used only for the bonus challenge question!

## Case Study Questions

The following questions can be considered key business questions and metrics that the Balanced Tree team requires for their monthly reports.

Each question can be answered using a single query - but as you are writing the SQL to solve each individual problem, keep in mind how you would generate all of these metrics in a single SQL script which the Balanced Tree team can run each month.

### High Level Sales Analysis

#### 1.  What was the total quantity sold for all products?
~~~~sql
SELECT 
 SUM(qty) AS  quantity_sold
FROM balanced_tree.sales AS sales;
~~~~
|quantity_sold
| --------- |
|45216
#### 2.  What is the total generated revenue for all products before discounts?
~~~~sql
SELECT 
 SUM(qty * price) AS total_revenue
FROM balanced_tree.sales
~~~~
|total_revenue
| --------- |
|1289453
#### 3.  What was the total discount amount for all products?
~~~~sql
SELECT 
 SUM(qty * discount) AS total_discount
FROM balanced_tree.sales
~~~~
|total_discount
| --------- |
|546431
### Transaction Analysis

#### 1.  How many unique transactions were there?
~~~~sql
SELECT 
 COUNT(DISTINCT txn_id ) AS unique_transactions
FROM balanced_tree.sales
~~~~
|unique_transactions
| --------- |
|2500

#### 2.  What is the average unique products purchased in each transaction?
~~~~sql
WITH products_purchased_CTE AS (
SELECT
 txn_id,
 COUNT (DISTINCT prod_id) AS products_purchased
FROM balanced_tree.sales
GROUP BY txn_id)

SELECT
 ROUND(AVG(products_purchased),2) AS avg_products_purchased
FROM products_purchased_CTE

~~~~

 |avg_products_purchased
| --------- |
 |6.04

#### 4.  What is the average discount value per transaction?
~~~~sql
WITH discounts_CTE AS(
SELECT
 txn_id,
 SUM(qty * discount ) AS discount_per_transaction
FROM balanced_tree.sales
GROUP BY txn_id)

SELECT
 ROUND(AVG(discount_per_transaction),2) AS
 avg_discount_per_transaction
FROM discounts_CTE
~~~~
| avg_discount_per_transaction
| --------- |
| 218.57
#### 5.  What is the percentage split of all transactions for members vs non-members?
~~~~sql
SELECT 
 ROUND(100 * 
  COUNT(DISTINCT CASE WHEN member = 't' THEN txn_id END) / 
  COUNT(DISTINCT txn_id), 2) AS member,
 ROUND(100 * 
  COUNT(DISTINCT CASE WHEN member = 'f' THEN txn_id END) / 
  COUNT(DISTINCT txn_id), 2) AS non_member
FROM balanced_tree.sales
~~~~

member	|non_member
| --------- |--------- |
60.20|	39.80
#### 6.  What is the average revenue for member transactions and non-member transactions?
~~~~sql
WITH member_revenue_CTE AS (
 SELECT
  SUM(price * qty - discount) AS revenue,
    member,
    txn_id  
  FROM balanced_tree.sales
  GROUP BY member, txn_id)
    
SELECT
  member,
  ROUND(AVG(revenue), 2) AS avg_revenue
FROM member_revenue_CTE
GROUP BY member
~~~~
member	|avg_revenue
| --------- |--------- |
t|	443.78
f	|  441.06
### Product Analysis

#### 1.  What are the top 3 products by total revenue before discount?
~~~~sql
SELECT
 product_name,
 SUM(qty * s.price) AS total_revenue
FROM balanced_tree.sales s
JOIN balanced_tree.product_details p ON p.product_id=s.prod_id
GROUP BY product_name
ORDER BY total_revenue DESC
LIMIT 3
~~~~

product_name  |total_revenue
| --------- |--------- |
Blue Polo Shirt - Mens | 21768
Grey Fashion Jacket - Womens  |209304
White Tee Shirt - Mens|  152000
#### 2.  What is the total quantity, revenue and discount for each segment?
~~~~sql
SELECT 
 segment_name,
 SUM(qty) AS total_quantity,
 SUM(qty * s.price) AS total_revenue,
 SUM(discount) AS total_discount
FROM balanced_tree.sales s
JOIN balanced_tree.product_details p ON p.product_id=s.prod_id
GROUP BY segment_name
ORDER BY total_revenue DESC;
~~~~
segment_name |	total_quantity |	total_revenue |	total_discount
| --------- |--------- |--------- |--------- |
Shirt	 |11265	 |406143	 |46043
Jacket |	11385 |	366983 |	45452
Socks |	11217 |	307977 |	45465
Jeans |	11349 |	208350 |	45740

#### 3.  What is the top selling product for each segment?
~~~~sql
SELECT 
 segment_name,
 product_name,
 SUM(qty*s.price) AS total_revenue
FROM balanced_tree.sales AS s
JOIN balanced_tree.product_details d ON d.product_id = s.prod_id
GROUP BY segment_name,product_name
ORDER BY total_revenue DESC
LIMIT 5
~~~~
segment_name	|product_name	|total_revenue
| --------- |--------- |--------- |
Shirt	|Blue Polo Shirt - Mens	|217683
Jacke|t	Grey Fashion Jacket - Womens|	209304
Shirt|	White Tee Shirt - Mens	|152000
Socks	|Navy Solid Socks - Mens|	136512
Jeans|	Black Straight Jeans - Womens|	121152


#### 4.  What is the total quantity, revenue and discount for each category?
~~~~sql
SELECT 
 category_name,
 SUM(qty) AS total_quantity,
 SUM(qty * s.price) AS total_revenue,
 SUM(discount) AS total_discount
FROM balanced_tree.sales s
JOIN balanced_tree.product_details d ON d.product_id = s.prod_id
GROUP BY category_id, category_name
ORDER BY total_revenue DESC
~~~~
category_name	|total_quantity	|total_revenue	|total_discount
| --------- |--------- |--------- |--------- |
Mens	 |22482 |	714120 |	91508
Womens |	22734 |	575333	 |91192
#### 5.  What is the top selling product for each category?
~~~~sql
SELECT 
 category_name,
 product_name,
 SUM(qty*s.price) AS total_revenue
FROM balanced_tree.sales s
JOIN balanced_tree.product_details d ON d.product_id = s.prod_id
GROUP BY category_name, product_name
ORDER BY total_revenue DESC
LIMIT 5
~~~~
category_name | product_name | total_revenue
| --------- |--------- |--------- |
Mens  |Blue Polo Shirt - Mens  |217683
Womens  |Grey Fashion Jacket - Womens | 209304
Mens | White Tee Shirt - Mens|  152000
Mens|  Navy Solid Socks - Mens | 136512
Womens | Black Straight Jeans - Womens | 121152


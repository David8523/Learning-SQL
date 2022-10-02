# Case Study #6 - Clique Bait
 <p align="center">
  <img src="https://github.com/David8523/Learning-SQL/blob/main/8%20Week%20SQL%20Challenge/Images/Case%206.png" /
</p>
	
## Introduction

Clique Bait is not like your regular online seafood store - the founder and CEO Danny, was also a part of a digital data analytics team and wanted to expand his knowledge into the seafood industry!

In this case study - you are required to support Danny’s vision and analyse his dataset and come up with creative solutions to calculate funnel fallout rates for the Clique Bait online store.
### Enterprise Relationship Diagram

Using the following DDL schema details to create an ERD for all the Clique Bait datasets.
  <p align="center">
  <img src="https://github.com/David8523/Learning-SQL/blob/main/8%20Week%20SQL%20Challenge/Images/6.png" /
</p>

### Digital Analysis

Using the available datasets - answer the following questions using a single query for each one:

#### 1.  How many users are there?
 ~~~~sql
SELECT 
  COUNT(DISTINCT user_id) AS "User count"
FROM clique_bait.users
~~~~
User count|
| ---------- |
500|
#### 2.  How many cookies does each user have on average?
 ~~~~sql
WITH cookies_CTE AS (
SELECT 
  user_id,
  COUNT(cookie_id) AS cookies_count
FROM clique_bait.users
GROUP BY user_id)

SELECT 
  AVG(cookies_count) AS average_cookies
FROM cookies_CTE
~~~~
 |average_cookies
| ---------- |
 |3.5640
#### 3.  What is the unique number of visits by all users per month?
 ~~~~sql
SELECT 
  MONTH(event_time) AS month_number,
  MONTHNAME(event_time) AS month,
 COUNT(DISTINCT visit_id) AS unique_visits_count
FROM clique_bait.events
GROUP BY month,month_number
ORDER BY month_number
~~~~
month_number  |month | unique_visits_count
| ---------- | ---------- | ---------- |
1 |January |876
2 |February |1488
3 |March |916
4 |April |248
5 |May |36
#### 4.  What is the number of events for each event type?
 ~~~~sql
SELECT 
  e.event_type, 
  event_name,
  COUNT(visit_id) AS event_count
FROM clique_bait.events e
JOIN clique_bait.event_identifier i ON i.event_type=e.event_type
GROUP BY e.event_type, event_name
ORDER BY e.event_type
~~~~
event_type	 |event_name	 |event_count
| ---------- | ---------- | ---------- |
1	 |Page View |	20928
2 |	Add to Cart |	8451
3	 |Purchase |	1777
4 |	Ad Impression |	876
5 |	Ad Click	 |702

#### 5.  What is the percentage of visits which have a purchase event?
 ~~~~sql
SELECT 
 e.event_type, 
  event_name,
 100* COUNT(visit_id)/(SELECT COUNT(DISTINCT visit_id) FROM clique_bait.events) AS percentage
FROM clique_bait.events e
JOIN clique_bait.event_identifier i ON i.event_type=e.event_type
WHERE event_name = 'Purchase'
GROUP BY e.event_type, event_name
ORDER BY e.event_type
~~~~
event_type | event_name |percentage
| ---------- | ---------- | ---------- |
3  |Purchase |49.8597
#### 6.  What is the percentage of visits which view the checkout page but do not have a purchase event?
 ~~~~sql
WITH checkout_purchase_CTE AS (
SELECT 
  visit_id,
  MAX(CASE WHEN event_type = 1 AND page_id = 12 THEN 1 ELSE 0 END) AS checkout,
  MAX(CASE WHEN event_type = 3 THEN 1 ELSE 0 END) AS purchase
FROM clique_bait.events
GROUP BY visit_id)

SELECT (1- SUM(purchase)/ SUM(checkout)) * 100 AS checkout_only_percentage
FROM checkout_purchase_CTE
~~~~
 |checkout_only_percentage
| ---------- |
 | 15.5017
#### 7.  What are the top 3 pages by number of views?
 ~~~~sql
SELECT 
  p.page_name, 
  COUNT(visit_id) AS views_count
FROM clique_bait.events AS e
JOIN clique_bait.page_hierarchy p ON e.page_id = p.page_id
WHERE e.event_type = 1 
GROUP BY p.page_name
ORDER BY views_count DESC
LIMIT 3; 
~~~~
page_name	|views_count
| ---------- |---------- |
All Products	|3174
Checkout|	2103
Home Page	|1782

#### 8.  What is the number of views and cart adds for each product category?
 ~~~~sql
SELECT 
  p.product_category, 
  SUM(CASE WHEN e.event_type = 1 THEN 1 ELSE 0 END) AS views_count,
  SUM(CASE WHEN e.event_type = 2 THEN 1 ELSE 0 END) AS       
  add_to_cart_count
FROM clique_bait.events AS e
JOIN clique_bait.page_hierarchy AS p ON e.page_id = p.page_id
WHERE p.product_category IS NOT NULL
GROUP BY p.product_category
ORDER BY views_count DESC
~~~~
product_category|	views_count|	add_to_cart_count
| ---------- | ---------- | ---------- |
Shellfish	|6204|	3792
Fish	|4633	|2789
Luxury|	3032	|1870

#### 9.  What are the top 3 products by purchases?
 ~~~~sql
WITH customers_CTE AS(
SELECT
DISTINCT visit_id AS customer
FROM clique_bait.events  
WHERE event_type = 3)

SELECT 
 page_name,
 COUNT(e.page_id) AS product_count
FROM customers_CTE c
JOIN clique_bait.events e ON e.visit_id = c.customer
JOIN clique_bait.page_hierarchy ph ON ph.page_id=e.page_id
WHERE event_type = 2
GROUP BY page_name
ORDER BY product_count DESC
LIMIT 3
~~~~
page_name	|product_count
| ---------- | ---------- |
Lobster|	754
Oyster	|726
Crab	|719


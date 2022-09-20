
<p align="center">
  <img src="https://github.com/David8523/Learning-SQL/blob/main/8%20Week%20SQL%20Challenge/Images/case%201.png?raw=true" /
</p>

# Case Study #1 - Danny's Diner
## 1. Introduction
Danny seriously loves Japanese food so in the beginning of 2021, he decides to embark upon a risky venture and opens up a cute little restaurant that sells his 3 favourite foods: sushi, curry and ramen.

Danny’s Diner is in need of your assistance to help the restaurant stay afloat - the restaurant has captured some very basic data from their few months of operation but have no idea how to use their data to help them run the business.
## 2. Problem Statement
Danny wants to use the data to answer a few simple questions about his customers, especially about their visiting patterns, how much money they’ve spent and also which menu items are their favourite. Having this deeper connection with his customers will help him deliver a better and more personalised experience for his loyal customers.

He plans on using these insights to help him decide whether he should expand the existing customer loyalty program - additionally he needs help to generate some basic datasets so his team can easily inspect the data without needing to use SQL.

Danny has provided you with a sample of his overall customer data due to privacy issues - but he hopes that these examples are enough for you to write fully functioning SQL queries to help him answer his questions!
<p align="center">
  <img src="https://github.com/David8523/Learning-SQL/blob/main/8%20Week%20SQL%20Challenge/Images/1.PNG?raw=true" /
</p>
 
## 3. Case Study Questions
### 1.  What is the total amount each customer spent at the restaurant?
 ~~~~sql
SELECT s.customer_id, SUM(price) AS "Total Spent"
FROM dannys_diner.sales s
JOIN dannys_diner.menu m ON s.product_id = m.product_id
GROUP BY customer_id
ORDER BY customer_id; 
~~~~
| customer_id | Total Spent |
| :-------: | :-------: |
| A | 76 |
| B | 74 |
| C | 36 |

- Customer A spent $76.
- Customer B spent $74.
- Customer C spent $36.

### 2.  How many days has each customer visited the restaurant?
 ~~~~sql
SELECT customer_id, COUNT(DISTINCT(order_date)) AS "Days visited"
FROM dannys_diner.sales
GROUP BY customer_id;
~~~~
| customer_id | visit_count |
| :-------: | :-------: |
| A | 4 |
| B | 6 |
| C | 2 |

- Customer A visited 4 days.
- Customer B visited 6 days.
- Customer C visited 2 days.

### 3.  What was the first item from the menu purchased by each customer?
 ~~~~sql
SELECT DISTINCT(customer_id), product_name 
FROM dannys_diner.sales s
JOIN dannys_diner.menu m ON m.product_id = s.product_id
WHERE s.order_date = ANY (SELECT MIN(order_date) FROM dannys_diner.sales  GROUP BY customer_id)
ORDER by customer_id
~~~~
| customer_id | product_name |
| :-------: | :-------: |
| A | curry |
| A | sushi |
| B | curry |
| C | ramen |

- Customer A's first items were curry and sushi.
- Customer B's first item was curry.
- Customer C's first item was ramen.

### 4.  What is the most purchased item on the menu and how many times was it purchased by all customers?
 ~~~~sql
SELECT product_name, COUNT(sales.product_id)
FROM dannys_diner.sales
JOIN dannys_diner.menu ON menu.product_id = sales.product_id
GROUP BY product_name
LIMIT 1
~~~~
| product_name |   times purchased |
| :-------: | :-------: |
| ramen | 8 |
- The most purchased item is ramen with 8 times purchased.

### 5.  Which item was the most popular for each customer?
 ~~~~sql
SELECT distinct(customer_id), product_name, COUNT(s.product_id)
FROM dannys_diner.sales s
JOIN dannys_diner.menu m ON m.product_id = s.product_id
GROUP BY customer_id, product_name
order by COUNT(s.product_id) desc
limit 3
~~~~
| customer_id | product_name | count |
| :-------: | :-------: | :-------:  |
| A           | ramen        |  3   |
| B           | curry        |  2   |
| C           | ramen        |  3   |

 - Customer A preferred item is  ramen.
- Customer B preferred item is  curry.
- Customer C preferred item is  ramen.

### 6.  Which item was purchased first by the customer after they became a member?
 ~~~~sql
-- create a CTE to see the first order after they become members, using DENSE_RANK to create a new rank column
WITH CTE AS
(SELECT sales.customer_id, menu.product_name, sales.order_date,
DENSE_RANK() OVER (PARTITION BY sales.customer_id ORDER BY sales.order_date) AS ranks
FROM dannys_diner.sales
JOIN dannys_diner.menu ON menu.product_id = sales.product_id
JOIN dannys_diner.members ON members.customer_id = sales.customer_id
WHERE sales.order_date >= members.join_date)
-- Simple Query to sort the info from the CTE table
SELECT customer_id, product_name, order_date
FROM CTE
WHERE ranks = 1
~~~~
| customer_id | product_name  | order_date 
| :-------: | :-------: |:-------:  |
| A           |  curry  |   2021-01-07     |
| B           | sushi |    2021-01-11     |

- Customer A first order was curry.
- Customer B  first order was sushi.
- Customer C nver become a member

### 7.  Which item was purchased just before the customer became a member?
 ~~~~sql
-- Same as before we just change the WHERE Clause to before they become members
WITH CTE AS
(SELECT s.customer_id, m.product_name, s.order_date,
DENSE_RANK() OVER (PARTITION BY s.customer_id ORDER BY s.order_date) AS ranks
FROM dannys_diner.sales s
JOIN dannys_diner.menu m ON m.product_id = s.product_id
JOIN dannys_diner.members mem ON mem.customer_id = s.customer_id
WHERE s.order_date < mem.join_date)
-- Simple Query to sort the info from the CTE table
SELECT customer_id, product_name, order_date
FROM CTE
WHERE ranks = 1
~~~~
| customer_id | product_name  | order_date  |
| :-------: | :-------: |:-------:  |
| A           |  sushi  | 2021-01-01 |
| A           |  curry  | 2021-01-01 |
| B           |  sushi |  2021-01-04 |

- Customer A last order before becoming a member was sushi and curry.
- Customer A  last order before becoming a member was sushi.

### 8.  What is the total items and amount spent for each member before they became a member?
 ~~~~sql
SELECT s.customer_id, count(s.product_id) AS "Total Items", SUM(price) AS "Amount Spent"
FROM dannys_diner.sales s
JOIN dannys_diner.menu m ON m.product_id = s.product_id
JOIN dannys_diner.members mem ON mem.customer_id = s.customer_id
WHERE s.order_date < mem.join_date
GROUP BY s.customer_id
ORDER BY customer_id
~~~~
 
| customer_id | Total Items | Amount Spent |
| :-------: | :-------: | :-------: |
| A           | 2           | 25           |
| B           | 3           | 40           |

- Customer A spent 25$ in 2 items
- Customer B spent 40$ in 3 items

### 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
 ~~~~sql
-- Create a CTE with a CASE  Expression multiplying prices by 2
WITH CTE AS 
(
SELECT *,
  	CASE 
    WHEN m.product_name = 'sushi' THEN price * 20
    WHEN m.product_name != 'sushi' THEN price * 10
    END AS points
FROM dannys_diner.menu m
    )
   -- Simple Query to sort the CTE
SELECT customer_id, SUM(points) AS points
FROM dannys_diner.sales s
JOIN CTE ON CTE.product_id = s.product_id
GROUP BY s.customer_id
ORDER BY s.customer_id
~~~~


| customer_id | points |
| :-------: | :-------: |
| A           | 860    |
| B           | 940    |
| C           | 360    |

- Customer A have 860 points
- Cusotmer B have 940 points
- Customer C have 360 points


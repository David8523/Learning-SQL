# Case Study #4 - Data Bank
## Introduction

There is a new innovation in the financial industry called Neo-Banks: new aged digital only banks without physical branches.

Danny thought that there should be some sort of intersection between these new age banks, cryptocurrency and the data world…so he decides to launch a new initiative - Data Bank!

Data Bank runs just like any other digital bank - but it isn’t only for banking activities, they also have the world’s most secure distributed data storage platform!

Customers are allocated cloud data storage limits which are directly linked to how much money they have in their accounts. There are a few interesting caveats that go with this business model, and this is where the Data Bank team need your help!

The management team at Data Bank want to increase their total customer base - but also need some help tracking just how much data storage their customers will need.

This case study is all about calculating metrics, growth and helping the business analyse their data in a smart way to better forecast and plan for their future developments!

## Available Data

The Data Bank team have prepared a data model for this case study as well as a few example rows from the complete dataset below to get you familiar with their tables.
## Case Study Questions

The following case study questions include some general data exploration analysis for the nodes and transactions before diving right into the core business questions and finishes with a challenging final request!

### A. Customer Nodes Exploration

#### 1.  How many unique nodes are there on the Data Bank system?
~~~~sql
SELECT COUNT(DISTINCT node_id) AS "Number of nodes"
FROM customer_nodes
~~~~
|  Number of nodes
| -------   |
|5
#### 2.  What is the number of nodes per region?
~~~~sql
SELECT region_name, COUNT(node_id) AS "Number of nodes"
FROM customer_nodes c
JOIN regions r ON r.region_id=c.region_id
GROUP BY c.region_id
~~~~
region_name |  Number of nodes
| -------   | -------    |
Australia |  770
America | 735
Africa | 714
Asia | 665
Europe | 616
#### 3.  How many customers are allocated to each region?
~~~~sql
SELECT region_name, COUNT(DISTINCT  customer_id) AS "Number of clients"
FROM customer_nodes c
JOIN regions r ON r.region_id=c.region_id
GROUP BY c.region_id
~~~~
region_name|Number of clients
| -------   | -------    |
Australia|110
America|105
Africa|102
Asia|95
Europe|88
#### 4.  How many days on average are customers reallocated to a different node?
~~~~sql
SELECT round(AVG(datediff(end_date, start_date)), 2) AS "Days on average"
FROM customer_nodes
WHERE end_date!='9999-12-31'
~~~~
|Days on average
| -------   |
|14.63

### B. Customer Transactions

#### 1.  What is the unique count and total amount for each transaction type?
~~~~sql
SELECT txn_type, 
COUNT(customer_id) AS "Unique count",
SUM(txn_amount) AS  "Total amount"
FROM customer_transactions
GROUP BY txn_type
~~~~
txn_type | Unique count | Total amount
| -------   | -------   |-------   |
deposit | 2671  | 1359168
purchase | 1580 |  806537
withdrawal | 1617 |  793003

#### 2.  What is the average total historical deposit counts and amounts for all customers?
~~~~sql
  WITH CTE AS(
 SELECT txn_type,
  COUNT(txn_amount) AS txn_count, 
  AVG(txn_amount) AS avg_amount
  FROM customer_transactions
  GROUP BY customer_id, txn_type)
  
SELECT 
  ROUND(AVG(txn_count),0) AS "Average deposit",
  ROUND(AVG(avg_amount),2) AS "Average amount"
FROM CTE
WHERE txn_type = 'deposit'
~~~~
Average deposit |Average amount
| -------   | ------- 
5 |508.61
#### 3.  For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month?
~~~~sql
WITH monthly_transactions AS (
  SELECT 
    customer_id, 
    Month(txn_date) AS Month,
    SUM(CASE WHEN txn_type = 'deposit' THEN 0 ELSE 1 END) AS deposit_count,
    SUM(CASE WHEN txn_type = 'purchase' THEN 0 ELSE 1 END) AS purchase_count,
    SUM(CASE WHEN txn_type = 'withdrawal' THEN 1 ELSE 0 END) AS withdrawal_count
  FROM customer_transactions
  GROUP BY customer_id, month)

SELECT
  Month,
  COUNT(DISTINCT customer_id) AS "Customer count"
FROM monthly_transactions
WHERE deposit_count >= 2 
  AND (purchase_count > 1 OR withdrawal_count > 1)
GROUP BY month
~~~~
Month | Customer count
| -------   | ------- 
1  | 158
2  | 240
3  | 263
4  | 86


# Case Study #3 - Foodie-Fi
 <p align="center">
  <img src="https://github.com/David8523/Learning-SQL/blob/main/8%20Week%20SQL%20Challenge/Images/Case%203.png" /
</p>
	
## Introduction

Subscription based businesses are super popular and Danny realised that there was a large gap in the market - he wanted to create a new streaming service that only had food related content - something like Netflix but with only cooking shows!

Danny finds a few smart friends to launch his new startup Foodie-Fi in 2020 and started selling monthly and annual subscriptions, giving their customers unlimited on-demand access to exclusive food videos from around the world!

Danny created Foodie-Fi with a data driven mindset and wanted to ensure all future investment decisions and new features were decided using data. This case study focuses on using subscription style digital data to answer important business questions.

## Available Data
Danny has shared the data design for Foodie-Fi and also short descriptions on each of the database tables - our case study focuses on only 2 tables but there will be a challenge to create a new table for the Foodie-Fi team.

All datasets exist within the  `foodie_fi`  database schema - be sure to include this reference within your SQL scripts as you start exploring the data and answering the case study questions.
 <p align="center">
  <img src="https://github.com/David8523/Learning-SQL/blob/main/8%20Week%20SQL%20Challenge/Images/3.PNG" /
</p>

**Important note:** From now on I will use MySQL to solve the practical cases. 
## Case Study
### Data Analysis Questions

#### 1.  How many customers has Foodie-Fi ever had?
~~~~sql
SELECT count(DISTINCT customer_id) AS 'customers'
FROM subscriptions
~~~~
Foodie-Fi had 1000 customers in total
#### 2.  What is the monthly distribution of  `trial`  plan  `start_date`  values for our dataset - use the start of the month as the group by value
~~~~sql
SELECT MONTH(start_date) as "month",
       count(DISTINCT s.customer_id) as "monthly distribution"
FROM subscriptions s
JOIN plans p ON p.plan_id=s.plan_id
WHERE s.plan_id=0
GROUP BY month(start_date)
~~~~
  month | monthly distribution |
| :-------:   | :----:    |
1	 | 88
2|	68
3	|94
4|	81
5|	88
6	|79
7|	89
8	|88
9|	87
10|	79
11|	75
12|	84
#### 3.  What plan  `start_date`  values occur after the year 2020 for our dataset? Show the breakdown by count of events for each  `plan_name`
~~~~sql
SELECT plan_name, count(DISTINCT customer_id) AS "Number of plans"
FROM subscriptions s 
JOIN plans p ON p.plan_id=s.plan_id
WHERE YEAR(start_date) > 2020
GROUP BY s.plan_id
~~~~
 plan_name| Number of plans |
| :-------:   | :----:    |
basic monthly|	8
pro monthly	|60
pro annual|	63
churn	|71

#### 4.  What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
~~~~sql
SELECT count(DISTINCT customer_id) AS "Customers that churned",
 round((count(DISTINCT customer_id) / 
 (SELECT count(DISTINCT customer_id) FROM subscriptions)*100),1) AS 'Churn percentage'
FROM subscriptions
WHERE plan_id = 4
~~~~
 Customers that churned| Churn percentage|
| :-------:   | :----:    |
307  |	30.7

#### 5.  How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
~~~~sql
WITH CTE AS (
SELECT  customer_id,plan_id, 
  ROW_NUMBER() OVER (
    PARTITION BY customer_id 
    ORDER BY plan_id) AS plan_rank 
FROM subscriptions) 

SELECT 
  COUNT(customer_id) AS "Customers that churned",
  ROUND(100 * COUNT(customer_id) / (
    SELECT COUNT(DISTINCT customer_id) FROM subscriptions),1) AS "Churn percentage"
FROM CTE
WHERE plan_id = 4 
  AND plan_rank = 2 
~~~~
 Customers that churned| Churn percentage|
| :-------:   | :----:    |
92  |	9.2

#### 6.  What is the number and percentage of customer plans after their initial free trial?
~~~~sql
 WITH CTE AS(
 SELECT 
  customer_id, 
  plan_id, 
  LEAD(plan_id, 1) OVER(PARTITION BY customer_id 
    ORDER BY plan_id) AS next_plan
FROM subscriptions) 

SELECT next_plan, count(next_plan) AS "Plan count",
	   round(100* count(next_plan)/(
			SELECT COUNT(DISTINCT customer_id) FROM CTE),1) AS "Plan percentage"
FROM CTE
WHERE next_plan IS NOT NULL AND
plan_id = 0
GROUP BY next_plan
~~~~
 next_plan| Plan count| Plan percentage    |
| :-------:   | :----:    | :----:    |	
1	|546	|54.6
2|	325	|32.5
3	|37	|3.7
4|	92	|9.2

#### 7.  What is the customer count and percentage breakdown of all 5  `plan_name`  values at  `2020-12-31`?
~~~~sql
WITH CTE AS(
	SELECT   customer_id, 
  plan_id,
  start_date,
	ROW_NUMBER() OVER
    (PARTITION BY customer_id
	ORDER BY start_date DESC) AS latest_plan
   FROM subscriptions
   WHERE start_date <='2020-12-31' )
   
SELECT plan_id,
       count(customer_id) AS "Customer Count",
       round(100*count(customer_id) /(
            SELECT COUNT(DISTINCT customer_id) FROM subscriptions), 2) AS "Customer percentage"
FROM CTE
WHERE latest_plan = 1
GROUP BY plan_id
ORDER BY plan_id;
~~~~
plan_id	  | Customer Count	  | Customer percentage
| :-------:   | :----:    | :----:    |	
0  | 	19	  | 1.90
1	  | 224  | 	22.40
2  | 	326  | 	32.60
3	  | 195  | 	19.50
4  | 	236	  | 23.60

#### 8.  How many customers have upgraded to an annual plan in 2020?
~~~~sql
SELECT COUNT(DISTINCT customer_id) AS "Customers with an annual plan"
FROM subscriptions
WHERE plan_id = 3
AND start_date <= '2020-12-31'
~~~~
 |	Customers with an annual plan |	
 | :----:    |	
 |	195 |	

#### 9.  How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
~~~~sql
WITH trial_plan AS 
  (SELECT 
    customer_id, 
    start_date AS trial_date
  FROM subscriptions
  WHERE plan_id = 0),

annual_plan AS
  (SELECT 
    customer_id, 
    start_date AS annual_date
  FROM subscriptions
  WHERE plan_id = 3)

SELECT 
  ROUND(AVG(datediff(annual_date,trial_date)),0) AS "Days on average"
FROM trial_plan t
JOIN annual_plan a
  ON t.customer_id = a.customer_id
~~~~
 |Days on average
 | :----:    |	
 |105




# Case Study #2 - Pizza Runner
<p align="center">
  <img src="https://github.com/David8523/Learning-SQL/blob/main/8%20Week%20SQL%20Challenge/Images/Case%202.png" /
</p>
	
## 1. Introduction

Did you know that over  **115 million kilograms**  of pizza is consumed daily worldwide??? (Well according to Wikipedia anyway…)

Danny was scrolling through his Instagram feed when something really caught his eye - “80s Retro Styling and Pizza Is The Future!”

Danny was sold on the idea, but he knew that pizza alone was not going to help him get seed funding to expand his new Pizza Empire - so he had one more genius idea to combine with it - he was going to  _Uberize_  it - and so Pizza Runner was launched!

Danny started by recruiting “runners” to deliver fresh pizza from Pizza Runner Headquarters (otherwise known as Danny’s house) and also maxed out his credit card to pay freelance developers to build a mobile app to accept orders from customers.

## 2. Available Data

Because Danny had a few years of experience as a data scientist - he was very aware that data collection was going to be critical for his business’ growth.

He has prepared for us an entity relationship diagram of his database design but requires further assistance to clean his data and apply some basic calculations so he can better direct his runners and optimise Pizza Runner’s operations.

All datasets exist within the  `pizza_runner`  database schema - be sure to include this reference within your SQL scripts as you start exploring the data and answering the case study questions.
	
<p align="center">
  <img src="https://github.com/David8523/Learning-SQL/blob/main/8%20Week%20SQL%20Challenge/Images/1.PNG" /
</p>
	
## 3. Data Cleaning
### customer_orders
Clean the null values in the `exclusions`and `extras`columns in the table
~~~~sql
CREATE TEMP TABLE customer_orders_clean AS
SELECT order_id,
       customer_id,
       pizza_id,
       CASE(
           WHEN exclusions = '' THEN NULL
           WHEN exclusions = 'null' THEN NULL
           ELSE exclusions
       END) AS exclusions,
       CASE(
           WHEN extras = '' THEN NULL
           WHEN extras = 'null' THEN NULL
           ELSE extras
       END) AS extras,
       order_time
FROM customer_orders;
~~~~
### runner_orders
In `distance`and `duration` columns remove the measure unites and clean the nulls values.
In `pickup_time`and`cancellation`  clean the nulls values
 ~~~~sql
CREATE TEMP TABLE runner_orders_clean AS
SELECT order_id,
       runner_id,
       CASE(
           WHEN pickup_time LIKE 'null' THEN NULL
           ELSE pickup_time
       END) AS pickup_time,
       CASE(
           WHEN distance LIKE 'null' THEN NULL
           WHEN distance LIKE '%km' THEN TRIM('km' from distance)
       END) AS distance,
       CASE(
           WHEN duration LIKE 'null' THEN NULL
	       WHEN duration LIKE '%mins' THEN TRIM('mins' from duration)  
			  WHEN duration LIKE '%minute' THEN TRIM('minute' from duration)  
			  WHEN duration LIKE '%minutes' THEN TRIM('minutes' from duration)
       END) AS duration,
       CASE(
           WHEN cancellation LIKE '' THEN NULL
           WHEN cancellation LIKE 'null' THEN NULL
           ELSE cancellation
       END) AS cancellation
FROM runner_orders;
~~~~
## 4. Case Study Questions
### Pizza Metrics
#### 1.  How many pizzas were ordered?
 ~~~~sql
SELECT COUNT(pizza_id) AS "pizza orders"
FROM pizza_runner.customer_orders
~~~~
-   They were **14 pizzas ordered **.
#### 2.  How many unique customer orders were made?
 ~~~~sql
SELECT COUNT(DISTINCT order_id) AS "Customer orders"
FROM pizza_runner.runner_orders_clean
~~~~
They were **10 unique orders**
#### 3.  How many successful orders were delivered by each runner?
 ~~~~sql
SELECT runner_id, COUNT(order_id) AS "Successful Orders"
FROM pizza_runner.runner_orders_clean 
WHERE cancellation IS NULL
GROUP BY runner_id
~~~~
 runner_id | Successful Orders |
| :-------:   | :----:    |
 1 | 4 |
 2 | 3 |
 3 | 1 |
 - Runner  1 have 4 Successful Orders
 - Runner 2 have 3 Successful Orders
 - Runner 3 have 1 Successful Orders
#### 4.  How many of each type of pizza was delivered?
 ~~~~sql
SELECT p.pizza_id, p.pizza_name, count(c.pizza_id) AS 'Pizzas Delivered'
 FROM pizza_runner.customer_orders_clean c
JOIN pizza_runner.runner_orders_clean r ON r.order_id = c.order_id
JOIN pizza_runner.pizza_names p ON p.pizza_id = c.pizza_id
WHERE cancellation IS NULL
GROUP BY p.pizza_id
~~~~
 pizza_id | pizza_name | Pizzas Delivered |  
| :-------:   | :----:    | :----:    
 1 | Meatlovers | 9
 2 | Vegetarian | 3

- They were **9 meatlovers pizzas** delivered
- They were **3 Vegetarian pizzas** delivered
#### 5.  How many Vegetarian and Meatlovers were ordered by each customer?
 ~~~~sql
SELECT c.customer_id, p.pizza_name, COUNT(p.pizza_id) AS "Pizzas Ordered"
 FROM pizza_runner.customer_orders_clean c
JOIN  pizza_runner.pizza_names AS p  ON p.pizza_id= c.pizza_id  
GROUP BY c.customer_id, p.pizza_name
ORDER BY c.customer_id
~~~~

| customer_id | pizza_name | Pizzas Ordered |
| :-------: | :-------: | :-------: |
| 101         | Meatlovers | 2              |
| 101         | Vegetarian | 1              |
| 102         | Meatlovers | 2              |
| 102         | Vegetarian | 1              |
| 103         | Meatlovers | 3              |
| 103         | Vegetarian | 1              |
| 104         | Meatlovers | 3              |
| 105         | Vegetarian | 1              |

- Customer 101 ordered 2 Meatlovers and 1 Vegetarian pizzas.
- Customer 102 ordered 2 Meatlovers and 1 Vegetarian pizzas.
- Customer 103 ordered 3 Meatlovers and 1 Vegetarian pizzas.
 - Customer 104 ordered 3 Meatlovers  pizzas.
- Customer  105 ordered 1 Vegetarian pizza.
#### 6.  What was the maximum number of pizzas delivered in a single order?
 ~~~~sql
SELECT customer_id, order_id, count(order_id) AS "Pizzas delivered"
FROM pizza_runner.customer_orders_clean
GROUP BY customer_id, order_id
ORDER BY "Pizzas delivered" DESC
LIMIT 1
~~~~
| customer_id | order_id | Pizzas delivered |
| :-------: | :-------: | :-------: |
| 103         | 4        | 3                |

#### 7.  For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
 ~~~~sql
SELECT c.customer_id,  
		  SUM(CASE( 
		           WHEN (exclusions IS NOT NULL
                      OR extras IS NOT NULL) THEN 1
                ELSE 0
           END)) AS "1 change atleast"
       SUM(CASE( 
                WHEN (exclusions IS NULL
                     AND extras IS NULL) THEN 1
                ELSE 0  
           END)) AS "No changes" 
FROM pizza_runner.customer_orders_clean c  
JOIN pizza_runner.runner_orders_clean r  ON r.order_id = c.order_id  
WHERE cancellation IS NULL
GROUP BY customer_id
ORDER BY customer_id
~~~~
| customer_id | 1 change atleast | No changes |
| :-------: | :-------: | :-------: |
| 101 | 0 | 2 |
| 102 | 0 | 3 |
| 103 | 3 | 0 |
| 104 | 2 | 1 |
| 105 | 1 | 0 |
#### 8.  How many pizzas were delivered that had both exclusions and extras?
 ~~~~sql
SELECT customer_id,
       SUM(CASE
               WHEN (exclusions IS NOT NULL
                     AND extras IS NOT NULL) THEN 1
               ELSE 0
           END) AS "Exclusions and extras"
FROM pizza_runner.customer_orders_clean c  
JOIN pizza_runner.runner_orders_clean r  ON r.order_id = c.order_id  
WHERE cancellation IS NULL
GROUP BY customer_id
ORDER BY customer_id
~~~~
 customer_id | Exclusions and extras |
| :-------:   | :----:    |
 101 | 0 |
 102 | 0 |
 103 | 0 |
 104 | 1 |
 105 | 0 |
#### 9.  What was the total volume of pizzas ordered for each hour of the day?
 ~~~~sql
SELECT DATE_PART('HOUR', (order_time)) AS "hour", 
 COUNT(order_id) AS pizza_count
FROM pizza_runner.customer_orders_clean
GROUP BY hour
ORDER BY hour
~~~~
| hour | pizza_count |
| ---- | ----------- |
| 11   | 1           |
| 13   | 3           |
| 18   | 3           |
| 19   | 1           |
| 21   | 3           |
| 23   | 3           |

#### 10.  What was the volume of orders for each day of the week?
 ~~~~sql
SELECT to_char((order_time), 'Day') AS "day", 
COUNT(order_id) AS pizza_count
FROM pizza_runner.customer_orders_clean
GROUP BY day
ORDER BY day desc
~~~~
| day       | pizza_count |
| --------- | ----------- |
| Saturday  | 5           |
| Wednesday | 5           |
| Thursday  | 3           |
| Friday    | 1           |

### Runner and Customer Experience

#### 1.  How many runners signed up for each 1 week period? (i.e. week starts  `2021-01-01`)
 ~~~~sql
SELECT DATE_PART('WEEK', registration_date) AS "Week of registration",
COUNT(runner_id) AS "Runners signed"
FROM pizza_runner.runners
GROUP BY "Week of registration"
~~~~
| Week of registration | Runners signed |
| -------------------- | -------------- |
| 53                   | 2              |
| 1                    | 1              |
| 2                    | 1              |

#### 4.  What was the average distance travelled for each customer?
 ~~~~sql
SELECT c.customer_id, round(avg(r.distance), 2) AS "average distance"
FROM pizza_runner.runner_orders_clean r
JOIN pizza_runner.customer_orders_clean c on c.order_id = r.order_id
WHERE cancellation IS NULL
GROUP BY customer_id
~~~~
| customer_id | average distance |
| -------------------- | -------------- |
| 101                   | 20              |
| 102                   | 16,73           |
| 103                   | 23,4            |
| 104                   | 10              |
| 104                   | 25              |


#### 5.  What was the difference between the longest and shortest delivery times for all orders?
 ~~~~sql
SELECT MIN(duration) AS "minimum duration",
        MAX(duration) AS "maximum duration",
        MAX(duration) - MIN(duration) AS "maximum difference"
FROM pizza_runner.runner_orders_clean
~~~~
The minimun duration was 10 minutes and the maximu duration 40 minutes. Being the difference 30 mins
#### 6.  What was the average speed for each runner for each delivery and do you notice any trend for these values?
 ~~~~sql
SELECT runner_id, order_id, distance,
       round(duration/60, 2) AS "hours",
       round(distance*60/duration, 2) AS "average km per hour"
FROM pizza_runner.runner_orders_clean 
WHERE cancellation IS NULL
ORDER BY runner_id;
~~~~
| runner_id | order_id | distance| hours| average km per hour |
| -------------------- | -------------- | -------------- | -------------- | -------------- |
| 1 | 1 | 20 | 0.53 | 37.5 |
| 1 | 2 | 20 | 0.45 | 44.44 |
| 1 | 3 | 13,4 | 0.33 | 40.2 |
| 1 | 10 | 10 | 0.17 | 60 |
| 2 | 4 | 23,4 | 0.67 | 35.1 |
| 2 | 7 | 25 | 0.42 | 60 |
| 2 | 8 | 23,4 | 0.25 | 93.6 |
| 3 | 5 | 10 | 0.25 | 40 |


#### 7.  What is the successful delivery percentage for each runner?
 ~~~~sql
SELECT runner_id,
       COUNT(pickup_time) AS "delivered orders",
       COUNT(order_id) AS "total orders",
       ROUND(100 * COUNT(pickup_time) / COUNT(order_id)) AS "successful delivery percentage"
FROM pizza_runner.runner_orders
GROUP BY runner_id
ORDER BY runner_id;
~~~~

| runner_id | delivered orders | total orders | successful delivery percentage |
| --------- | ---------------- | ------------ | ------------------------------ |
| 1         | 4                | 4            | 100                            |
| 2         | 3                | 4            | 75                            |
| 3         | 1                | 2            | 50                            |



# Case Study #2 - Pizza Runner
## 1. Introduction

Did you know that over  **115 million kilograms**  of pizza is consumed daily worldwide??? (Well according to Wikipedia anyway…)

Danny was scrolling through his Instagram feed when something really caught his eye - “80s Retro Styling and Pizza Is The Future!”

Danny was sold on the idea, but he knew that pizza alone was not going to help him get seed funding to expand his new Pizza Empire - so he had one more genius idea to combine with it - he was going to  _Uberize_  it - and so Pizza Runner was launched!

Danny started by recruiting “runners” to deliver fresh pizza from Pizza Runner Headquarters (otherwise known as Danny’s house) and also maxed out his credit card to pay freelance developers to build a mobile app to accept orders from customers.

## 2. Available Data

Because Danny had a few years of experience as a data scientist - he was very aware that data collection was going to be critical for his business’ growth.

He has prepared for us an entity relationship diagram of his database design but requires further assistance to clean his data and apply some basic calculations so he can better direct his runners and optimise Pizza Runner’s operations.

All datasets exist within the  `pizza_runner`  database schema - be sure to include this reference within your SQL scripts as you start exploring the data and answering the case study questions.
## 3. Case Study Questions
### Pizza Metrics
#### 1.  How many pizzas were ordered?
 ~~~~sql
SELECT COUNT(pizza_id) AS "pizza orders"
FROM pizza_runner.customer_orders
~~~~

#### 2.  How many unique customer orders were made?
 ~~~~sql

~~~~
#### 3.  How many successful orders were delivered by each runner?
 ~~~~sql

~~~~
#### 4.  How many of each type of pizza was delivered?
 ~~~~sql

~~~~
#### 5.  How many Vegetarian and Meatlovers were ordered by each customer?
 ~~~~sql

~~~~
#### 6.  What was the maximum number of pizzas delivered in a single order?
 ~~~~sql

~~~~
#### 7.  For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
 ~~~~sql

~~~~
#### 8.  How many pizzas were delivered that had both exclusions and extras?
 ~~~~sql

~~~~
#### 9.  What was the total volume of pizzas ordered for each hour of the day?
 ~~~~sql

~~~~
#### 10.  What was the volume of orders for each day of the week?
 ~~~~sql

~~~~
### Runner and Customer Experience
#### 1.  How many runners signed up for each 1 week period? (i.e. week starts  `2021-01-01`)
 ~~~~sql

~~~~
#### 2.  What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
 ~~~~sql

~~~~
#### 3.  Is there any relationship between the number of pizzas and how long the order takes to prepare?
 ~~~~sql

~~~~
#### 4.  What was the average distance travelled for each customer?
 ~~~~sql

~~~~
#### 5.  What was the difference between the longest and shortest delivery times for all orders?
 ~~~~sql

~~~~
#### 6.  What was the average speed for each runner for each delivery and do you notice any trend for these values?
 ~~~~sql

~~~~
#### 7.  What is the successful delivery percentage for each runner?
 ~~~~sql

~~~~
### Ingredient Optimisation
#### 1.  What are the standard ingredients for each pizza?
 ~~~~sql

~~~~
#### 2.  What was the most commonly added extra?
 ~~~~sql

~~~~
#### 3.  What was the most common exclusion?
 ~~~~sql

~~~~
#### 4.  What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?
 ~~~~sql

~~~~
### Pricing and Ratings
#### 1.  If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
 ~~~~sql

~~~~
#### 2.  What if there was an additional $1 charge for any pizza extras? Add cheese is $1 extra
 ~~~~sql

~~~~
#### 3.  The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
 ~~~~sql

~~~~

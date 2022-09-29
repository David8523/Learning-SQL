# Case Study #5 - Data Mart
## Introduction

Data Mart is Danny’s latest venture and after running international operations for his online supermarket that specialises in fresh produce - Danny is asking for your support to analyse his sales performance.

In June 2020 - large scale supply changes were made at Data Mart. All Data Mart products now use sustainable packaging methods in every single step from the farm all the way to the customer.

Danny needs your help to quantify the impact of this change on the sales performance for Data Mart and it’s separate business areas.

The key business question he wants you to help him answer are the following:

-   What was the quantifiable impact of the changes introduced in June 2020?
-   Which platform, region, segment and customer types were the most impacted by this change?
-   What can we do about future introduction of similar sustainability updates to the business to minimise impact on sales?

## Available Data

For this case study there is only a single table:  `data_mart.weekly_sales`

The  `Entity Relationship Diagram`  is shown below with the data types made clear, please note that there is only this one table - hence why it looks a little bit lonely!
## Case Study Questions

The following case study questions require some data cleaning steps before we start to unpack Danny’s key business questions in more depth.

### 1. Data Cleansing Steps

In a single query, perform the following operations and generate a new table in the  `data_mart`  schema named  `clean_weekly_sales`:

-   Convert the  `week_date`  to a  `DATE`  format
    
-   Add a  `week_number`  as the second column for each  `week_date`  value, for example any value from the 1st of January to 7th of January will be 1, 8th to 14th will be 2 etc
    
-   Add a  `month_number`  with the calendar month for each  `week_date`  value as the 3rd column
    
-   Add a  `calendar_year`  column as the 4th column containing either 2018, 2019 or 2020 values
    
-   Add a new column called  `age_band`  after the original  `segment`  column using the following mapping on the number inside the  `segment`  value
-   Add a new  `demographic`  column using the following mapping for the first letter in the  `segment`  values:

-   Ensure all  `null`  string values with an  `"unknown"`  string value in the original  `segment`  column as well as the new  `age_band`  and  `demographic`  columns
    
-   Generate a new  `avg_transaction`  column as the  `sales`  value divided by  `transactions`  rounded to 2 decimal places for each record

 ~~~~sql
CREATE TEMPORARY TABLE clean1_weekly_sales (
SELECT *,
  STR_TO_DATE(week_date, '%d/%m/%y') AS week_date1
FROM weekly_sales);

CREATE TEMPORARY TABLE clean_weekly_sales (
SELECT
  week_date1 AS week_date,
  WEEK(week_date1) AS week_number,
  MONTH(week_date1) AS month_number,
  YEAR(week_date1) AS calendar_year,
  region, 
  platform, 
  segment,
  CASE 
  	WHEN segment LIKE '%1' THEN 'Young Adults'
    WHEN segment LIKE '%2' THEN 'Middle Aged'
    WHEN  segment LIKE '%3' THEN 'Retirees'
    WHEN segment LIKE '%4' THEN 'Retirees'
    ELSE 'Unknown' END AS age_band,
  CASE 
  	WHEN segment LIKE 'C%' THEN 'Couples'
    WHEN segment LIKE 'F%' THEN 'Families'
    ELSE 'Unknown' END AS demographic,
  transactions,
  sales,
  ROUND(sales/transactions,2) AS avg_transaction 
FROM clean1_weekly_sales)
 
SELECT *
FROM clean_weekly_sales
LIMIT 5
~~~~
Only the first 5 rows are shown to ensure that the format is clean and organized.
| week_date  | week_number | month_number | calendar_year | region | platform | segment | age_band     | demographic | transactions | sales    | avg_transaction |
| ---------- | ----------- | ------------ | ------------- | ------ | -------- | ------- | ------------ | ----------- | ------------ | -------- | --------------- |
| 2020-08-31 | 35          | 8            | 2020          | ASIA   | Retail   | C3      | Retirees     | Couples     | 120631       | 3656163  | 30.31           |
| 2020-08-31 | 35          | 8            | 2020          | ASIA   | Retail   | F1      | Young Adults | Families    | 31574        | 996575   | 31.56           |
| 2020-08-31 | 35          | 8            | 2020          | USA    | Retail   | null    | Unknown      | Unknown     | 529151       | 16509610 | 31.20           |
| 2020-08-31 | 35          | 8            | 2020          | EUROPE | Retail   | C1      | Young Adults | Couples     | 4517         | 141942   | 31.42           |
| 2020-08-31 | 35          | 8            | 2020          | AFRICA | Retail   | C2      | Middle Aged  | Couples     | 58046        | 1758388  | 30.29           |

### Data Exploration

#### 1.  What day of the week is used for each  `week_date`  value?

The oldest data we obtain is from 2018-03-26. The `WEEK()` function of MySQL the option to choose which day of the week starts is optional. In this case, not having added the parameter in the function will be the day that begins 2018, meaning January 1.

Being that day Monday

#### 2.  What range of week numbers are missing from the dataset?
~~~~sql
SELECT COUNT(DISTINCT week_number) AS week_count,
(52 - COUNT(DISTINCT week_number)) AS weeks_missing
FROM clean_weekly_sales
~~~~
week_count |weeks_missing
| ---------- | ----------- |
24  |28
#### 3.  How many total transactions were there for each year in the dataset?
~~~~sql
SELECT 
  calendar_year, 
  SUM(transactions) AS "Total transactions"
FROM clean_weekly_sales
GROUP BY calendar_year
ORDER BY calendar_year
~~~~
calendar_year |Total transactions
| ---------- | ----------- |
2018| 346406460
2019| 365639285
2020 |375813651

#### 4.  What is the total sales for each region for each month?
~~~~sql
SELECT 
  region, 
  month_number, 
  SUM(sales) AS "Total sales"
FROM clean_weekly_sales
GROUP BY region, month_number
ORDER BY region, month_number;
~~~~

#### 5.  What is the total count of transactions for each platform
~~~~sql
SELECT 
  platform, 
  SUM(transactions) AS total_transactions
FROM clean_weekly_sales
GROUP BY platform
ORDER BY platform;
~~~~
platform | total_transactions
| ---------- | ----------- |
Retail |1081934227
Shopify |5925169

#### 6.  What is the percentage of sales for Retail vs Shopify for each month?
~~~~sql
WITH transactions_cte AS (
  SELECT 
    calendar_year, 
    month_number, 
    platform, 
    SUM(sales) AS monthly_sales
  FROM clean_weekly_sales
  GROUP BY calendar_year, month_number, platform
)

SELECT 
  calendar_year, 
  month_number, 
  ROUND(100 * MAX 
    (CASE WHEN platform = 'Retail' THEN monthly_sales ELSE NULL END) / 
      SUM(monthly_sales),2) AS retail_percentage,
  ROUND(100 * MAX 
    (CASE WHEN platform = 'Shopify' THEN monthly_sales ELSE NULL END) / 
      SUM(monthly_sales),2) AS shopify_percentage
  FROM transactions_cte
  GROUP BY calendar_year, month_number
  ORDER BY calendar_year, month_number;
~~~~
#### 7.  What is the percentage of sales by demographic for each year in the dataset?
~~~~sql
WITH demographic_sales AS (
  SELECT 
    calendar_year, 
    demographic, 
    SUM(sales) AS yearly_sales
  FROM clean_weekly_sales
  GROUP BY calendar_year, demographic
)

SELECT 
  calendar_year, 
  ROUND(100 * MAX 
    (CASE WHEN demographic = 'Couples' THEN yearly_sales ELSE NULL END) / 
      SUM(yearly_sales),2) AS couples_percentage,
  ROUND(100 * MAX 
    (CASE WHEN demographic = 'Families' THEN yearly_sales ELSE NULL END) / 
      SUM(yearly_sales),2) AS families_percentage,
  ROUND(100 * MAX 
    (CASE WHEN demographic = 'unknown' THEN yearly_sales ELSE NULL END) / 
      SUM(yearly_sales),2) AS unknown_percentage
FROM demographic_sales
GROUP BY calendar_year
ORDER BY calendar_year;
~~~~
#### 8.  Which  `age_band`  and  `demographic`  values contribute the most to Retail sales?
~~~~sql
SELECT 
  age_band, 
  demographic, 
  SUM(sales) AS retail_sales,
  ROUND(100 * SUM(sales)::NUMERIC / SUM(SUM(sales)) OVER (),2) AS contribution_percentage
FROM clean_weekly_sales
WHERE platform = 'Retail'
GROUP BY age_band, demographic
ORDER BY retail_sales DESC;
~~~~
#### 9.  Can we use the  `avg_transaction`  column to find the average transaction size for each year for Retail vs Shopify? If not - how would you calculate it instead?
~~~~sql
SELECT 
  calendar_year, 
  platform, 
  ROUND(AVG(avg_transaction),0) AS avg_transaction_row, 
  SUM(sales) / sum(transactions) AS avg_transaction_group
FROM clean_weekly_sales
GROUP BY calendar_year, platform
ORDER BY calendar_year, platform;
~~~~

-- -------------------------------------------------------------------------------------------
-- ---- Feature Engineering---- --

-- time_of_day --

SELECT
time,
(CASE
WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
ELSE "Evening"
END
) AS time_of_say
FROM walmart.sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (
CASE
WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
ELSE "Evening"
END);

-- day_name --
SELECT date, dayname(Date) AS day_name
FROM sales;

ALTER TABLE sales ADD COLUMN day_name varchar(10); 

UPDATE sales
SET day_name = dayname(Date);


-- month_name --

SELECT date, monthname(Date) AS month_name
FROM sales;

ALTER TABLE sales ADD COLUMN month_name varchar(10);

UPDATE sales
SET month_name = monthname(Date);


-- ----------------------------------------------------------------------------------------------
-- ---- Generic ---- --

-- 01 : How many unique cities does the data have?
SELECT DISTINCT city from sales;

-- 02 : In which city is each branch?
SELECT DISTINCT branch, city from sales;

-- -----------------------------------------------------------------------------------------------
-- ---- Product queries ---- --

-- 01 : How many unique product lines does the data have?
SELECT COUNT(DISTINCT product_line) from sales;

-- 02 : What is the most common payment method?
SELECT payment,count(payment) as count 
from sales group by payment 
order by count desc limit 1;

-- 03 : What is the most selling product line?
SELECT product_line, count(product_line) as count
FROM sales GROUP BY product_line
ORDER BY count DESC LIMIT 5;

-- 04 : What is the total revenue by month?
SELECT month_name AS month,
round(sum(total), 2) as revenue
from sales GROUP BY month
ORDER BY revenue DESC;

-- 05 : What month had the largest COGS?
SELECT month_name as month,
round(sum(cogs), 2) as max_cogs
FROM sales GROUP BY month
ORDER BY max_cogs DESC;

-- 06 : What product line had the largest revenue?
SELECT product_line,
round(sum(total), 2) as max_revenue
FROM sales GROUP BY product_line
ORDER BY max_revenue  DESC;

-- 07 : What is the city with largest revenue?
SELECT city,
round(sum(total), 2) as max_rev
FROM sales GROUP BY city
ORDER BY max_rev DESC;

-- 08 : What product line had the largest VAT?
SELECT product_line,
round(avg(VAT),2) as avg_vat
FROM sales GROUP BY product_line
ORDER BY avg_vat DESC;


-- 09 : Which branch sold more products than average product sold?
SELECT branch , 
SUM(quantity) as qty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity)FROM sales)
ORDER BY qty DESC;

-- 10 : What is the most common product line by Gender?
SELECT Count(Gender) AS Gender_cnt, Gender, product_line
FROM sales
GROUP BY gender, product_line
ORDER BY gender_cnt DESC;

-- 11 : What is the average rating of each product line?
SELECT product_line, round(avg(rating),1) AS avg_rating
FROM sales
GROUP BY product_line
order by avg_rating DESC;

-- ---------------------------------------------------------------------------------
-- ---- Sales ---- --

-- 01 : Number of sales made in each time of the day per weekday?
SELECT day_name,time_of_day,
count(total) as total_sales
FROM sales
GROUP BY time_of_day,day_name
ORDER BY total_sales;
                           -- OR --
SELECT time_of_day,
count(total) as total_sales
FROM sales
WHERE day_name = "Monday"
GROUP BY time_of_day
ORDER BY total_sales;

-- 02 : Which of the customer types brings the most revenue?
SELECT customer_type,
round(sum(total),2) as max_rev
FROM walmart.sales
GROUP BY customer_type
ORDER BY max_rev DESC;

-- 03 : Which city has the largest tax percent/VAT(Value added Tax)
SELECT city,
round(sum(VAT),2) AS max_vat
FROM sales
GROUP BY city
ORDER BY max_vat DESC;

-- 04 : Which customer type pays most in VAT?
SELECT customer_type,
round(sum(VAT),2) AS max_vat
FROM sales
GROUP BY customer_type
ORDER BY max_vat DESC;

-- ---------------------------------------------------------------------------------
-- ---- Customer ---- --

-- 01 : How many unique customer types does the data have?
SELECT DISTINCT customer_type
FROM sales;

-- 02 : How many uniquie payment methods does the data have?
SELECT DISTINCT payment
FROM sales;

-- 03 : What is the most common customer type?
SELECT customer_type,
count(customer_type) as count
FROM sales
GROUP BY customer_type
ORDER BY count DESC;

-- 04 : Which customer_type buys the most?
SELECT customer_type,
count(*) AS max_buy
FROM sales
GROUP BY customer_type
ORDER BY max_buy DESC;

-- 05 : What is the gender of most of the customer?
SELECT gender,
count(gender) as count
FROM sales
GROUP BY gender
ORDER BY count DESC;

-- 06 : What is the gender distribution per branch?
SELECT branch,gender,
count(gender) as gender_count
FROM sales
GROUP BY gender,branch
ORDER BY branch;


-- 07 : Which time of the day do customers give most best avg ratings?
SELECT time_of_day,
Round(avg(rating),2) AS ratings
FROM sales
GROUP BY time_of_day
ORDER BY ratings DESC ;


-- 08 : Which time of the day do customers give most best avg ratings per branch?
SELECT branch,time_of_day,
round(avg(rating),2) as rating
FROM sales
GROUP BY branch, time_of_day
ORDER by branch, rating DESC;

-- 09 : Which day of the week has the best avg rating?
SELECT day_name,
round(AVG(rating),2) as avg_rating
FROM sales
GROUP BY day_name
ORDER BY avg_rating DESC LIMIT 1;

-- 10 : Which day of the week has the best average rating per branch?
SELECT branch, day_name,
round(avg(rating),2) as avg_rating 
FROM sales
GROUP BY branch,day_name
ORDER BY avg_rating DESC LIMIT 3;

-- ------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------
-- ---------------THANK YOU-------------- --


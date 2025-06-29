--SQL Retail Sales Analysis -P1
--CREATE TABLE
DROP TABLE IF exists retail_sales;CREATE TABLE retail_sales
             (
                          transactions_id INT PRIMARY KEY,
                          sale_date       DATE,
                          sale_time       TIME,
                          customer_id     INT,
                          gender          VARCHAR(15),
                          age             INT,
                          category        VARCHAR(15),
                          quantiy         INT,
                          price_per_unit FLOAT,
                          cogs FLOAT,
                          total_sale FLOAT
             )
select *
FROM   retail_sales limit 10;

SELECT Count(*)
FROM   retail_sales limit 10;

--DATA CLEANING
SELECT *
FROM   retail_sales
WHERE  transactions_id IS NULL ;

SELECT *
FROM   retail_sales
WHERE  sale_date IS NULL ;

SELECT *
FROM   retail_sales
WHERE  sale_time IS NULL ;

SELECT *
FROM   retail_sales
WHERE  customer_id IS NULL ;

SELECT *
FROM   retail_sales
WHERE  gender IS NULL ;

SELECT *
FROM   retail_sales
WHERE  age IS NULL ;

SELECT *
FROM   retail_sales
WHERE  category IS NULL ;

SELECT *
FROM   retail_sales
WHERE  quantity IS NULL ;

SELECT *
FROM   retail_sales
WHERE  price_per_unit IS NULL ;

SELECT *
FROM   retail_sales
WHERE  cogs IS NULL ;

SELECT *
FROM   retail_sales
WHERE  total_sale IS NULL ;

DELETE
FROM   retail_sales
WHERE  transactions_id IS NULL
OR     sale_date IS NULL
OR     sale_time IS NULL
OR     gender IS NULL
OR     category IS NULL
OR     quantity IS NULL
OR     cogs IS NULL
OR     total_sale IS NULL;

--DATA EXPLORATION
--Have many sales we have?
SELECT Count(*) AS total_sale
FROM   retail_sales;

--How many unique customers we have?

SELECT Count(DISTINCT customer_id) AS total_sale
FROM   retail_sales;

--How many unique categories we have?
SELECT DISTINCT category
FROM retail_sales;

--DATA ANALYSIS & BUSINESS KEY PROBLEMS & ANSWERS
-- My Analysis & Findings
-- Q1. Write a SQL query to retrieve all columns for sales made on '2022-11-05'.
-- Q2. Write a SQL query to retrieve all transactions where the category is 'Clothing'
--      and the quantity sold is more than 4 during November 2022.
-- Q3. Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q5. Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q7. Write a SQL query to calculate the average sale for each month. Also, find the best-selling month in each year.
-- Q8. Write a SQL query to find the top 5 customers based on the highest total sales.
-- Q9. Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q10. Write a SQL query to create a shift column based on order time, and count the number of orders per shift.
--       (Example: Morning <= 12, Afternoon BETWEEN 12 AND 17, Evening > 17)
-------------------------------------------------------------------------------SELECT *
FROM   retail_sales;

-- Q1. Write a SQL query to retrieve all columns for sales made on '2022-11-05'.

SELECT *
FROM   retail_sales
WHERE  sale_date='2022-11-05';

-- Q2. Write a SQL query to retrieve all transactions where the category is 'Clothing'
--      and the quantity sold is more than 4 during November 2022.
SELECT *
FROM   retail_sales
WHERE  category='Clothing'
AND    To_char(sale_date,'YYYY-MM')='2022-11'
AND    quantity>=4 ;

-- Q3. Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT   category,
         SUM(total_sale) AS net_sale,
         Count(*)        AS total_orders
FROM     retail_sales
GROUP BY category;

-- Q4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT Round(Avg(age),2) AS avg_age
FROM   retail_sales
WHERE  category='Beauty' ;

-- Q5. Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT *
FROM   retail_sales
WHERE  total_sale>1000;

-- Q6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT   category,
         gender,
         Count(*) AS total_transactions
FROM     retail_sales
GROUP BY 1,
         2
ORDER BY 1;

-- Q7. Write a SQL query to calculate the average sale for each month. Also, find the best-selling month in each year.
SELECT year,
       month,
       avg_sale
FROM   (
                SELECT   Extract(year FROM sale_date)                                                          AS YEAR,
                         Extract(month FROM sale_date)                                                         AS MONTH,
                         Avg(total_sale)                                                                       AS avg_sale,
                         Rank() over(PARTITION BY Extract(year FROM sale_date) ORDER BY Avg(total_sale) DESC ) AS rank
                FROM     retail_sales
                GROUP BY 1,
                         2) AS t1
WHERE  rank=1;

-- Q8. Write a SQL query to find the top 5 customers based on the highest total sales.
SELECT   customer_id,
         SUM(total_sale) AS total_sales
FROM     retail_sales
GROUP BY 1
ORDER BY 2 DESC limit 5;

-- Q9. Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT   category,
         Count(DISTINCT customer_id) AS cnt_unique_cs
FROM     retail_sales
GROUP BY category ;

-- Q10. Write a SQL query to create a shift column based on order time, and count the number of orders per shift.
--       (Example: Morning <= 12, Afternoon BETWEEN 12 AND 17, Evening > 17)
WITH hourly_sale AS
(
       SELECT *,
              CASE
                     WHEN Extract(hour FROM sale_time) <12 THEN 'Morning'
                     WHEN Extract(hour FROM sale_time) BETWEEN 12 AND    17 THEN 'Afternoon'
                     ELSE 'Evening'
              END AS shift
       FROM   retail_sales )
SELECT   shift,
         Count(*) AS total_orders
FROM     hourly_sale
GROUP BY shift
         --END OF PROJECT
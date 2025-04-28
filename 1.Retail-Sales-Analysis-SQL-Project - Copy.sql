create database sql_project
use sql_projects;

-- 	CREATING TABLE  --
CREATE TABLE retail_sales
            (
                transactions_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity	INT,
                price_per_unit FLOAT,	
                cogs	FLOAT,
                total_sale FLOAT
            );
            
select * from retail_sales;

select count(*) 
from retail_sales;

-- DATA CLEANING PROCESS --
-- looking for null values--

select *
from retail_sales
where transactions_id is null;
 
select *
from retail_sales
where
	sale_date is null
	or
	 sale_time is null
	or 
	 customer_id is null
	or 
	 gender is null
	or 
	 age is null
	or 
	 category is null
	or 
	 quantity is null
	or 
	 price_per_unit is null
	or 
	cogs is null
	or 
	total_sale is null;

-----

SET SQL_SAFE_UPDATES = 0;
DELETE FROM retail_sales
WHERE (
	transactions_id IS NULL 
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR gender IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL
)
AND transactions_id IS NOT NULL;
SET SQL_SAFE_UPDATES = 1;

-- DATA EXPLORATION --
select count(*) 
from retail_sales;

select count(customer_id) 
from retail_sales;

 -- How many unique customers we have 
 select 
 count(distinct customer_id) as customers 
from retail_sales;


-- Data Analysis & Business Key Problems & Answers
-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
---------------------------------------------------------------------------------------------------------------------------------------------------------
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

select * from retail_sales
where sale_date = "2022-12-05";

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
select *
from retail_sales
where
category ="Clothing"
and
 date_format(sale_date, '%Y-%m') ='2022-11' 	-- --'%Y = consider 4 values 2022 while '%y' consider only last 2 digit as 22 --
and 
quantity >2 ;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

select category,sum(total_sale)
from retail_sales
group by category
order by category,sum(total_sale) asc;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select avg(age) as avg_age
from retail_sales
where category= "Beauty";

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select * from retail_sales
where total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select category,gender,count(transactions_id)
from retail_sales
group by gender,category
order by gender,category,count(transactions_id);

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

select
	year(sale_date),
    month(sale_date),
    avg(total_sale)
from retail_sales
group by 1,2
order by 1,2;    

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

select customer_id,sum(total_sale) as total_sales
from retail_sales
group by customer_id
order by total_sales desc
limit 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

select category,count(distinct customer_id) as unique_customers 
from retail_sales
group by category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

with shiftwise_sales as
(select *,
 case
	when hour(sale_time) < 12 then 'Morning'
    when hour(sale_time) between 12 and 17 then 'Afternoon'
    else 'Evening'
    end as 'Shift'
from retail_sales
)
-- -- using cte(comman table expression ) for further grouping process --
select shift,
	count(*) as total_orders
from shiftwise_sales 
group by shift;




 

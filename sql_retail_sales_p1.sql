CREATE DATABASE IF NOT EXISTS sqlproject1;

USE sqlproject1;

CREATE TABLE IF NOT EXISTS retail (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(10),
    age INT,
    category VARCHAR(50),
    quantity INT,
    price_per_unit DECIMAL(10,2),
    cogs DECIMAL(10,2),
    total_sale DECIMAL(10,2)
);

select * from `sqlproject1.retail`
where sale_time is null
or sale_date is null
or transactions_id is null
or customer_id is null
or gender is null
or category is null
or quantiy is null
or price_per_unit is null
or cogs is null
or total_sale is null

-- data exploration
-- how much total_sale we have?
select count(total_sale) from `sqlproject1.retail`

-- how much unique customer we have?
select distinct count(customer_id) from `sqlproject1.retail`

-- how much unique category we have?
select distinct category from `sqlproject1.retail`

-- data analysis& business problem & answer
-- write query to retrieve all columnsfor sale made on "2022-11-05"

select * 
from `sqlproject1.retail`
where sale_date="2022-11-05"

-- write a query to retrieve all transactions where category is clothing and quantity sold is more than 3 in the month of nov-2022?
select 
 transactions_id,
 category,
 quantity,
 sale_date
from `sqlproject1.retail`
where 
  category="Clothing"
  and quantity > 3
  and  sale_date between '2022-11-01' and '2022-11-30';
  
-- write a query calculate total_sale for each category?
select 
  category,
  sum(total_sale) as net_sale
from `sqlproject1.retail`
group by 1;

-- write a query to find average age of customer who purchase from category beauty make new column for it?

select category,
  round(avg(age) over(partition by category),2) as avg_age_per_category
from `sqlproject1.retail`
where category='Beauty';

-- write a query to show all transaction where total sale is greater than 1000?

select *
from `sqlproject1.retail`
where total_sale > 1000;

-- write query to find toatal number of transaction made by each gender in each category?
select 
  category,
  gender,
  count(transactions_id) as total_transaction
from `sqlproject1.retail`
group by 1,2
order by 1;

-- write a query to calculate average sales for each month.Find out best selling month in each year?
with ranked_sales as (
  select 
    year,
    month,
    round(avg(total_sale),2) as average_sale,
    dense_rank() over(partition by year order by avg(total_sale) desc) as rank
  from (
    select *,
      extract(year from sale_date) as year,
      extract(month from sale_date) as month,
    from `sqlproject1.retail`
  )
  group by 
    year,
    month
)
select *
from ranked_sales
where rank=1;

-- write a query to find top 5 customer based on hoghest total_sale?
select 
  customer_id,
  sum(total_sale) as total_sales
from `sqlproject1.retail`
group by 1
order by 2 desc
limit 5;

-- write query to find number of unique customers who purchased from each category?
select 
 category,
 count(distinct customer_id) as num_unique_customer
from `sqlproject1.retail`
group by 1;


-- write query to create each shift and number of orders 
 with shift as (
  select 
    case 
      when EXTRACT(HOUR FROM sale_time) <= 12
      then "Morning"
      when EXTRACT(HOUR FROM sale_time) between 12 and 17
      then "Afternoon"
      else "Evening"
    end as shift ,
    quantiy
  from `sqlproject1.retail`
 )
 select 
  shift,
  sum(quantiy) as num_orders
from shift
group by shift;

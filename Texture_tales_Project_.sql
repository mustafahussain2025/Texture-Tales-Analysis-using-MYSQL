create database cs4;
use cs4;

##Q1 what was the total quantity sold for all products?
select*from product_details;
select * from product_hierarchy;
select * from product_sales;
select * from product_price;

select pd.product_name,sum(s.qty) as sales_counts
	from product_details as  pd
    join sales as s
    on pd.product_id = s.prod_id
    group by pd.product_name
    order by sales_counts desc;


SELECT 
	details.product_name,
	SUM(sales.qty) AS sale_counts
FROM sales AS sales
INNER JOIN product_details AS details
	ON sales.prod_id = details.product_id
GROUP BY details.product_name
ORDER BY sale_counts DESC;

##Q2 What is the total generated revenue for all products before discounts?
select sum(qty*price) as revenue_before_discounts
	from sales;



##Q3 What was the total discount amount for all products?

select sum(price*qty*discount)/100 as total_discount
from sales;




select sum(qty*discount) as 'discount total',
	sum(qty*price) as 'price total',
    total_amount = 'discount total' - 'price total'
    from sales;

SELECT 
	SUM(price * qty * discount)/100 AS total_discount
FROM sales;


##Q4 How many unique transactions were there?
select count(distinct txn_id) as total_unique_transactions
from sales;

SELECT 
	COUNT(DISTINCT txn_id) AS unique_txn
FROM sales;

##Q5. What are the average unique products purchased in each transacion?
with cte_transation_products as(
select txn_id,
count(distinct prod_id) as product_count
from sales
group by txn_id)

select round(avg(product_count)) as avg_unique_product
from cte_transation_products;




WITH cte_transaction_products AS (
	SELECT
		txn_id,
		COUNT(DISTINCT prod_id) AS product_count
	FROM sales
	GROUP BY txn_id
)
SELECT
	ROUND(AVG(product_count)) AS avg_unique_products
FROM cte_transaction_products;


##Q6. What is the average discount value per transaction?
 with cte_transaction_discount as(
 select txn_id,sum(price*qty*discount)/100 as total_discount
 from sales
 group by txn_id)
 
 select round(avg(total_discount)) as avg_discount
 from cte_transaction_discount;
 


WITH cte_transaction_discounts AS (
	SELECT
		txn_id,
		SUM(price * qty * discount)/100 AS total_discount
	FROM sales
	GROUP BY txn_id
)
SELECT
	ROUND(AVG(total_discount)) AS avg_unique_products
FROM cte_transaction_discounts;


##Q7. What is the average revenue for member transactions and non- member transactions?
with cte_member_transation as(
select member,txn_id,sum(price*qty) as  revenue
from sales
group by member,txn_id)

select member,round(avg(revenue),2) as average_revenue
from cte_member_transation
group by member;

#Q8. What are the top 3 products by total revenue before discount?

select pd.product_name ,
	sum(s.price*s.qty) as total_revenue
    from sales s
    join product_details pd
    on pd.product_id = s.prod_id
    group by pd.product_name
    order by total_revenue desc 
    limit 3;


SELECT 
	details.product_name,
	SUM(sales.qty * sales.price) AS nodis_revenue
FROM sales AS sales
INNER JOIN product_details AS details
	ON sales.prod_id = details.product_id
GROUP BY details.product_name
ORDER BY nodis_revenue DESC
LIMIT 3;


##Q9. What are the total quantity, revenue and discount for each segment?


SELECT 
	details.segment_id,
	details.segment_name,
	SUM(sales.qty) AS total_quantity,
	SUM(sales.qty * sales.price) AS total_revenue,
	SUM(sales.qty * sales.price * sales.discount)/100 AS total_discount
FROM sales AS sales
INNER JOIN product_details AS details
	ON sales.prod_id = details.product_id
GROUP BY 
	details.segment_id,
	details.segment_name
ORDER BY total_revenue DESC;


##Q10. What is the top selling product for each segment?
select details.segment_id,details.segment_name,
	details.product_id,details.product_name,
    sum(sales.qty) as product_quantity
    from sales as sales
    join product_details as details
    on sales.prod_id = details.product_id
    group by details.segment_id,details.segment_name,
		details.product_id,details.product_name
	order by product_quantity desc
	limit 5;


SELECT 
	details.segment_id,
	details.segment_name,
	details.product_id,
	details.product_name,
	SUM(sales.qty) AS product_quantity
FROM sales AS sales
INNER JOIN product_details AS details
	ON sales.prod_id = details.product_id
GROUP BY
	details.segment_id,
	details.segment_name,
	details.product_id,
	details.product_name
ORDER BY product_quantity DESC
LIMIT 5;


##Q11. What are the total quantity,revenue and discount for each category?

select details.category_name,count(sales.qty) as total_quantity,
	sum(sales.qty*sales.price) as revenue,
    sum(sales.qty*sales.price*sales.discount)/100 as discount
    from sales as sales
    join product_details as details
    on sales.prod_id = details.product_id
    group by details.category_name ;


##Q12. What is the top selling product for each category:
select details.product_name,details.product_id,
details.category_name
,sum(sales.qty) as Total_quantity
from sales as sales
join product_details as details 
on details.product_id = sales.prod_id
group by details.product_name,details.product_id,
details.category_name
order by total_quantity Desc
limit 5;









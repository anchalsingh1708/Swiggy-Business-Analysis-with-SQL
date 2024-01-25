create database swiggy_analysis;
use swiggy_analysis;
select*from items;
select*from orders;

/* 1) select distinct food items ordered */
select count(distinct name) as Items from items;

/* Group vegetarian and meat items together */
SELECT is_veg,
count(name) as items FROM items 
group by is_veg;

/*Count the number of unique orders*/

select count(distinct order_id) as Distinct_Order_Count from items;

/* Show items containing chicken in their name*/

select *from items where name like '%chicken%';

/* Find item names with Paratha*/
select *from items where name like '%Paratha%';

/* Average Items per Order */
select round(count(name)/count(distinct order_id),0) as AvgItemsPerOrder from items;

/* Item ordered the most number of times*/
select name,count(*) as Number_of_times_Ordered from items
 group by name 
 order by count(*) desc;
 
/* Orders during rainy times*/

SELECT distinct rain_mode FROM orders;

/* Unique restaurant names */
select distinct restaurant_name from orders;

/* Restaurant with most orders*/
select restaurant_name, count(*) FROM orders 
group by restaurant_name 
order by count(*) desc;

/* Orders placed per month and year*/
SELECT DATE_FORMAT(order_time, '%Y-%m') AS Date, COUNT(DISTINCT order_id) Orders
FROM orders
GROUP BY DATE_FORMAT(order_time, '%Y-%m')
ORDER BY COUNT(DISTINCT order_id) DESC;


/* Revenue made by month*/
SELECT DATE_FORMAT(order_time, '%Y-%m') AS Date, sum(order_total) Revenue
FROM orders
GROUP BY DATE_FORMAT(order_time, '%Y-%m')
ORDER BY Revenue desc;

/* Average Order Value*/

select round(sum(order_total)/count(distinct order_id),0) as Average_Order_Value from orders;

/* YOY Change in revenue using lag function and ranking the highest year*/
create table pyr with final as (select year(order_time) Order_Year,
                  sum(order_total) as Revenue from orders group by year(order_time) order by 2 desc )
select Order_Year,Revenue, lag(revenue) over(order by Order_Year ) as Previous_Year_Revenue from final;

select *,ifnull(concat(round(((revenue-Previous_Year_Revenue)/Previous_Year_Revenue)*100,2),"%"),"-") as "YOY%" from pyr;
                  

  
  
/* Restaurant with highest revenue ranking*/
with final as (select restaurant_name,
                  sum(order_total) as Revenue 
                  from orders 
                  group by restaurant_name 
                  order by 1 desc )
		select restaurant_name,revenue,
        rank() over(order by revenue desc) as rnk from final;
                  
/* Join order and item tables and find product combos using self join*/
SELECT a.order_id,a.name,b.name as name2,concat(a.name,"-",b.name) as Product_Combos FROM items a
                    join items b
					on a.order_id=b.order_id
                    where a.name!=b.name
                    and a.name<b.name




 
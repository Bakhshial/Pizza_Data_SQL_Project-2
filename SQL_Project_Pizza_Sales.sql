create database pizzaDB;

use pizzaDB;

select * from pizza_types;

select * from pizzas;

CREATE TABLE orders (
    order_id INT NOT NULL,
    order_date DATE NOT NULL,
    order_time TIME NOT NULL,
    PRIMARY KEY (order_id)
);


select * from orders;

CREATE TABLE order_details (
    order_details_id INT NOT NULL,
    order_id INT NOT NULL,
    pizza_id TEXT NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (order_details_id)
);


select * from order_details;


-- Retrieve the total number of orders placed.
select count(order_id) from orders;

-- output: 21350

-- Calculate the total revenue generated from pizza sales.
SELECT 
    ROUND(SUM(od.quantity * p.price), 2)
FROM
    order_details od
        JOIN
    pizzas p ON od.pizza_id = p.pizza_id;

-- output: 817860.05

-- Identify the highest-priced pizza.

select max(price) from pizzas;

-- output: 35.95

SELECT 
    pt.name, p.price
FROM
    pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
ORDER BY p.price DESC
LIMIT 1;

-- output:The Greek Pizza	35.95

-- Identify the most common pizza size ordered.

SELECT 
    p.size, COUNT(od.quantity) AS count
FROM
    pizzas p
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY size
ORDER BY count DESC
;
-- output: L= 18526



-- List the top 5 most ordered pizza types along with their quantities.

SELECT 
    pt.name, SUM(od.quantity) AS quantity
FROM
    pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY pt.name
ORDER BY quantity DESC
LIMIT 5;

-- output:
   	--	The Classic Deluxe Pizza	2453
	--	The Barbecue Chicken Pizza	2432
	--	The Hawaiian Pizza	2422
	--	The Pepperoni Pizza	2418
	--	The Thai Chicken Pizza	2371



-- Join the necessary tables to find the total quantity of each pizza category ordered.

SELECT 
    pt.category, SUM(od.quantity) AS quantity
FROM
    pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY pt.category
ORDER BY quantity DESC;

-- output:
	--	Classic	14888
	--	Supreme	11987
	--	Veggie	11649
	--	Chicken	11050
    
-- Determine the distribution of orders by hour of the day.
SELECT 
    HOUR(order_time) AS hour, COUNT(order_id) AS count_order
FROM
    orders
GROUP BY hour
ORDER BY count_order DESC;

-- Join relevant tables to find the category-wise distribution of pizzas.

select category,count(name)
from pizza_types
group by category;


-- Group the orders by date and calculate the average number of pizzas ordered per day.
select round(avg(sum_quantity)) as avg_quantity_per_day
from
 (
select o.order_date,sum(od.quantity) as sum_quantity
from orders o
join order_details od
on o.order_id=od.order_id
group by o.order_date
) as order_quantity;



-- Determine the top 3 most ordered pizza types based on revenue.
select pt.name,
round(sum(od.quantity*p.price)) as revenue
from pizza_types pt
join pizzas p on pt.pizza_type_id=p.pizza_type_id
join order_details od
on p.pizza_id=od.pizza_id
group by pt.name order by  revenue desc limit 3;



-- Calculate the percentage contribution of each pizza type to total revenue.

select pt.category,
round(sum(od.quantity*p.price)/
(SELECT 
    ROUND(SUM(od.quantity * p.price), 2)
FROM
    order_details od
        JOIN
    pizzas p ON od.pizza_id = p.pizza_id)*100,2) as revenue_percetange
from pizza_types pt
join pizzas p on pt.pizza_type_id=p.pizza_type_id
join order_details od
on p.pizza_id=od.pizza_id
group by pt.category order by  revenue_percetange desc;



-- Analyze the cumulative revenue generated over time.

select order_date,
sum(revenue) over(order by order_date)
from
(select o.order_date,
sum(od.quantity*p.price) as revenue
from order_details od
join pizzas p on od.pizza_id=p.pizza_id
join orders o
on od.order_id=o.order_id
group by o.order_date) as sales;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.

select category,name,revenue
from
(select category,name,revenue,
rank() over(partition by category order by revenue desc) as rn
from
(select pt.category,pt.name,
sum(od.quantity*p.price) as revenue
from order_details od
join
pizzas p
 on od.pizza_id=p.pizza_id
 join pizza_types pt
  on pt.pizza_type_id=p.pizza_type_id
  group by pt.category,pt.name) as category_wise_revenue) as b
  where rn <=3;




















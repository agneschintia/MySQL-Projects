<h1 align="center"> Pizza Metrics Solution</h1>

1. How many pizzas were ordered?
```
SELECT 
	COUNT(pizza_id) AS order_count
FROM temp_customer_orders;
```

 Result: </br>
 <img width="100" alt="1" src="https://user-images.githubusercontent.com/79323632/156720217-b9cc9361-8585-4c52-88d3-c9d1f8bd82f5.PNG">
* There are 14 pizzas were ordered

2. How many unique customer orders were made?
```
SELECT 
	COUNT(DISTINCT(order_id)) AS num_customers
FROM temp_customer_orders;
```

Result: </br>
<img width="105" alt="2" src="https://user-images.githubusercontent.com/79323632/156720910-a27b2430-ce3c-4280-a473-1ac668900c08.PNG">
* There are 10 customer unique orders.

3. How many successful orders were delivered by each runner?
```
SELECT
	runner_id,
	COUNT(order_id) AS successful_orders
FROM temp_runner_orders
WHERE cancellation is null
GROUP BY runner_id;
```

Result: </br>
<img width="145" alt="3" src="https://user-images.githubusercontent.com/79323632/156721058-bcc22a4b-2b7b-4561-ae75-6b9b88947d3d.PNG">
* Runner 1 has succesfully delivered 4 pizzas.
* Runner 2 has succesfully delivered 3 pizzas.
* Runner 3 has succesfully delivered 1 pizza. 

4. How many of each type of pizza was delivered?
```
SELECT
	pn.pizza_name,
    COUNT(tco.pizza_id) AS pizza_delivered
FROM temp_customer_orders tco
JOIN pizza_names pn ON tco.pizza_id = pn.pizza_id
JOIN temp_runner_orders tro ON tro.order_id = tco.order_id
WHERE tro.cancellation is null
GROUP BY pn.pizza_name;
```

Result: </br>
<img width="153" alt="4" src="https://user-images.githubusercontent.com/79323632/156721280-950e5b94-3b1d-4d47-8e41-75d95074fd49.PNG">
* There are 9 Meatlovers pizzas were delivered
* There are 3 Vegetarian pizzas were delivered

5. How many Vegetarian and Meatlovers were ordered by each customer?
```
SELECT
	customer_id,
	SUM(if(pizza_id = 1, 1, 0)) AS meat_lovers,
    SUM(if(pizza_id = 2, 1, 0)) AS vegetarian
FROM temp_customer_orders
GROUP BY customer_id;
```

Result: </br>
<img width="185" alt="5" src="https://user-images.githubusercontent.com/79323632/156721755-6dc601cc-2ae1-49df-ab07-26eed1651a12.PNG">
* Customer 101 ordered 2 Meatlovers and 1 Vegetarian pizzas.
* Customer 102 ordered 2 Meatlovers and 1 Vegetarian pizzas.
* Customer 103 ordered 3 Meatlovers and 1 Vegetarian pizzas.
* Customer 104 ordered 3 Meatlovers pizzas.
* Customer 105 ordered 1 Vegetarian pizza.

6. What was the maximum number of pizzas delivered in a single order?
```
WITH cte_pizza AS (
	SELECT
		tco.order_id,
		COUNT(tco.pizza_id) AS count_pizza
	FROM temp_customer_orders tco
	JOIN temp_runner_orders tro ON tco.order_id = tro.order_id
	WHERE tro.cancellation is null
	GROUP BY order_id)
SELECT
	MAX(count_pizza) AS max_num_pizza
FROM cte_pizza;
```

Result: </br>
<img width="93" alt="6" src="https://user-images.githubusercontent.com/79323632/156722231-b6df8793-1963-462b-9fb0-b71e96e90c5f.PNG">
* Maximum number of pizzas delivered in a single order is 3 pizzas.

7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
```
SELECT 
    customer_id,
    SUM(CASE
        WHEN tco.exclusions != ' ' OR tco.extras != ' ' THEN 1
        ELSE 0
		END) AS changes,
    SUM(CASE
        WHEN tco.exclusions = ' ' AND tco.extras = ' ' THEN 1
        ELSE 0
		END) AS no_changes
FROM temp_customer_orders tco
JOIN temp_runner_orders tro ON tco.order_id = tro.order_id
WHERE tro.distance != 0
GROUP BY tco.customer_id;
```

Result: </br>
<img width="172" alt="7" src="https://user-images.githubusercontent.com/79323632/156722479-881cc17c-123b-4568-9701-c50135f47dc7.PNG">
* Customer 101 and 102 ordered pizzas with no changes.
* Customer 103, 104, and 105 ordered pizzas with at least 1 change either ordered their pizzas with exclusions or extras. Customer 104 also ordered pizza with no change once.

8. How many pizzas were delivered that had both exclusions and extras?
```
SELECT 
	COUNT(tco.order_id) AS count_pizza
FROM temp_customer_orders tco
JOIN temp_runner_orders tro ON tco.order_id = tro.order_id
WHERE tco.exclusions != "" AND tco.extras != "" AND tro.cancellation is null
GROUP BY tco.customer_id;
```

Result: </br>
<img width="78" alt="8" src="https://user-images.githubusercontent.com/79323632/156723216-74cf564b-5141-49d6-9f42-88d1ef685e7c.PNG">
* There is just one pizza delivered with both exclusions and extras

9. What was the total volume of pizzas ordered for each hour of the day?
```
SELECT 
	HOUR(order_date) AS hour_of_day,
	COUNT(order_id) AS pizza_volume
FROM temp_customer_orders
WHERE order_date is not null
GROUP BY hour_of_day
ORDER BY hour_of_day;
```

Result: </br>
<img width="145" alt="9" src="https://user-images.githubusercontent.com/79323632/156723405-3309478c-964e-464e-ab96-1bf32a60b215.PNG">
* The highest volume of pizzas ordered at 13.00, 18.00, 21.00, and 23.00
* The lowest volume of pizzas ordered at 11.00 and 19.00

10. What was the volume of orders for each day of the week?
```
SELECT 
	DAYNAME(order_date) AS day_of_week,
	COUNT(*) AS pizza_volume    
FROM temp_customer_orders
GROUP BY day_of_week
ORDER BY day_of_week;
```

Result: </br>
<img width="145" alt="10" src="https://user-images.githubusercontent.com/79323632/156723849-a0ae220a-435b-4363-824f-2d42b2db621f.PNG">
* The highest volume of orders on Saturday and Wednesday with 5 pizzas
* There are 3 ordered of pizzas on Thursday
* The lowest volume of orders on Friday with only 1 pizza.

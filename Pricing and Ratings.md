<h1 align="center">Pricing and Ratings</h1>

<h3 align="left">1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?</h3>

```
SELECT 
	SUM(CASE
			WHEN tco.pizza_id = 1 THEN 12
            ELSE 10
            END) AS total_price
FROM temp_runner_orders tro
JOIN temp_customer_orders tco ON tco.order_id = tro.order_id
WHERE tro.cancellation != " ";
```

Result: </br>
<img width="73" alt="1" src="https://user-images.githubusercontent.com/79323632/156983881-411fae81-9937-4771-9364-e1dbef4ae4d4.PNG">
* Pizza Runner has made $138 so far

<h3 align="left">2. What if there was an additional $1 charge for any pizza extras?</br> - Add cheese is $1 extra</h3>

```
WITH cte_price AS (
	SELECT 
		tco.pizza_id,
		SUM(CASE
				WHEN tco.pizza_id = 1 THEN 12
				ELSE 10
				END) AS total_price
	FROM temp_runner_orders tro
	JOIN temp_customer_orders tco ON tco.order_id = tro.order_id
	WHERE tro.cancellation != " ")
SELECT (
	LENGTH(group_concat(tco.extras)) - LENGTH(REPLACE(group_concat(tco.extras), ',', '')) + 1) + cp.total_price
    AS total_price_charges
FROM temp_customer_orders tco
JOIN cte_price cp ON cp.pizza_id = tco.pizza_id;
```

Result: </br>
<img width="105" alt="2" src="https://user-images.githubusercontent.com/79323632/156984220-e37dc434-e609-45e2-80d5-27684dca2ae4.PNG">
* The total amount of price is $150 including extras

<h3 align="left">3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.</h3>

```
DROP TABLE IF EXISTS ratings;
CREATE TABLE ratings (
order_id int,
rating int);

INSERT INTO ratings VALUES 
(1, 5), (2, 3), (3, 4), (4, 2), (5,3), (7, 3), (8, 4), (10, 5);

SELECT * FROM ratings;
```

Result: </br>
<img width="100" alt="3" src="https://user-images.githubusercontent.com/79323632/156984474-09a8dc27-a522-40cb-9e53-ff98ac5b2540.PNG">

<h3 align="left">4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?</br>
- customer_id </br>
- order_id </br>
- runner_id </br>
- rating </br>
- order_time </br>
- pickup_time </br>
- Time between order and pickup </br>
- Delivery duration </br>
- Average speed </br>
- Total number of pizzas </br>
</h3>

```
SELECT
	tco.customer_id,
    tco.order_id,
    tro.runner_id,
    rt.rating,
    tco.order_date,
    tro.pickup_time,
    MINUTE(TIMEDIFF(tco.order_date, tro.pickup_time)) AS time_order_pickup,
    tro.duration,
    ROUND(avg(60 * tro.distance / tro.duration), 1) AS avg_speed,
    COUNT(tco.pizza_id) AS num_pizza
FROM temp_customer_orders tco
JOIN temp_runner_orders tro ON tco.order_id = tro.order_id
JOIN ratings rt ON tco.order_id = rt.order_id
GROUP BY tco.customer_id, tco.order_id, tro.runner_id, rt.rating, tco.order_date, tro.pickup_time, time_order_pickup, tro.duration
ORDER BY tco.customer_id;
```

Result: </br>
<img width="600" alt="4" src="https://user-images.githubusercontent.com/79323632/156984726-4e41c5e6-c7ba-4cd8-a572-cfcd20465997.PNG">

<h3 align="left">5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?</h3>

```
SET @total_price_pizza = 138;
SELECT
	ROUND(@total_price_pizza - (SUM(duration))*0.3,0) AS final_price
FROM temp_runner_orders;
```

Result: </br>
<img width="71" alt="5" src="https://user-images.githubusercontent.com/79323632/156985497-8e5b837f-7034-43c5-acbe-eebb4ec07a3f.PNG">
* We set the total price pizza with no cost for extras and exclusions to $138
* Substracts the total price pizza with the sum of duration multiplied by $0.30
* Pizza Runner has $83 left

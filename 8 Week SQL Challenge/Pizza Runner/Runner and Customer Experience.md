<h1 align="center">Runner and Customer Experience</h1>


<h3 align="left">1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)</h3>

```
WITH signedup_runner AS (
	SELECT
		runner_id,
		registration_date,
		registration_date - ((registration_date - DATE('2021-01-01')) % 7) AS one_week
	FROM runners)
SELECT 
	one_week,
    COUNT(runner_id) AS num_runner
FROM signedup_runner
GROUP BY one_week
ORDER BY one_week;
```

Result: </br>
<img width="136" alt="1" src="https://user-images.githubusercontent.com/79323632/156968570-782c665a-7f2b-44e0-8dcb-024d5318e003.PNG">
* There are 2 runners signed up on the first week of January
* There is 1 runner signed up each on the second and third week of January

<h3 align="left">2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?</h3>

```
WITH cte_duration AS (
	SELECT
		a.runner_id,
        a.order_id,
        b.order_date,
        a.pickup_time,
		TIME(b.order_date) - TIME(a.pickup_time) AS duration
	FROM temp_runner_orders a
	JOIN temp_customer_orders b ON a.order_id = b.order_id
    WHERE cancellation is null)
SELECT 
	runner_id,
	ROUND(AVG(MINUTE(duration)),0) as avg_time
FROM cte_duration
GROUP BY runner_id
ORDER BY runner_id;
```

Result: </br>
<img width="118" alt="2" src="https://user-images.githubusercontent.com/79323632/156968932-93b276e5-0512-4204-b850-85ea4fed0126.PNG">
* The first and the third runner have the same average, it is 10 minutes.
* The average of the second runner is 27 minutes, which becomes the longest time to pickup the order

<h3 align="left">3. Is there any relationship between the number of pizzas and how long the order takes to prepare?</h3>

```
WITH cte_pizza AS (
	SELECT
		tco.order_id,
		COUNT(tco.order_id) AS num_pizza,
        tco.order_date,
        tro.pickup_time,
        TIMEDIFF(tro.pickup_time, tco.order_date) AS duration
	FROM temp_runner_orders tro
    JOIN temp_customer_orders tco ON tco.order_id = tro.order_id
    WHERE tro.distance != 0
    GROUP BY tco.order_id)
SELECT
	num_pizza,
    minute(duration) AS avg_prepare_time
FROM cte_pizza
GROUP BY num_pizza;
```

Result: </br>
<img width="151" alt="3" src="https://user-images.githubusercontent.com/79323632/156969467-7a7bd450-cc1f-42a1-a6c7-527693730a51.PNG">
* A single pizza takes 10 minutes to prepare
* Two pizzas take 21 minutes to prepare, and three pizzas take 29 minutes to prepare
* This concludes that it takes around 10 minutes to prepare each pizza.

<h3 align="left">4. What was the average distance travelled for each customer?</h3>

```
SELECT
	runner_id,
    ROUND(avg(distance),2) AS avg_distance
FROM temp_runner_orders
GROUP BY runner_id;
```

Result: </br>
<img width="140" alt="4" src="https://user-images.githubusercontent.com/79323632/156971418-825a8b6d-29e5-48b8-8784-fa7ba01aa0b2.PNG">
* First of all, I assumed the distance is calculated from Pizza HQ to the customer's place
* The longest distance travelled by the second runner that took 23.93 Km to deliver the pizza
* The shortest distance travelled by the third runner that took 10 Km to deliver the pizza

<h3 align="left">5. What was the difference between the longest and shortest delivery times for all orders?</h3>

```
WITH cte_times AS (
	SELECT 
		tro.order_id,
    timediff(tco.order_date, tro.pickup_time) AS times
	FROM temp_runner_orders tro
    JOIN temp_customer_orders tco ON tro.order_id = tco.order_id
    WHERE tro.duration != " "
    GROUP BY tro.order_id)
SELECT
	MAX(minute(times)) - MIN(minute(times)) AS diff_times
FROM cte_times;
```

Result: </br>
<img width="78" alt="5" src="https://user-images.githubusercontent.com/79323632/156972377-d6e09b7f-7990-464b-afda-a3d5c442f97e.PNG">
* The difference between the longest (29 minutes) and the shortest (10 minutes) delivery times is 19 minutes.

<h3 align="left">6. What was the average speed for each runner for each delivery and do you notice any trend for these values?</h3>

```
WITH cte_order AS (
	SELECT 
		order_id,
        COUNT(pizza_id) AS total_pizza
	FROM temp_customer_orders
    GROUP BY order_id)
SELECT
	tro.runner_id,
    tro.order_id,
    tro.distance,
    tro.duration,
    co.total_pizza,
    ROUND(60 * distance / duration, 1) AS speedKmH
FROM temp_runner_orders tro
JOIN cte_order co ON co.order_id = tro.order_id
WHERE distance != " "
GROUP BY tro.runner_id, tro.order_id
ORDER BY tro.order_id;
```

Result: </br>
<img width="306" alt="6" src="https://user-images.githubusercontent.com/79323632/156973320-2e17cbff-3160-4b3c-bde9-b2064ddb842f.PNG">
* The average speed for runner 1 is from 37.5 km/h to 60 km/h
* The average speed for runner 2 is from 35.1 km/h to 93.6 km/h
* For runner 3 is 40 km/h
* There is a strange average speed by runner 2 has 300% fluctuation, especially with the order with same distance but the average speed is way higher than the other.

<h3 align="left">7. What is the successful delivery percentage for each runner?</h3>

```
SELECT 
	runner_id,
    COUNT(pickup_time) AS success_delivery,
    COUNT(order_id) AS total_order,
    ROUND(COUNT(pickup_time)/COUNT(order_id)*100) AS perc_delivery
FROM temp_runner_orders
GROUP BY runner_id
ORDER BY runner_id;
```

Result: </br>
<img width="265" alt="7" src="https://user-images.githubusercontent.com/79323632/156975395-a2b3a8e3-df9a-4d29-8bac-fddbb75cb48d.PNG">
* Runner 1 has 100% succesful delivery.
* Runner 2 has 75% successful dellivery.
* Runner 3 has 50% successful delivery.
* We can note that the cancellations are not in the runner's control, so this attribute can't represent how successful delivery should be.

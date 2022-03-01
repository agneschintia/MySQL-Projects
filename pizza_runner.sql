CREATE SCHEMA pizza_runner; # create schema to store the data
USE pizza_runner; # use pizza_runner as we want to create tables on it

# create runners table that consists runner_id (the deliver man) and registration_date (the day the registered)
DROP TABLE IF EXISTS runners;
CREATE TABLE runners (
runner_id integer,
registration_date date);

# inserting data into the runners table
INSERT INTO runners VALUES 
(1, "2021-01-01"), (2, "2021-01-03"), (3, "2021-01-08"), (4, "2021-01-15");

# create customer_orders that consists the order_id, customer_id, pizza_id, exclusions, extras, and order_time
CREATE TABLE customer_orders (
order_id integer,
customer_id integer,
pizza_id integer,
exclusions VARCHAR(4),
extras VARCHAR(4),
order_date TIMESTAMP);


# insert data to customer_orders table
INSERT INTO customer_orders VALUES
  ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
  ('2', '101', '1', '', '', '2020-01-01 19:00:52'),
  ('3', '102', '1', '', '', '2020-01-02 23:51:23'),
  ('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
  ('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
  ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
  ('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
  ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
  ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
  ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
  ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');
  
# use drop table statement in case we accidentaly create existing table
DROP TABLE IF EXISTS runner_orders;

#create runner_orders table
CREATE TABLE runner_orders (
order_id integer,
runner_id integer,
pickup_time VARCHAR(19),
distance VARCHAR(7),
duration VARCHAR(10),
cancellation VARCHAR(23));

# insert data into runner_orders table
INSERT INTO runner_orders VALUES
('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', ''),
('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', ''),
('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation'),
('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null'),
('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
('9', '2', 'null', 'null', 'null', 'Customer Cancellation'),
('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');

# use drop table statement in case we accidentaly create existing table
DROP TABLE IF EXISTS pizza_names;

#create pizza_names table
CREATE TABLE pizza_names (
pizza_id integer,
pizza_name text);

# insert data into pizza_names table
INSERT INTO pizza_names VALUES
("1", "Meat Lovers"), ("2", "Vegetarian");

# use drop table statement in case we accidentaly create existing table
DROP TABLE IF EXISTS pizza_recipes;

# create pizza_recipes table
CREATE TABLE pizza_recipes (
pizza_id integer,
toppings text);

#insert data into pizza_recipes table
INSERT INTO pizza_recipes VALUES
("1","1, 2, 3, 4, 5, 6, 8, 10"), ("2", "4, 6, 7, 9, 11, 12");

# use drop table statement in case we accidentaly create existing table
DROP TABLE IF EXISTS pizza_toppings;

#create pizza_toppings table
CREATE TABLE pizza_toppings (
topping_id integer,
topping_name text);

# insert data into pizza_toppings table
INSERT INTO pizza_toppings VALUES
(1, 'Bacon'), (2, 'BBQ Sauce'), (3, 'Beef'), (4, 'Cheese'), (5, 'Chicken'), (6, 'Mushrooms'),
(7, 'Onions'), (8, 'Pepperoni'), (9, 'Peppers'), (10, 'Salami'), (11, 'Tomatoes'),
(12, 'Tomato Sauce');

-- Data cleaning --
# we want to convert blanks and 'null' values into null in runner_orders table in temp table
DROP TEMPORARY TABLE IF EXISTS temp_runner_orders;
CREATE TEMPORARY TABLE temp_runner_orders (
SELECT 
	order_id,
    runner_id,
    CASE 
		WHEN pickup_time = 'null' THEN null 
        ELSE pickup_time
	END AS pickup_time,
    NULLIF(REGEXP_REPLACE(distance, '[^0-9.]',''), '') AS distance,
    NULLIF(REGEXP_REPLACE(duration, '[^0-9.]',''), '') AS duration,
    CASE
		WHEN cancellation = '' THEN null
        WHEN cancellation = 'null' THEN null
        ELSE cancellation
	END AS cancellation
FROM runner_orders);

SELECT 
	*,
    CAST(pickup_time AS datetime) AS pickup_time
FROM temp_runner_orders;

-- Customer orders table
DROP TEMPORARY TABLE IF EXISTS temp_customer_orders;
CREATE TEMPORARY TABLE temp_customer_orders (
SELECT
	order_id,
    customer_id,
    pizza_id,
    CASE
		WHEN exclusions = 'null' THEN ''
		ELSE exclusions
	END AS exclusions,
    CASE
		WHEN extras = 'null' THEN ''
        WHEN extras is null THEN ''
		ELSE extras
	END AS extras,
    order_date
FROM customer_orders);

SELECT * FROM temp_customer_orders;

-- Pizza Metrics --
-- 1. How many pizzas were ordered?
SELECT 
	COUNT(pizza_id) AS order_count
FROM temp_customer_orders;

-- 2. How many unique customer orders were made?
SELECT 
	COUNT(DISTINCT(order_id)) AS num_customers
FROM temp_customer_orders;

-- 3. How many successful orders were delivered by each runner?
SELECT
	runner_id,
	COUNT(order_id) AS successful_orders
FROM temp_runner_orders
WHERE cancellation is null
GROUP BY runner_id;

-- 4. How many each type of pizza was delivered?
SELECT
	pn.pizza_name,
    COUNT(tco.pizza_id) AS pizza_delivered
FROM temp_customer_orders tco
JOIN pizza_names pn ON tco.pizza_id = pn.pizza_id
JOIN temp_runner_orders tro ON tro.order_id = tco.order_id
WHERE tro.cancellation is null
GROUP BY pn.pizza_name;

-- 5. How many Vegetarian and Meatlovers were ordered by each customer?
SELECT
	customer_id,
	SUM(if(pizza_id = 1, 1, 0)) AS meat_lovers,
    SUM(if(pizza_id = 2, 1, 0)) AS vegetarian
FROM temp_customer_orders
GROUP BY customer_id;

-- 6. What was the maximum number of pizzas delivered in a single order?
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

-- 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SELECT 
    customer_id,
    SUM(CASE
        WHEN tco.exclusions != '' OR tco.extras != '' THEN 1
        ELSE 0
		END) AS changes,
    SUM(CASE
        WHEN tco.exclusions = '' OR tco.extras = '' THEN 1
        ELSE 0
		END) AS no_changes
FROM temp_customer_orders tco
JOIN temp_runner_orders tro ON tco.order_id = tro.order_id
WHERE tro.cancellation IS NULL
GROUP BY tco.customer_id;

-- 8. How many pizzas were delivered that had both exclusions and extras?
SELECT 
	COUNT(tco.pizza_id) AS count_pizza
FROM temp_customer_orders tco
JOIN temp_runner_orders tro ON tco.order_id = tro.order_id
WHERE tco.exclusions != '' AND tco.extras != '' AND tro.cancellation is null
GROUP BY pizza_id;

-- 9. What was the total volume of pizzas ordered for each hour of the day?
SELECT 
	COUNT(*) AS pizza_volume,
    HOUR(order_date) AS hour_of_day
FROM temp_customer_orders
WHERE order_date is not null
GROUP BY hour_of_day
ORDER BY hour_of_day;

-- 10. What was the volume of orders for each day of the week?
SELECT 
	COUNT(*) AS pizza_volume,
    DAYNAME(order_date) AS day_of_week
FROM temp_customer_orders
GROUP BY day_of_week
ORDER BY day_of_week;

-- Runner and Customer Experience --
-- 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
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

-- 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
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


-- 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
WITH cte_pizza AS (
	SELECT
		COUNT(b.order_id) AS num_pizza,
        time(a.pickup_time) - time(b.order_date) AS duration
	FROM temp_runner_orders a
    JOIN temp_customer_orders b ON b.order_id = a.order_id
    WHERE a.pickup_time is not null
    GROUP BY b.order_id)
SELECT
	num_pizza,
    minute(duration) AS avg_prepare_time
FROM cte_pizza
GROUP BY num_pizza;

-- 4. What was the average distance travelled for each runner?
SELECT
	runner_id,
    ROUND(avg(distance),2) AS avg_distance
FROM temp_runner_orders
GROUP BY runner_id;

-- 5. What was the difference between the longest and the shortest delivery times for all orders
WITH cte_times AS (
	SELECT 
		a.order_id,
        timediff(b.order_date, a.pickup_time) AS times
	FROM temp_runner_orders a
    JOIN temp_customer_orders b ON a.order_id = b.order_id
    WHERE a.cancellation is null
    GROUP BY a.order_id)
SELECT
	MAX(minute(times)) - MIN(minute(times)) AS diff_times
FROM cte_times;

-- 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
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
WHERE distance is not null
GROUP BY tro.runner_id, tro.order_id
ORDER BY speedKmH;


-- 7. What is the successful delivery percentage for each runner?
SELECT 
	runner_id,
    COUNT(pickup_time) AS success_delivery,
    COUNT(order_id) AS total_order,
    ROUND(COUNT(pickup_time)/COUNT(order_id)*100) AS perc_delivery
FROM temp_runner_orders
GROUP BY runner_id
ORDER BY runner_id;

-- Ingredient Optimization --
-- 1. What are the standard ingridients for each pizza?

DROP TEMPORARY TABLE IF EXISTS temp_pizza_recipes;
CREATE TEMPORARY TABLE temp_pizza_recipes (
pizza_id int,
toppings int );

select * from pizza_toppings;

INSERT INTO temp_pizza_recipes VALUES 
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6), (1, 8), (1, 10), (2, 4), (2, 6), (2, 7), 
(2, 9), (2, 11), (2, 12);

WITH cte_toppings AS (
	SELECT
		pt.topping_name,
		tpr.pizza_id,
        pn.pizza_name
	FROM temp_pizza_recipes tpr
    JOIN pizza_toppings pt ON pt.topping_id = tpr.toppings
    JOIN pizza_names pn ON pn.pizza_id = tpr.pizza_id
    ORDER BY pn.pizza_name)
SELECT
	ct.pizza_name,
    ct.topping_name
FROM cte_toppings ct;

-- 2. What was the most commonly added extra?
DROP TEMPORARY TABLE IF EXISTS temp_extras;
CREATE TEMPORARY TABLE temp_extras (
pizza_id int,
extras int);

INSERT INTO temp_extras VALUES 
(1, 1), (2, 1), (1, 1), (1, 5), (1, 1), (1, 4);

SELECT
	extras,
    topping_name,
    COUNT(extras) AS extras_counts
FROM temp_extras te
JOIN pizza_toppings pt ON te.extras = pt.topping_id
GROUP BY extras;

-- 3. What was the most common exclusion?
DROP TEMPORARY TABLE IF EXISTS temp_exclusion;
CREATE TEMPORARY TABLE temp_exclusion (
pizza_id int,
exclusions int);

INSERT INTO temp_exclusion VALUES 
(1, 4), (1, 4), (2, 4), (1, 4), (1, 2), (1, 6);

SELECT
	exclusions,
    topping_name,
    COUNT(exclusions) AS exclusion_counts
FROM temp_exclusion tx
JOIN pizza_toppings pt ON tx.exclusions = pt.topping_id
GROUP BY exclusions
ORDER BY exclusion_counts desc;

SELECT * FROM pizza_toppings;
/* Generate an order item for each record in the customer_orders table in the format of
the one following:
1. Meat Lovers
2. Meat Lovers - Exclude Beef
3. Meat Lovers - Extra Bacon
4. Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers */
SELECT * FROM temp_customer_orders;

SELECT
	tco.order_id,
    tco.pizza_id,
    pn.pizza_name,
    tco.exclusions,
    tco.extras,
    CASE
		WHEN tco.pizza_id = 1 AND tco.exclusions = '' AND tco.extras = '' THEN 'Meat Lovers'
        WHEN tco.pizza_id = 2 AND tco.exclusions = '' AND tco.extras = '' THEN 'Vegetarian'
        WHEN tco.pizza_id = 1 AND tco.exclusions = '4' AND tco.extras = '' THEN 'Meat Lovers - Exclude Cheese'
        WHEN tco.pizza_id = 2 AND tco.exclusions = '4' AND tco.extras = '' THEN 'Vegetarian - Exclude Cheese'
        WHEN tco.pizza_id = 1 AND tco.exclusions = '' AND tco.extras = '1' THEN 'Meat Lovers - Extra Bacon'
        WHEN tco.pizza_id = 2 AND tco.exclusions = '' AND tco.extras = '1' THEN 'Vegetarian - Extra Bacon'
        WHEN tco.pizza_id = 1 AND tco.exclusions = '4' AND tco.extras = '1, 5' THEN 'Meat Lovers - Exclude Cheese - Extra Bacon and Chicken'
        WHEN tco.pizza_id = 1 AND tco.exclusions = '2, 6' AND tco.extras = '1, 4' THEN 'Meat Lovers - Exclude BBQ Sauce and Mushroom - Extra Bacon and Cheese'
	END AS order_item
FROM temp_customer_orders tco
JOIN pizza_names pn ON tco.pizza_id = pn.pizza_id;

/* 5. Generate an alphabetically ordered comma separated ingredient list for each pizza
order from the customer_orders table and add a 2x in front of any relevant ingredients
- for example: "Meat Lovers: 2xBacon, Beef, ..., Salami"
*/
WITH cte_toppings AS (
	SELECT
		pt.topping_name,
		tpr.pizza_id,
        pn.pizza_name
	FROM temp_pizza_recipes tpr
    JOIN pizza_toppings pt ON pt.topping_id = tpr.toppings
    JOIN pizza_names pn ON pn.pizza_id = tpr.pizza_id
    ORDER BY pn.pizza_name),
topping_group AS (
SELECT
	pizza_id,
	GROUP_CONCAT(topping_name) AS toppings
FROM cte_toppings
GROUP BY pizza_id)
SELECT
	tco.order_id,
    tco.customer_id,
    tco.pizza_id,
	tco.exclusions,
    tco.extras,
    tco.order_date,
    CASE
		WHEN ct.pizza_id = 1 THEN CONCAT(ct.pizza_name, ":", " ", "2x", " ", tg.toppings)
        WHEN ct.pizza_id = 2 THEN CONCAT(ct.pizza_name, ":", " ", "2x", " ", tg.toppings)
	END AS ingredient_list
FROM cte_toppings ct
LEFT JOIN topping_group tg ON tg.pizza_id = ct.pizza_id
LEFT JOIN temp_customer_orders tco ON tg.pizza_id = tco.pizza_id
GROUP BY tco.order_id, tco.exclusions;

/* 6. What is the total quantity of each ingredient used in all delivered pizzas sorted by 
most frequent first? */
SELECT
	tpr.toppings,
    pt.topping_name,
	COUNT(tpr.toppings) AS qty_ingredient,
    pn.pizza_name
FROM temp_pizza_recipes tpr
JOIN temp_customer_orders tco ON tpr.pizza_id = tco.pizza_id
LEFT JOIN temp_runner_orders tro ON tro.order_id = tco.order_id
JOIN pizza_toppings pt ON pt.topping_id = tpr.toppings
JOIN pizza_names pn ON pn.pizza_id = tco.pizza_id
WHERE tro.cancellation is null
GROUP BY tpr.toppings;

-- Pricing and Ratings --
/* 1. If a Meat lovers pizza costs $12 and Vegeterian costs $10 and there were no charges 
for changes - how much money has Pizza Runner made so far if there are no delivery fees? */
SELECT 
	SUM(CASE
			WHEN tco.pizza_id = 1 THEN 12
            ELSE 10
            END) AS total_price
FROM temp_runner_orders tro
JOIN temp_customer_orders tco ON tco.order_id = tro.order_id
WHERE tro.cancellation is null;

/* 2. What if there was an additional $1 charge for any pizza extras?
	- Add cheese is $1 extra */
WITH cte_price AS (
	SELECT 
		tco.pizza_id,
		SUM(CASE
				WHEN tco.pizza_id = 1 THEN 12
				ELSE 10
				END) AS total_price
	FROM temp_runner_orders tro
	JOIN temp_customer_orders tco ON tco.order_id = tro.order_id
	WHERE tro.cancellation is null)
SELECT (
	LENGTH(group_concat(tco.extras)) - LENGTH(REPLACE(group_concat(tco.extras), ',', '')) + 1) + cp.total_price
    AS total_price_charges
FROM temp_customer_orders tco
JOIN cte_price cp ON cp.pizza_id = tco.pizza_id;

/* 3. The Pizza Runner team now wants to add an additional ratings system that allows customers
to rate their runner, how would you design an additional table for this dataset - generate
a schema for this new table and insert your own data for ratings for each successful customer
order between 1 to 5 */

DROP TABLE IF EXISTS ratings;
CREATE TABLE ratings (
order_id int,
rating int);

INSERT INTO ratings VALUES 
(1, 5), (2, 3), (3, 4), (4, 2), (5,3), (7, 3), (8, 4), (10, 5);

SELECT * FROM ratings;

/* 4. Using your newly generated table - can you join all the information together to form
a table which has the following information for successful deliveries?
- customer_id
- order_id
- runner_id
- rating
- order_time
- pickup_time
- Time between order and pickup
- delivery duration
- average speed
- total number of pizzas */
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

/* 5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras
and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have
left over after these deliveries? */
SET @total_price_pizza = 138;
SELECT
	@total_price_pizza - (SUM(duration))*0.3 AS final_price
FROM temp_runner_orders;

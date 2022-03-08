<h1 align="center">Case Study #2 - Pizza Runner</h1>

<p align="center">
<img width=500 src="https://user-images.githubusercontent.com/79323632/156700408-3869efd2-82da-4fcb-8403-137e1cddc845.png">
</p>


<h2 align="center">Introduction</h2>
<p align="justify">
Did you know that over 115 million kilograms of pizza is consumed daily worldwide??? (Well according to Wikipedia anyway…)
Danny was scrolling through his Instagram feed when something really caught his eye - “80s Retro Styling and Pizza Is The Future!”. Danny was sold on the idea, but he knew that pizza alone was not going to help him get seed funding to expand his new Pizza Empire - so he had one more genius idea to combine with it - he was going to Uberize it - and so Pizza Runner was launched!. Danny started by recruiting “runners” to deliver fresh pizza from Pizza Runner Headquarters (otherwise known as Danny’s house) and also maxed out his credit card to pay freelance developers to build a mobile app to accept orders from customers.</p>

<h2 align="center">Available Data</h2>
<p align="justify">Because Danny had a few years of experience as a data scientist - he was very aware that data collection was going to be critical for his business’ growth. 
 He has prepared for us an entity relationship diagram of his database design but requires further assistance to clean his data and apply some basic calculations so he can 
 better direct his runners and optimise Pizza Runner’s operations. All datasets exist within the pizza_runner database schema - be sure to include this reference within your 
 SQL scripts as you start exploring the data and answering the case study questions.</p>

<h2 align="center">Entity Relationship Diagram</h2>
<p align="center">
<img width=500 src="https://user-images.githubusercontent.com/79323632/156702122-db696385-8794-4598-b7f7-f4855cd324cc.png">
</p>

```
CREATE SCHEMA pizza_runner; # create schema to store the data
USE pizza_runner; # use pizza_runner as we want to create tables on it

# create runners table that consists runner_id and registration_date
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
```

<h2 align="center">Case Study Question</h2>
<p align="justify">
This case study has LOTS of questions - they are broken up by area of focus including:

* Pizza Metrics
* Runner and Customer Experience
* Ingredient Optimisation
* Pricing and Ratings
* Bonus DML Challenges (DML = Data Manipulation Language)
Each of the following case study questions can be answered using a single SQL statement.
Again, there are many questions in this case study - please feel free to pick and choose which ones you’d like to try!
 </p>
 
 <h2 align="center"> Data Cleaning</h2>
 <p align="justify">
 Before you start writing your SQL queries however - you might want to investigate the data, you may want to do something with some of those null values and data types in the customer_orders and runner_orders tables!
  1. I converted blanks and 'null' values into null in runner_orders table by creating temporary table
  2. I converted null and 'null' values into blanks in customer_orders by creating temporary table
 </p>
 
 ```
 # Runner orders temporary table
DROP TEMPORARY TABLE IF EXISTS temp_runner_orders;
CREATE TEMPORARY TABLE temp_runner_orders (
SELECT 
	order_id,
    	runner_id,
    	CASE 
		WHEN pickup_time LIKE '%null%' THEN ' ' 
        ELSE pickup_time
	END AS pickup_time,
    	CASE
	  WHEN distance LIKE '%null%' THEN ' '
	  WHEN distance LIKE '%km%' THEN TRIM('km' from distance)
	  ELSE distance 
    	END AS distance,
  	CASE
	  WHEN duration LIKE '%null%' THEN ' '
	  WHEN duration LIKE '%mins%' THEN TRIM('mins' from duration)
	  WHEN duration LIKE '%minute%' THEN TRIM('minute' from duration)
	  WHEN duration LIKE '%minutes%' THEN TRIM('minutes' from duration)
	  ELSE duration
	END AS duration,
  	CASE
	  WHEN cancellation IS NULL or cancellation LIKE '%null%' THEN ' '
	  ELSE cancellation
	END AS cancellation
FROM runner_orders);

ALTER TABLE temp_runner_orders
MODIFY COLUMN pickup_time DATETIME,
MODIFY COLUMN distance FLOAT,
MODIFY COLUMN duration INT;

-- Customer orders temporary table
DROP TEMPORARY TABLE IF EXISTS temp_customer_orders;
CREATE TEMPORARY TABLE temp_customer_orders (
SELECT
	order_id,
    customer_id,
    pizza_id,
    CASE
	WHEN exclusions LIKE '%null%' THEN ' '
	ELSE exclusions
	END AS exclusions,
    CASE
	WHEN extras LIKE '%null%' THEN ' '
        WHEN extras is null THEN ' '
	ELSE extras
	END AS extras,
    order_date
FROM customer_orders);
 ```
 
 <h2 align="left">A. Pizza Metrics</h2>
 
  1. How many pizzas were ordered?
  2. How many unique customer orders were made?
  3. How many successful orders were delivered by each runner?
  4. How many of each type of pizza was delivered?
  5. How many Vegetarian and Meatlovers were ordered by each customer?
  6. What was the maximum number of pizzas delivered in a single order?
  7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
  8. How many pizzas were delivered that had both exclusions and extras?
  9. What was the total volume of pizzas ordered for each hour of the day?
  10. What was the volume of orders for each day of the week?
  
  You can find the solution <a href="https://github.com/agneschintia/MySQL-Projects/blob/myportfolio/Pizza%20Metrics.md">here</a>

<h2 align="left">B. Runner and Customer Experience</h2>

  1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
  2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
  3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
  4. What was the average distance travelled for each customer?
  5. What was the difference between the longest and shortest delivery times for all orders?
  6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
  7. What is the successful delivery percentage for each runner?
  
  You can find the solution <a href="https://github.com/agneschintia/MySQL-Projects/blob/myportfolio/Runner%20and%20Customer%20Experience.md">here</a>
 
 <h2 align="left">C. Ingredient Optimisation</h2>
 
  1. What are the standard ingredients for each pizza?
  2. What was the most commonly added extra?
  3. What was the most common exclusion?
  4. Generate an order item for each record in the customers_orders table in the format of one of the following:
      * Meat Lovers
      * Meat Lovers - Exclude Beef
      * Meat Lovers - Extra Bacon
      * Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
  5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
      * For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
  6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?
  
  You can find the solution <a href="https://github.com/agneschintia/MySQL-Projects/blob/myportfolio/Ingredient%20Optimization.md">here</a>
 
  <h2 align="left">D. Pricing and Ratings</h2>
  
  1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
  2. What if there was an additional $1 charge for any pizza extras?
      * Add cheese is $1 extra
  3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
  4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
      * customer_id
      * order_id
      * runner_id
      * rating
      * order_time
      * pickup_time
      * Time between order and pickup
      * Delivery duration
      * Average speed
      * Total number of pizzas
  5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?
  
  You can find the solution <a href="https://github.com/agneschintia/MySQL-Projects/blob/myportfolio/Pricing%20and%20Ratings.md">here</a>
  
   <h2 align="left">Bonus Question</h2>
   
   If Danny wants to expand his range of pizzas - how would this impact the existing data design? Write an INSERT statement to demonstrate what would happen if a new Supreme pizza with all the toppings was added to the Pizza Runner menu?

<h1 align="center">Ingridient Optimization</h1>

<h3 align="left">1. What are the standard ingredients for each pizza?</h3>

```
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
```

Result: </br>
<img width="147" alt="1" src="https://user-images.githubusercontent.com/79323632/156979480-d39fce8d-9dd0-4fd9-ab31-88fe2674cf36.PNG">
* The standard ingredients for Meatlovers pizza are bacon, bbq sauce, beef, cheese, chicken, mushrooms, pepperoni, and salami.
* The standard ingredients for Vegetarian pizza are cheese, mushrooms, onions, peppers, tomatoes, and tomato sauce.

<h3 align="left">2. What was the most commonly added extra?</h3>

```
SELECT
	extras,
    topping_name,
    COUNT(extras) AS extras_counts
FROM temp_extras te
JOIN pizza_toppings pt ON te.extras = pt.topping_id
GROUP BY extras;
```

Result: </br>
<img width="183" alt="2" src="https://user-images.githubusercontent.com/79323632/156979887-bd480b4e-f91a-4a1b-b71f-51330406ea35.PNG">
* There are customers who ask for extra bacon 4 times.
* There are customers who as for extra each cheese and chicken once.

<h3 align="left">3. What was the most common exclusion?</h3>

```
SELECT
	exclusions,
    topping_name,
    COUNT(exclusions) AS exclusion_counts
FROM temp_exclusion tx
JOIN pizza_toppings pt ON tx.exclusions = pt.topping_id
GROUP BY exclusions
ORDER BY exclusion_counts desc;
```

Result: </br>
<img width="208" alt="3" src="https://user-images.githubusercontent.com/79323632/156980851-c4bbc871-3d40-4837-94a7-66eda35c8b20.PNG">
* There are customers who ask to exclude cheese 4 times,
* There are customers who ask to exclude each bbq sauce and mushrooms once.

<h3 align="left">4. Generate an order item for each record in the customers_orders table in the format of one of the following: </br>
a. Meat Lovers </br>
b. Meat Lovers - Exclude Beef </br>
c. Meat Lovers - Extra Bacon </br>
d. Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers </br></h3>

```
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
```

Result: </br>
<img width="486" alt="4" src="https://user-images.githubusercontent.com/79323632/156981703-c857968a-6c46-4d0c-b1bf-d03c63e25c1c.PNG">

<h3 align="left">5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients</br>
For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"</h3>

```
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
```

Result: </br>
<img width="518" alt="5" src="https://user-images.githubusercontent.com/79323632/156981980-80cf37e2-e099-4265-bc29-b5571acd6e5f.PNG">

<h3 align="left">6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?</h3>

```
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
GROUP BY tpr.toppings
ORDER BY qty_ingredient desc;
```
Result: </br>
<img width="249" alt="6" src="https://user-images.githubusercontent.com/79323632/156982883-3e4eb154-39e0-4df9-8788-382d0f292899.PNG">

<h2 align="center">Customer Nodes Exploration</h2>

<p>
  1. How many unique codes are there on the Data Bank system?
 
```
SELECT
	COUNT(DISTINCT node_id) AS unique_nodes
FROM customer_nodes; 
```
Result: <br>
<img width="80" alt="cne - 1" src="https://user-images.githubusercontent.com/79323632/175249294-5f754da6-4bab-4f7b-83d0-f8dbfe99fe9b.PNG">
* There are 5 unique codes on Data Bank system

 2. What is the number of nodes per region?
  
  ```
  SELECT
	r.region_name,
	COUNT(cn.node_id) AS num_nodes
FROM regions r
JOIN customer_nodes cn ON r.region_id = cn.region_id
GROUP BY r.region_name;
 ```
Result: <br>
<img width="121" alt="cne - 2" src="https://user-images.githubusercontent.com/79323632/175250448-f28d5d1f-a6ed-470e-aa49-aae17ec353ff.PNG">

3. How many customers are allocated to each region?
```
SELECT
	r.region_name,
	COUNT(cn.customer_id) AS num_nodes
FROM regions r
JOIN customer_nodes cn ON r.region_id = cn.region_id
GROUP BY r.region_name;
```
Result: <br>
<img width="120" alt="cne - 3" src="https://user-images.githubusercontent.com/79323632/175250788-4e947b9a-dd69-495b-94eb-2c1e190f6b15.PNG">

4. How many days on average are customers reallocated to a different node?
```
WITH sum_diff_day AS (
SELECT 
	customer_id, node_id, start_date, end_date,
    SUM(DATEDIFF(end_date, start_date)) AS sum_diff
FROM customer_nodes
WHERE end_date != '9999-12-31'
GROUP BY customer_id, node_id, start_date, end_date
ORDER BY customer_id, node_id)
SELECT 
	ROUND(AVG(sum_diff),0) AS avg_reallocated_days
FROM sum_diff_day;
```
Result: <br>
<img width="99" alt="cne - 4" src="https://user-images.githubusercontent.com/79323632/175251123-6134daea-629e-472c-8589-462ab7fb9447.PNG">

 5. What is the median, 80th and 95th percentile for this same reallocation days metric for each region?
 

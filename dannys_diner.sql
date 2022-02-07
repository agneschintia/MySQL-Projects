CREATE SCHEMA dannys_diner;
USE dannys_diner;

CREATE TABLE sales (
customer_id VARCHAR(1),
order_date DATE,
product_id INTEGER );

INSERT INTO sales VALUES
('A', '2021-01-01', '1'),
('A', '2021-01-01', '2'),
('A', '2021-01-07', '2'),
('A', '2021-01-10', '3'),
('A', '2021-01-11', '3'),
('A', '2021-01-11', '3'),
('B', '2021-01-01', '2'),
('B', '2021-01-02', '2'),
('B', '2021-01-04', '1'),
('B', '2021-01-11', '1'),
('B', '2021-01-16', '3'),
('B', '2021-02-01', '3'),
('C', '2021-01-01', '3'),
('C', '2021-01-01', '3'),
('C', '2021-01-07', '3');

SELECT * from menu;

CREATE TABLE menu (
product_id INTEGER,
product_name VARCHAR(10),
price VARCHAR(2));

INSERT INTO menu VALUES
(1, "sushi", "10"), (2, "curry", "15"), (3, "ramen", "12");

CREATE TABLE members (
customer_id VARCHAR(1),
join_date DATE );

INSERT INTO members VALUES 
("A", "2021-01-07"), ("B", "2021-01-09");

-- cari yang paling banyak dipesan
WITH temp AS (
	SELECT 
		row_number() OVER(order by s.product_id) AS max_product_id
	FROM sales s
    ) 
select max_product_id from temp;

select * from sales;

-- 1. What is the total amount each customer spent at the restaurant?
SELECT 
	s.customer_id,
    SUM(m.price) AS price
FROM sales s
JOIN menu m ON s.product_id = m.product_id
GROUP BY s.customer_id;

-- 2. How many days has each customer visited
SELECT 
	customer_id,
	COUNT(DISTINCT order_date) AS freq_visit
FROM sales
GROUP BY customer_id;

-- 3. What was the first item from the menu purchased by each customer
WITH cte_order_ranks AS (
	SELECT 
		s.customer_id,
        s.order_date,
        m.product_name,
        DENSE_RANK() OVER(PARTITION BY s.customer_id ORDER BY s.order_date) AS order_ranks
	FROM sales s
    JOIN menu m ON m.product_id = s.product_id)
SELECT 	customer_id, product_name
FROM cte_order_ranks
WHERE order_ranks = '1'
GROUP BY customer_id, product_name;

-- 4. What is the most purchased item and how many times it is purchased by customer
SELECT 
    m.product_name,
    COUNT(s.product_id) AS product_count
FROM menu m
JOIN sales s ON m.product_id = s.product_id
GROUP BY product_name
ORDER BY product_count DESC
LIMIT 1;

-- 5. Which item was the most popular for each customer
WITH cte_items AS(
	SELECT 
		s.customer_id,
        m.product_name,
        COUNT(m.product_id) AS order_count,
        dense_rank() OVER(PARTITION BY s.customer_id order by count(s.customer_id)desc) AS ranks_item
	FROM menu m
    JOIN sales s on s.product_id = m.product_id
    GROUP BY s.customer_id, m.product_name) 
SELECT
	customer_id,
    product_name,
    order_count
FROM cte_items
WHERE ranks_item = 1;


-- 6. Which item was purchased first by the customer after they became a member
WITH cte_members AS (
	SELECT
		s.customer_id,
        s.product_id,
        mb.join_date,
        s.order_date,
        DENSE_RANK() OVER(PARTITION BY s.customer_id ORDER BY s.order_date) AS rank_member
	FROM sales s
    JOIN members mb ON s.customer_id = mb.customer_id
    WHERE s.order_date >= mb.join_date)
SELECT 
	cm.customer_id,
    cm.order_date,
    m.product_name
FROM cte_members cm
JOIN menu m ON cm.product_id = m.product_id
WHERE rank_member = 1
ORDER BY cm.customer_id;

-- 7. Which item was puchased just before the customer become a member
WITH cte_before_member AS (
	SELECT 
		s.customer_id,
        s.product_id,
        mb.join_date,
        s.order_date,
        DENSE_RANK() OVER(PARTITION BY s.customer_id ORDER BY s.order_date desc) AS rank_members
	FROM sales s
    JOIN members mb ON s.customer_id = mb.customer_id
    WHERE s.order_date < mb.join_date)
SELECT bm.customer_id, bm.order_date, m.product_name
FROM cte_before_member bm
JOIN menu m ON bm.product_id = m.product_id
WHERE rank_members = 1
ORDER BY bm.customer_id;

-- 8. What is the total items and amount spent for each member before they become a member
SELECT
	s.customer_id,
	m.product_name,
    COUNT(s.product_id) AS total_items,
    SUM(m.price) AS price
FROM sales s 
JOIN members mb ON s.customer_id = mb.customer_id
JOIN menu m ON s.product_id = m.product_id
WHERE s.order_date < mb.join_date
GROUP BY s.customer_id;

/* 9. If each $1 spent equates to 10 points and sushi has a 2x point multiplier - 
how many points would each customer have? */
WITH price_point AS (
	SELECT *,
		CASE 
			WHEN product_name = "sushi" THEN price * 20
            ELSE price * 10
		END AS points
	FROM menu)
SELECT 
	s.customer_id,
    SUM(p.points) AS total_point
FROM price_point p
JOIN sales s ON p.product_id = s.product_id
GROUP BY s.customer_id;

/* 10. In the first week after a customer joins the program (including their join date) they
earn 2x points on all items, not just sushi - how many points do customer A and B have at the 
end of January */
WITH dates AS (
	SELECT 
		*,
		DATE_ADD(join_date, INTERVAL 6 DAY) AS firstweek_join,
        LAST_DAY('2021-01-31') AS last_date
	FROM members mb)
SELECT 
	dt.customer_id,
    dt.join_date,
    dt.firstweek_join,
    dt.last_date,
    s.order_date,
	m.product_name,
    m.price,
		SUM(CASE
				WHEN m.product_name = 'sushi' THEN m.price*2*10
                WHEN s.order_date BETWEEN dt.join_date AND dt.firstweek_join THEN m.price*2*10
                ELSE m.price*10 
			END) AS points
FROM dates dt
JOIN sales s ON s.customer_id = dt.customer_id
JOIN menu m ON m.product_id = s.product_id
WHERE s.order_date < dt.firstweek_join
GROUP BY dt.customer_id;

/* BONUS QUESTION
- Join all the things and recreate customer_id, order_date, product_name, price, member[Y/N]
*/
SELECT 
	s.customer_id,
    s.order_date,
    m.product_name,
    m.price,
		CASE
			WHEN mb.join_date > s.order_date THEN 'N'
            WHEN mb.join_date <= s.order_date THEN 'Y'
            ELSE 'N'
		END AS is_member
	FROM sales s
    LEFT JOIN menu m ON s.product_id = m.product_id
    LEFT JOIN members mb ON mb.customer_id = s.customer_id
    ORDER BY s.customer_id;
    
    /* Danny also requires further information about the ranking of customer products, but he
    purposely does not need the ranking for non-member purchases so he expects null
    ranking values for the records when customers are not yet part of the loyalty program */
    WITH joined_table AS (
    SELECT 
	s.customer_id,
    s.order_date,
    m.product_name,
    m.price,
		CASE
			WHEN mb.join_date > s.order_date THEN 'N'
            WHEN mb.join_date <= s.order_date THEN 'Y'
            ELSE 'N'
		END AS is_member
	FROM sales s
    LEFT JOIN menu m ON s.product_id = m.product_id
    LEFT JOIN members mb ON mb.customer_id = s.customer_id
    ORDER BY s.customer_id)
SELECT *,
	CASE
		WHEN is_member = 'N' THEN null
        ELSE RANK() OVER(PARTITION BY customer_id, is_member ORDER BY order_date)
	END AS ranks
FROM joined_table;
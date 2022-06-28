<h1 align="center">B. Customer Transactions</h1>

<p>
1. What is the unique count and total amount for each transactions type?
  
```
SELECT
	txn_type,
	COUNT(*) AS unique_count,
  SUM(txn_amount) AS total_amount
FROM customer_transactions
GROUP BY txn_type;  
```
Result: <br>
<img width="177" alt="ct - 1" src="https://user-images.githubusercontent.com/79323632/176088394-8eb0f1d4-30e2-4d0e-a1c6-d216070f2eb4.PNG">

* data bank has done 2671 transactions for deposits and the total amount of deposits is 1359168.
* data bank has done 1617 transactions for purchase and the total amount of purchase is 806537.
* data bank has done 1580 transactions for withdrawal and the total amount of withdrawal is 793003.

2. What is the average total historical deposit counts and amounts for all customers?

```
WITH historical AS (
SELECT
	customer_id,
  txn_type,
	COUNT(*) AS counts,
    AVG(txn_amount) AS amounts
FROM customer_transactions
WHERE txn_type = 'deposit'
GROUP BY customer_id, txn_type)
SELECT
	ROUND(AVG(counts),0) AS avg_count,
    ROUND(AVG(amounts),2) AS avg_amount
FROM historical;
```

Result: <br>
<img width="119" alt="ct - 2" src="https://user-images.githubusercontent.com/79323632/176089385-9d52e7ba-f03e-4a9b-ae49-fc3170fa8b3e.PNG">

* The customer's average for deposits transaction is 5 times and the total amount of average deposits is 508.61.

3. For each month - how many Data Bank customers make more than 1 deposits and either 1 purchase or 1 withdrawal in a single month?

```
WITH monthly_txn AS (
SELECT
	customer_id,
	MONTH(txn_date) AS months,
    SUM(CASE WHEN txn_type = 'deposit' THEN 0 ELSE 1 END) AS deposits,
    SUM(CASE WHEN txn_type = 'purchase' THEN 0 ELSE 1 END) AS purchases,
    SUM(CASE WHEN txn_type = 'withdrawal' THEN 1 ELSE 0 END) AS withdrawal
FROM customer_transactions
GROUP BY customer_id, months)
SELECT
	months,
    COUNT(DISTINCT customer_id) AS customer_cnt
FROM monthly_txn
WHERE deposits >= 2 AND (purchases > 1 OR withdrawal > 1)
GROUP BY months
ORDER BY months;  
```
Result: <br>
<img width="109" alt="ct - 3" src="https://user-images.githubusercontent.com/79323632/176094067-582c6372-eb8b-4ff8-bb49-db33b12bb1cd.PNG">
* In January, 158 customers make more than 1 deposits and either 1 purchase or 1 withdrawal.
* In February, 240 customers make more than 1 deposits and either 1 purchase or 1 withdrawal.
* In March, 263 customers make more than 1 deposits and either 1 purchase or 1 withdrawal.
* In April, 86 customers make more than 1 deposits and either 1 purchase or 1 withdrawal.
  
4. What is the closing balance for each customer at the end of the month?

```
WITH closing AS(
SELECT
	customer_id,
    txn_date,
    LAST_DAY(txn_date) AS ending_month,
    txn_amount,
	CASE 
    WHEN txn_type = 'withdrawal' THEN (-txn_amount)
    WHEN txn_type = 'purchase' THEN (-txn_amount)
	ELSE txn_amount END AS txn_balance
FROM customer_transactions
ORDER BY customer_id, MONTH(txn_date))
SELECT
	customer_id,
    ending_month,
    COALESCE(txn_balance, 0) AS monthly_change,
	SUM(txn_balance) OVER 
      (PARTITION BY customer_id ORDER BY ending_month
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS closing_balance
FROM closing
GROUP BY customer_id, txn_date;
```
  
Result: <br>
<img width="268" alt="ct - 4" src="https://user-images.githubusercontent.com/79323632/176094107-5bec1f6d-5e6a-4415-adb6-e96ae1018835.PNG">
* This is the result of each customer's closing balance on each month.

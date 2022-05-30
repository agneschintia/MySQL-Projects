# Case Study #3: Foodie Fi
### Customer Journey Solution

Based off the 8 sample customers provided in the sample from the subscriptions table, write a brief description about each customer’s onboarding journey.

**Answer:**
```
SELECT
    s.customer_id,
    p.plan_name,
    s.start_date
FROM subscriptions s
JOIN plans p ON s.plan_id = p.plan_id;
```



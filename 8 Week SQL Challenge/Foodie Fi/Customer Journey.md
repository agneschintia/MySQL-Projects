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

We can take a look on the Customer 6's journey

<img width="179" alt="customer journey - 2" src="https://user-images.githubusercontent.com/79323632/172094725-7f0c4d00-edec-4b3e-abf1-f624b2cd060b.PNG">

Here we can see that the customer 6's journey starts with the trial on 2020-12-23, and when the trial ends they upgrade to the basic monthly plan on 2020-12-30. After a couple of month they churn the subscriptions on 2021-02-26.

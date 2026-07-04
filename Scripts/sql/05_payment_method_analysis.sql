/*
  Project: Sales Analysis
  Step: Payment Method Analysis
  Description: Queries used to evaluate sales distribution by payment method.
*/

USE db_sales;

-- Objective: Total revenue by payment method (used in "Payment Method Distribution" donut chart)
SELECT
    pm.payment_method,
    SUM(s.revenue) AS total_revenue
FROM sales s
JOIN payment_methods pm ON s.payment_id = pm.payment_id
GROUP BY pm.payment_method
ORDER BY total_revenue DESC;

-- Objective: Percentage share of revenue by payment method
SELECT
    pm.payment_method,
    SUM(s.revenue) AS total_revenue,
    SUM(s.revenue) / (SELECT SUM(revenue) FROM sales) * 100 AS revenue_percentage
FROM sales s
JOIN payment_methods pm ON s.payment_id = pm.payment_id
GROUP BY pm.payment_method
ORDER BY revenue_percentage DESC;

-- Objective: Find the predominant (most used) payment method
SELECT
    pm.payment_method,
    COUNT(s.transaction_id) AS total_transactions
FROM sales s
JOIN payment_methods pm ON s.payment_id = pm.payment_id
GROUP BY pm.payment_method
ORDER BY total_transactions DESC
LIMIT 1;

-- Objective: Units sold by payment method (used to identify electronic payments' impact on volume)
SELECT
    pm.payment_method,
    SUM(s.units) AS total_units,
    SUM(s.units) / (SELECT SUM(units) FROM sales) * 100 AS units_percentage
FROM sales s
JOIN payment_methods pm ON s.payment_id = pm.payment_id
GROUP BY pm.payment_method
ORDER BY units_percentage DESC;
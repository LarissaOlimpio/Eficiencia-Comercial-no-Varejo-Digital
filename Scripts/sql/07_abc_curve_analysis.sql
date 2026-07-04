/*
  Project: Sales Analysis
  Step: ABC Curve Analysis
  Description: Classifies products into A, B, and C classes based on their contribution
               to cumulative revenue (Pareto principle).
*/

USE db_sales;

-- Objective: Rank products by revenue and classify them into A (top 80%), B (next 15%), and C (remaining 5%)
WITH ProductRevenue AS (
    SELECT
        p.product_name,
        SUM(s.revenue) AS total_revenue
    FROM sales s
    JOIN products p ON s.product_id = p.product_id
    GROUP BY p.product_name
),
RunningTotal AS (
    SELECT
        product_name,
        total_revenue,
        SUM(total_revenue) OVER (ORDER BY total_revenue DESC) AS cumulative_revenue,
        SUM(total_revenue) OVER () AS grand_total
    FROM ProductRevenue
)
SELECT
    product_name,
    total_revenue,
    (cumulative_revenue / grand_total) * 100 AS cumulative_percentage,
    CASE
        WHEN (cumulative_revenue / grand_total) <= 0.80 THEN 'A'
        WHEN (cumulative_revenue / grand_total) <= 0.95 THEN 'B'
        ELSE 'C'
    END AS abc_class
FROM RunningTotal;
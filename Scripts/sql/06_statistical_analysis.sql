/*
  Project: Sales Analysis
  Step: Statistical Analysis
  Description: General statistical indicators, correlations, and outlier detection.
*/

USE db_sales;

-- Objective: Overall average ticket (average revenue per transaction) -> "Average Ticket" KPI card
SELECT AVG(revenue) AS average_ticket
FROM sales;

-- Objective: Company-wide totals used in the Executive Overview KPI cards
SELECT
    SUM(revenue) AS total_revenue,
    SUM(units) AS total_units_sold,
    COUNT(transaction_id) AS total_orders
FROM sales;

-- Objective: Revenue variation between January and August (used in "Variation Jan -> Aug" KPI card)
SELECT
    (SELECT SUM(revenue) FROM sales WHERE month = 1) AS january_revenue,
    (SELECT SUM(revenue) FROM sales WHERE month = 8) AS august_revenue,
    ((SELECT SUM(revenue) FROM sales WHERE month = 8) -
     (SELECT SUM(revenue) FROM sales WHERE month = 1)) /
     (SELECT SUM(revenue) FROM sales WHERE month = 1) * 100 AS variation_percentage
FROM sales
LIMIT 1;

-- Objective: Price vs. volume data points (used in "Sales Correlation: Price vs Volume" scatter chart)
SELECT
    unit_price,
    units,
    revenue
FROM sales
ORDER BY unit_price;

-- Objective: Monthly revenue trend across the whole company (used to investigate seasonality)
SELECT
    year,
    month,
    month_name,
    SUM(revenue) AS monthly_revenue
FROM sales
GROUP BY year, month, month_name
ORDER BY year, month;

-- Objective: Detect outlier transactions based on units sold, using standard deviation (Z-score).
-- A transaction is considered an outlier when its unit count is more than 2 standard
-- deviations above the average for its category.
WITH CategoryStats AS (
    SELECT
        p.category,
        AVG(s.units) AS avg_units,
        STDDEV(s.units) AS stddev_units
    FROM sales s
    JOIN products p ON s.product_id = p.product_id
    GROUP BY p.category
)
SELECT
    s.transaction_id,
    p.category,
    p.product_name,
    s.units,
    cs.avg_units,
    cs.stddev_units,
    (s.units - cs.avg_units) / NULLIF(cs.stddev_units, 0) AS z_score
FROM sales s
JOIN products p ON s.product_id = p.product_id
JOIN CategoryStats cs ON p.category = cs.category
WHERE (s.units - cs.avg_units) / NULLIF(cs.stddev_units, 0) > 2
ORDER BY z_score DESC;
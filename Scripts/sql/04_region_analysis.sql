/*
  Project: Sales Analysis
  Step: Region Analysis
  Description: Queries used to evaluate revenue and volume performance by region.
*/

USE db_sales;

-- Objective: Total revenue by region (used in "Revenue by Region" chart)
SELECT
    r.region,
    SUM(s.revenue) AS total_revenue
FROM sales s
JOIN regions r ON s.region_id = r.region_id
GROUP BY r.region
ORDER BY total_revenue DESC;

-- Objective: Total units sold by region
SELECT
    r.region,
    SUM(s.units) AS total_units
FROM sales s
JOIN regions r ON s.region_id = r.region_id
GROUP BY r.region
ORDER BY total_units DESC;

-- Objective: Find the region with the highest revenue
SELECT
    r.region,
    SUM(s.revenue) AS total_revenue
FROM sales s
JOIN regions r ON s.region_id = r.region_id
GROUP BY r.region
ORDER BY total_revenue DESC
LIMIT 1;

-- Objective: Units sold by region, broken down by category
-- (used in "Units Sold Distribution by Region" chart, e.g. Clothing ~145 units in Asia, Books ~114 in North America)
SELECT
    r.region,
    p.category,
    SUM(s.units) AS total_units
FROM sales s
JOIN regions r ON s.region_id = r.region_id
JOIN products p ON s.product_id = p.product_id
GROUP BY r.region, p.category
ORDER BY r.region, total_units DESC;

-- Objective: Revenue concentration of a specific category within a region (e.g. Electronics in North America)
-- Shows the % of Electronics revenue coming from a single region -> concentration risk
SELECT
    r.region,
    SUM(s.revenue) AS category_region_revenue,
    (SELECT SUM(s2.revenue)
     FROM sales s2
     JOIN products p2 ON s2.product_id = p2.product_id
     WHERE p2.category = 'Electronics') AS category_total_revenue,
    SUM(s.revenue) /
    (SELECT SUM(s2.revenue)
     FROM sales s2
     JOIN products p2 ON s2.product_id = p2.product_id
     WHERE p2.category = 'Electronics') * 100 AS concentration_percentage
FROM sales s
JOIN products p ON s.product_id = p.product_id
JOIN regions r ON s.region_id = r.region_id
WHERE p.category = 'Electronics'
GROUP BY r.region
ORDER BY concentration_percentage DESC;

-- Objective: Overall revenue share of each region relative to total company revenue
-- (used to support the 46.4% North America concentration insight)
SELECT
    r.region,
    SUM(s.revenue) AS total_revenue,
    SUM(s.revenue) / (SELECT SUM(revenue) FROM sales) * 100 AS revenue_share_percentage
FROM sales s
JOIN regions r ON s.region_id = r.region_id
GROUP BY r.region
ORDER BY revenue_share_percentage DESC;
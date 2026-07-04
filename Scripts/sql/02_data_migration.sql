/*
  Project: Sales Analysis
  Step: Data Migration (Populate Star Schema)
  Description: Load data from the single treated table (online_sales.vendas_tratada)
               into the dimension and fact tables of db_sales.
*/

use db_sales;
-- 1. Populate Dimension Tables
-- Note: DISTINCT ensures each dimension value is inserted only once,
-- and the AUTO_INCREMENT id is generated automatically for each row.

INSERT INTO products (product_name, category)
SELECT DISTINCT Produto, Categoria
FROM online_sales.vendas_tratada;

INSERT INTO regions (region)
SELECT DISTINCT Regiao
FROM online_sales.vendas_tratada;

INSERT INTO payment_methods (payment_method)
SELECT DISTINCT Pagamento
FROM online_sales.vendas_tratada;

-- 2. Populate Fact Table
-- Join the source table with each dimension to translate text values
-- into the generated surrogate keys (product_id, region_id, payment_id).

INSERT INTO sales (
    transaction_id,
    date,
    year,
    month,
    month_name,
    quarter,
    product_id,
    region_id,
    payment_id,
    units,
    unit_price,
    revenue
)
SELECT
    v.TransactionID,
    v.Data,
    v.Ano,
    v.Mes,
    v.MesNome,
    v.Trimestre,
    p.product_id,
    r.region_id,
    pm.payment_id,
    v.Unidades,
    v.PrecoUnit,
    v.Receita
FROM online_sales.vendas_tratada v
JOIN products        p  ON v.Produto  = p.product_name AND v.Categoria = p.category
JOIN regions          r  ON v.Regiao   = r.region
JOIN payment_methods  pm ON v.Pagamento = pm.payment_method;

-- 3. Validation checks
-- Compare row counts to make sure no records were lost in the joins.
SELECT
    (SELECT COUNT(*) FROM online_sales.vendas_tratada) AS source_rows,
    (SELECT COUNT(*) FROM sales) AS fact_rows;

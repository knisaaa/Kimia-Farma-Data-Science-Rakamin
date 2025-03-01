CREATE TABLE kimia_farma.Tabel_Analisa AS
SELECT
  ft.transaction_id,
  ft.date,
  ft.branch_id,
  kc.branch_name,
  kc.kota,
  kc.provinsi,
  kc.rating AS rating_cabang,
  ft.customer_name,
  ft.product_id,
  kp.product_name,
  kp.price AS actual_price,
  ft.discount_percentage,
  CASE
    WHEN ft.price <= 50000 THEN 10
    WHEN ft.price > 50000 - 100000 THEN 15
    WHEN ft.price > 100000 - 300000 THEN 20
    WHEN ft.price > 300000 - 500000 THEN 25
    WHEN ft.price > 500000 THEN 30
    ELSE 0
  END AS persentase_gross_laba,
  ft.price*(1-ft.discount_percentage) AS nett_sales,
  (
    SELECT SUM(price)-SUM(price*discount_percentage)
    FROM kimia_farma.kf_final_transaction
  ) AS nett_profit,
  ft.rating AS rating_transaksi
FROM kimia_farma.kf_final_transaction AS ft
JOIN kimia_farma.kf_kantor_cabang AS kc
ON ft.branch_id = kc.branch_id
JOIN kimia_farma.kf_product AS kp
ON ft.product_id = kp.product_id
ORDER BY ft.date
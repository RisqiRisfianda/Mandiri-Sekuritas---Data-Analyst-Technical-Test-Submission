SELECT 
  client_id,
  COUNT(*) AS total_transactions,
  SAFE_CAST(COUNT(*) / COUNT(DISTINCT FORMAT_DATE('%Y-%m', DATE(date))) as INT) AS avg_monthly_transactions,
  CASE 
    WHEN SAFE_CAST(COUNT(*) / COUNT(DISTINCT FORMAT_DATE('%Y-%m', DATE(date))) as INT) > 100 then 'Frequent'
    WHEN SAFE_CAST(COUNT(*) / COUNT(DISTINCT FORMAT_DATE('%Y-%m', DATE(date))) as INT) >= 50 and SAFE_CAST(COUNT(*) / COUNT(DISTINCT FORMAT_DATE('%Y-%m', DATE(date))) as INT) <=100 then 'Regular'
    ELSE 'Infrequent'
END AS avg_monthly_transactions_category,
  ROUND(SUM(CAST(LTRIM(amount, '$') AS FLOAT64)),2) AS total_amount,
  ROUND(AVG(CAST(LTRIM(amount, '$') AS FLOAT64)),2) AS avg_transaction_amount
FROM 
  `encoded-horizon-463806-e8.mandiri_sekuritas.transactions_data`
GROUP BY
  client_id

SELECT 
  client_id,
  COUNT(*) AS total_transactions,
  SAFE_CAST(COUNT(*) / COUNT(DISTINCT FORMAT_DATE('%Y-%m', DATE(date))) as INT) AS avg_monthly_transactions,
  ROUND(SUM(CAST(LTRIM(amount, '$') AS FLOAT64)),2) AS total_amount,
  ROUND(AVG(CAST(LTRIM(amount, '$') AS FLOAT64)),2) AS avg_transaction_amount
FROM 
  transactions_data
GROUP BY
  client_id

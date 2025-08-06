SELECT 
  u.id AS user_id,
  CAST(LTRIM(u.total_debt, '$') AS FLOAT64) AS total_debt,
  SUM(c.credit_limit) AS total_credit_limit,
  ROUND(SAFE_DIVIDE(CAST(LTRIM(u.total_debt, '$') AS FLOAT64), SUM(c.credit_limit)),2) AS debt_to_credit_ratio,
  CASE 
    WHEN ROUND(SAFE_DIVIDE(CAST(LTRIM(u.total_debt, '$') AS FLOAT64), SUM(c.credit_limit)),2) <0.3 THEN 'Healthy'
    WHEN ROUND(SAFE_DIVIDE(CAST(LTRIM(u.total_debt, '$') AS FLOAT64), SUM(c.credit_limit)),2) >=0.3 and ROUND(SAFE_DIVIDE(CAST(LTRIM(u.total_debt, '$') AS FLOAT64), SUM(c.credit_limit)),2) <=0.5 THEN 'Watchful'
    WHEN ROUND(SAFE_DIVIDE(CAST(LTRIM(u.total_debt, '$') AS FLOAT64), SUM(c.credit_limit)),2) >0.5 THEN 'Risk'
  END AS interpretasi
FROM 
  users_data AS u
JOIN 
  cards_data AS c
  ON u.id = c.client_id
GROUP BY 
  u.id, u.total_debt

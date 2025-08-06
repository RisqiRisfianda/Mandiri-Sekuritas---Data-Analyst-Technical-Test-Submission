SELECT 
  u.id AS user_id,
  u.credit_score,
  COUNT(c.id) AS total_cards
FROM 
  users_data AS u
JOIN 
  cards_data AS c
  ON u.id = c.client_id
GROUP BY 
  u.id, u.credit_score
HAVING 
  u.credit_score < 600 AND COUNT(c.id) > 3

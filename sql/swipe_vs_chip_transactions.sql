SELECT
total_cards,
COUNT(client_id) AS total_user
FROM (
  SELECT 
    client_id,
    COUNT(*) AS total_cards
  FROM 
    cards_data
  GROUP BY 
    client_id
  )
GROUP BY total_cards
ORDER BY total_cards

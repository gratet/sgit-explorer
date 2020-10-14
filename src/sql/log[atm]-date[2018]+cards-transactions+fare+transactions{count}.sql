
SELECT f.name AS fare, 
  Count(DISTINCT t.card) AS cards,
  Count(t.id) AS transactions
FROM transactions_atm t
  INNER JOIN fares f ON t.fare_id=f.id
GROUP BY f.name
ORDER BY f.name ASC;

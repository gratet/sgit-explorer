
WITH summarize_atm AS (
  SELECT m.name AS municipality,
    Count(t.id) AS atm_trips
  FROM transactions_atm t
    JOIN stops s ON t.stop_id = s.id 
    JOIN municipalities m ON m.id = s.municipality_id
  GROUP BY m.id
), summarize_tp AS (
  SELECT m.name AS municipality,
    Count(t.id) AS tp_trips
  FROM transactions_tp t
    JOIN stops s ON t.stop_id = s.id 
    JOIN municipalities m ON m.id = s.municipality_id
  GROUP BY m.id
), summarize_cols AS(
  SELECT atm.municipality, atm_trips, tp_trips, 
    (atm_trips + tp_trips) AS total_count
  FROM summarize_atm AS atm
    JOIN summarize_tp AS tp USING (municipality)
)
SELECT *
FROM summarize_cols
ORDER BY total_count DESC;


WITH summarized AS(
  SELECT m.name AS municipality, 
    Count(CASE WHEN (time_stamp BETWEEN '2018-06-21' AND '2018-09-23') THEN 1 END) AS summer_total,
    Count(CASE WHEN (time_stamp NOT BETWEEN '2018-06-21' AND '2018-09-23') THEN 1 END) AS non_summer_total,
    Count(t.id) AS total_count
   
  FROM transactions_tp t
  INNER JOIN fares f ON t.fare_id=f.id
  INNER JOIN stops s ON t.stop_id=s.id
  INNER JOIN municipalities m ON s.municipality_id=m.id
  where m.pop_2018 > 20000 and zone_id=140
  GROUP BY municipality_id
  ORDER BY total_count DESC
)
SELECT * FROM summarized;


WITH summer AS(
  SELECT 'Summer' AS summer_or_not,
    f.name AS fare,
    COUNT(CASE WHEN strftime('%w', time_stamp) IN ('1','2','3','4','5') THEN 1 ELSE NULL END) AS week,
    COUNT(CASE WHEN strftime('%w', time_stamp) IN ('0','6') THEN 1 ELSE NULL END) AS weekend
  FROM transactions_atm t
  INNER JOIN fares f on t.fare_id=f.id
  INNER JOIN stops s on t.stop_id=s.id
  WHERE time_stamp BETWEEN '2018-06-21' AND '2018-09-23'
  GROUP BY fare
), not_summer AS(
  SELECT 'Not summer' AS summer_or_not,
    f.name AS fare,
    COUNT(CASE WHEN strftime('%w', time_stamp) IN ('1','2','3','4','5') THEN 1 ELSE NULL END) AS week,
    COUNT(CASE WHEN strftime('%w', time_stamp) IN ('0','6') THEN 1 ELSE NULL END) AS weekend
  FROM transactions_atm t
  INNER JOIN fares f on t.fare_id=f.id
  INNER JOIN stops s on t.stop_id=s.id
  WHERE time_stamp NOT BETWEEN '2018-06-21' AND '2018-09-23'
  GROUP BY fare
)
SELECT * FROM summer
UNION
SELECT * FROM not_summer;

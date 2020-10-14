
WITH summarized_summer AS(
  SELECT f.name AS fare,
    Count(t.id) AS summer
  FROM transactions_atm t
    INNER JOIN fares f ON t.fare_id=f.id
  WHERE time_stamp BETWEEN '2018-06-21' AND '2018-09-23'
  GROUP BY fare_id
), summarized_non_summer AS(
  SELECT f.name AS fare,
    Count(t.id) AS non_summer
  FROM transactions_atm t
    INNER JOIN fares f ON t.fare_id=f.id
  WHERE time_stamp NOT BETWEEN '2018-06-21' AND '2018-09-23'
  GROUP BY fare_id
), summarized_cols AS(
  SELECT s.fare, summer, non_summer, (summer+non_summer) AS total_count
  FROM summarized_summer s
    INNER JOIN summarized_non_summer ns USING(fare)
), summarized_rows AS(
  SELECT 'Total' AS fare, 
    Sum(summer) AS summer, 
    Sum(non_summer) AS non_summer,
    Sum(total_count) AS total_count
  FROM summarized_cols
)
SELECT * FROM summarized_cols
UNION ALL
SELECT * FROM summarized_rows;


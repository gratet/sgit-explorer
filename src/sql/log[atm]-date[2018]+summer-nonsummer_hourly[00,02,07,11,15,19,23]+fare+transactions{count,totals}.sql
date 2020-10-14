
WITH summarized_summer AS(
  SELECT f.name AS fare,
    COUNT(CASE WHEN strftime('%H', time_stamp) IN ('00','01') THEN 1 END) AS summer_00_02,
    COUNT(CASE WHEN strftime('%H', time_stamp) IN ('02','03','04','05','06') THEN 1 END) AS summer_02_07,
    COUNT(CASE WHEN strftime('%H', time_stamp) IN ('07','08','09','10') THEN 1 END) AS summer_07_11,
    COUNT(CASE WHEN strftime('%H', time_stamp) IN ('11','12','13','14') THEN 1 END) AS summer_11_15,
    COUNT(CASE WHEN strftime('%H', time_stamp) IN ('15','16','17','18') THEN 1 END) AS summer_15_19,
    COUNT(CASE WHEN strftime('%H', time_stamp) IN ('19','20','21','22','23') THEN 1 END) AS summer_19_24
  FROM transactions_atm t
  INNER JOIN fares f on t.fare_id=f.id
  INNER JOIN stops s on t.stop_id=s.id
  WHERE time_stamp BETWEEN '2018-06-21' AND '2018-09-23'
  GROUP BY fare
), summarized_non_summer AS(
  SELECT  f.name AS fare,
    COUNT(CASE WHEN strftime('%H', time_stamp) IN ('00','01') THEN 1 END) AS non_summer_00_02,
    COUNT(CASE WHEN strftime('%H', time_stamp) IN ('02','03','04','05','06') THEN 1 END) AS non_summer_02_07,
    COUNT(CASE WHEN strftime('%H', time_stamp) IN ('07','08','09','10') THEN 1 END) AS non_summer_07_11,
    COUNT(CASE WHEN strftime('%H', time_stamp) IN ('11','12','13','14') THEN 1 END) AS non_summer_11_15,
    COUNT(CASE WHEN strftime('%H', time_stamp) IN ('15','16','17','18') THEN 1 END) AS non_summer_15_19,
    COUNT(CASE WHEN strftime('%H', time_stamp) IN ('19','20','21','22','23') THEN 1 END) AS non_summer_19_24
  FROM transactions_atm t
  INNER JOIN fares f on t.fare_id=f.id
  INNER JOIN stops s on t.stop_id=s.id
  WHERE time_stamp NOT BETWEEN '2018-06-21' AND '2018-09-23'
  GROUP BY fare
), summarized_rows AS (
  SELECT * 
  FROM summarized_summer
    JOIN summarized_non_summer USING (fare)
  UNION
  SELECT 'Total' as fare,
    sum(summer_00_02) as summer_00_02,
	sum(summer_02_07) as summer_02_07,
	sum(summer_07_11) as summer_07_11,
	sum(summer_11_15) as summer_11_15,
	sum(summer_15_19) as summer_15_19,
	sum(summer_19_24) as summer_19_24,
    sum(non_summer_00_02) as non_summer_00_02,
	sum(non_summer_02_07) as non_summer_02_07,
	sum(non_summer_07_11) as non_summer_07_11,
	sum(non_summer_11_15) as non_summer_11_15,
	sum(non_summer_15_19) as non_summer_15_19,
	sum(non_summer_19_24) as non_summer_19_24
  FROM summarized_summer
    JOIN summarized_non_summer USING (fare)
), summarized_cols as(
  SELECT *, (summer_00_02+summer_02_07+summer_07_11+summer_11_15+summer_15_19+summer_19_24+non_summer_00_02+non_summer_02_07+non_summer_07_11+non_summer_11_15+non_summer_15_19+non_summer_19_24) as total_count
	FROM summarized_rows
)
SELECT *
FROM summarized_cols;

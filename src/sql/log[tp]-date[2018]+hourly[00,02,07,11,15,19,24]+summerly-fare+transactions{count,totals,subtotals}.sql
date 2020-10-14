
WITH summarized_summer AS(
  SELECT  'Summer' AS season,
    f.name AS fare,
    COUNT(CASE WHEN strftime('%H', time_stamp) IN ('00','01') THEN 1 END) AS trips_00_02,
    COUNT(CASE WHEN strftime('%H', time_stamp) IN ('02','03','04','05','06') THEN 1 END) AS trips_02_07,
    COUNT(CASE WHEN strftime('%H', time_stamp) IN ('07','08','09','10') THEN 1 END) AS trips_07_11,
    COUNT(CASE WHEN strftime('%H', time_stamp) IN ('11','12','13','14') THEN 1 END) AS trips_11_15,
    COUNT(CASE WHEN strftime('%H', time_stamp) IN ('15','16','17','18') THEN 1 END) AS trips_15_19,
    COUNT(CASE WHEN strftime('%H', time_stamp) IN ('19','20','21','22','23') THEN 1 END) AS trips_19_24
  FROM transactions_tp t
  INNER JOIN fares f on t.fare_id=f.id
  WHERE time_stamp BETWEEN '2018-06-21' AND '2018-09-23'
  GROUP BY fare
  UNION
  SELECT  'Summer' AS season,
    '___ Total ___' AS fare,
    COUNT(CASE WHEN strftime('%H', time_stamp) IN ('00','01') THEN 1 END) AS trips_00_02,
    COUNT(CASE WHEN strftime('%H', time_stamp) IN ('02','03','04','05','06') THEN 1 END) AS trips_02_07,
    COUNT(CASE WHEN strftime('%H', time_stamp) IN ('07','08','09','10') THEN 1 END) AS trips_07_11,
    COUNT(CASE WHEN strftime('%H', time_stamp) IN ('11','12','13','14') THEN 1 END) AS trips_11_15,
    COUNT(CASE WHEN strftime('%H', time_stamp) IN ('15','16','17','18') THEN 1 END) AS trips_15_19,
    COUNT(CASE WHEN strftime('%H', time_stamp) IN ('19','20','21','22','23') THEN 1 END) AS trips_19_24
  FROM transactions_tp t
  WHERE time_stamp BETWEEN '2018-06-21' AND '2018-09-23'
), summarized_non_summer AS(
  SELECT  'Not summer' AS season,
    f.name AS fare,
    COUNT(CASE WHEN strftime('%H', time_stamp) IN ('00','01') THEN 1 END) AS trips_00_02,
    COUNT(CASE WHEN strftime('%H', time_stamp) IN ('02','03','04','05','06') THEN 1 END) AS trips_02_07,
    COUNT(CASE WHEN strftime('%H', time_stamp) IN ('07','08','09','10') THEN 1 END) AS trips_07_11,
    COUNT(CASE WHEN strftime('%H', time_stamp) IN ('11','12','13','14') THEN 1 END) AS trips_11_15,
    COUNT(CASE WHEN strftime('%H', time_stamp) IN ('15','16','17','18') THEN 1 END) AS trips_15_19,
    COUNT(CASE WHEN strftime('%H', time_stamp) IN ('19','20','21','22','23') THEN 1 END) AS trips_19_24
  FROM transactions_tp t
  INNER JOIN fares f on t.fare_id=f.id
  WHERE time_stamp NOT BETWEEN '2018-06-21' AND '2018-09-23'
  GROUP BY fare
  UNION
    SELECT  'Not summer' AS season,
    '___ Total ___' AS fare,
    COUNT(CASE WHEN strftime('%H', time_stamp) IN ('00','01') THEN 1 END) AS trips_00_02,
    COUNT(CASE WHEN strftime('%H', time_stamp) IN ('02','03','04','05','06') THEN 1 END) AS trips_02_07,
    COUNT(CASE WHEN strftime('%H', time_stamp) IN ('07','08','09','10') THEN 1 END) AS trips_07_11,
    COUNT(CASE WHEN strftime('%H', time_stamp) IN ('11','12','13','14') THEN 1 END) AS trips_11_15,
    COUNT(CASE WHEN strftime('%H', time_stamp) IN ('15','16','17','18') THEN 1 END) AS trips_15_19,
    COUNT(CASE WHEN strftime('%H', time_stamp) IN ('19','20','21','22','23') THEN 1 END) AS trips_19_24
  FROM transactions_tp t
  WHERE time_stamp NOT BETWEEN '2018-06-21' AND '2018-09-23'
), union_all AS(
  SELECT * FROM summarized_summer
  UNION
  SELECT * FROM summarized_non_summer
), summarized_cols AS (
  SELECT *,  (trips_00_02+trips_02_07+trips_07_11+trips_11_15+trips_15_19+trips_19_24) AS total_count
  FROM union_all
), summarized_rows AS (
  SELECT * FROM summarized_cols
  UNION
  SELECT '___ Total ___' AS season, 
    '___ Total ___' AS fare,
    sum(trips_00_02) as trips_00_02, 
    sum(trips_02_07) as trips_02_07, 
    sum(trips_07_11) as trips_07_11, 
    sum(trips_11_15) as trips_11_15, 
    sum(trips_15_19) as trips_15_19, 
    sum(trips_19_24) as trips_19_24,
    sum(total_count) as total_count
  FROM summarized_cols
  WHERE fare !='___ Total ___'

)
SELECT *
FROM summarized_rows
ORDER BY season, fare ASC;


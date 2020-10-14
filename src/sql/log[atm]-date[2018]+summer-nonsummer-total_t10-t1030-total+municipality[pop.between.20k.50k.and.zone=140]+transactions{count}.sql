
WITH summarized AS(
  SELECT m.name AS municipality, 
    Count(CASE WHEN f.name=='T-10' AND (time_stamp BETWEEN '2018-06-21' AND '2018-09-23') THEN 1 END) AS summer_t10,
    Count(CASE WHEN f.name=='T-10/30' AND (time_stamp BETWEEN '2018-06-21' AND '2018-09-23') THEN 1 END) AS summer_t1030,
    Count(CASE WHEN (time_stamp BETWEEN '2018-06-21' AND '2018-09-23') THEN 1 END) AS summer_total,

    Count(CASE WHEN f.name=='T-10' AND (time_stamp NOT BETWEEN '2018-06-21' AND '2018-09-23') THEN 1 END) AS non_summer_t10,
    Count(CASE WHEN f.name=='T-10/30' AND (time_stamp NOT BETWEEN '2018-06-21' AND '2018-09-23') THEN 1 END) AS non_summer_t1030,
    Count(CASE WHEN (time_stamp NOT BETWEEN '2018-06-21' AND '2018-09-23') THEN 1 END) AS non_summer_total,

    Count(CASE WHEN f.name=='T-10' THEN 1 END) AS total_t10,
    Count(CASE WHEN f.name=='T-10/30' THEN 1 END) AS total_t1030,
    Count(t.id) AS total_count
  FROM transactions_atm t
    INNER JOIN fares f ON t.fare_id=f.id
    INNER JOIN stops s ON t.stop_id=s.id
    INNER JOIN municipalities m ON s.municipality_id=m.id
  where (m.pop_2018 between 20000 and 50000) and zone_id=140
  GROUP BY municipality_id
)
SELECT * FROM summarized;


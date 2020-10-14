
WITH summarized AS(
  SELECT f.name AS fare,
    count(case when strftime('%m', time_stamp) == '01' then 1 end) as jan,
    count(case when strftime('%m', time_stamp) == '02' then 1 end) as feb,
    count(case when strftime('%m', time_stamp) == '03' then 1 end) as mar,
    count(case when strftime('%m', time_stamp) == '04' then 1 end) as apr,
    count(case when strftime('%m', time_stamp) == '05' then 1 end) as may,
    count(case when strftime('%m', time_stamp) == '06' then 1 end) as jun,
    count(case when strftime('%m', time_stamp) == '07' then 1 end) as jul,
    count(case when strftime('%m', time_stamp) == '08' then 1 end) as aug,
    count(case when strftime('%m', time_stamp) == '09' then 1 end) as sep,
    count(case when strftime('%m', time_stamp) == '10' then 1 end) as oct,
    count(case when strftime('%m', time_stamp) == '11' then 1 end) as nov,
    count(case when strftime('%m', time_stamp) == '12' then 1 end) as dec,
    count(t.id) AS total_count
  FROM transactions_tp t
  JOIN fares f ON t.fare_id = f.id 
  JOIN stops s ON t.stop_id = s.id 
  JOIN municipalities m ON m.id = s.municipality_id
  GROUP BY t.fare_id
), totals AS (
  SELECT '___ Total ___' AS fare,
    count(case when strftime('%m', time_stamp) == '01' then 1 end) as jan,
    count(case when strftime('%m', time_stamp) == '02' then 1 end) as feb,
    count(case when strftime('%m', time_stamp) == '03' then 1 end) as mar,
    count(case when strftime('%m', time_stamp) == '04' then 1 end) as apr,
    count(case when strftime('%m', time_stamp) == '05' then 1 end) as may,
    count(case when strftime('%m', time_stamp) == '06' then 1 end) as jun,
    count(case when strftime('%m', time_stamp) == '07' then 1 end) as jul,
    count(case when strftime('%m', time_stamp) == '08' then 1 end) as aug,
    count(case when strftime('%m', time_stamp) == '09' then 1 end) as sep,
    count(case when strftime('%m', time_stamp) == '10' then 1 end) as oct,
    count(case when strftime('%m', time_stamp) == '11' then 1 end) as nov,
    count(case when strftime('%m', time_stamp) == '12' then 1 end) as dec,
    count(t.id) AS total_count
  FROM transactions_tp t
  JOIN fares f ON t.fare_id = f.id 
  JOIN stops s ON t.stop_id = s.id
)
SELECT * FROM summarized
UNION
SELECT * FROM totals;

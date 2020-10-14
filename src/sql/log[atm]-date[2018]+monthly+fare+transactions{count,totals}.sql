
WITH summarized AS(
  SELECT f.name AS fare,
    Count(CASE WHEN strftime('%m', time_stamp) == '01' THEN 1 END) AS jan,
    Count(CASE WHEN strftime('%m', time_stamp) == '02' THEN 1 END) AS feb,
    Count(CASE WHEN strftime('%m', time_stamp) == '03' THEN 1 END) AS mar,
    Count(CASE WHEN strftime('%m', time_stamp) == '04' THEN 1 END) AS apr,
    Count(CASE WHEN strftime('%m', time_stamp) == '05' THEN 1 END) AS may,
    Count(CASE WHEN strftime('%m', time_stamp) == '06' THEN 1 END) AS jun,
    Count(CASE WHEN strftime('%m', time_stamp) == '07' THEN 1 END) AS jul,
    Count(CASE WHEN strftime('%m', time_stamp) == '08' THEN 1 END) AS aug,
    Count(CASE WHEN strftime('%m', time_stamp) == '09' THEN 1 END) AS sep,
    Count(CASE WHEN strftime('%m', time_stamp) == '10' THEN 1 END) AS oct,
    Count(CASE WHEN strftime('%m', time_stamp) == '11' THEN 1 END) AS nov,
    Count(CASE WHEN strftime('%m', time_stamp) == '12' THEN 1 END) AS dec
  FROM transactions_atm t
    JOIN fares f ON t.fare_id = f.id 
  GROUP BY t.fare_id
), summarized_rows AS (
  SELECT * FROM summarized
  UNION
  SELECT '___ Total ___' AS fare,
    Sum(jan) AS jan,
    Sum(feb) AS feb,
    Sum(mar) AS mar,
    Sum(apr) AS apr,
    Sum(may) AS may,
    Sum(jun) AS jun,
    Sum(jul) AS jul,
    Sum(aug) AS aug,
    Sum(sep) AS sep,
    Sum(oct) AS oct,
    Sum(nov) AS nov,
    Sum(dec) AS dec
  FROM summarized
), summarized_cols AS (
  SELECT fare, (jan+feb+mar+apr+may+jun+jul+aug+sep+oct+nov+dec) AS total_count
  FROM summarized_rows
)
SELECT *
FROM summarized_rows
  JOIN summarized_cols USING(fare);



with summarized as(
SELECT s.id AS stop_id, s.name AS stop, 
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
GROUP BY stop_id
ORDER BY total_count DESC

), summarized_rows as(
  select * from summarized
  union
  select '___ Total ___' as stop_id, '___ Total ___' as stop,
    sum(summer_t10) as summer_t10,
    sum(summer_t1030) as summer_t1030,
    sum(summer_total) as summer_total,
    sum(non_summer_t10) as non_summer_t10,
    sum(non_summer_t1030) as non_summer_t1030,
    sum(non_summer_total) as non_summer_total,
    sum(total_t10) as total_t10,
    sum(total_t1030) as total_t1030,
    sum(total_count) as total_count
  from summarized
)
select *
from summarized_rows
ORDER BY total_count DESC;


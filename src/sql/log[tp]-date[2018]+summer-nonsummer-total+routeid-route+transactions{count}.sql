
with summarized as(
SELECT r.id AS route_id, r.name AS route, 
  Count(CASE WHEN (time_stamp BETWEEN '2018-06-21' AND '2018-09-23') THEN 1 END) AS summer_total,
  Count(CASE WHEN (time_stamp NOT BETWEEN '2018-06-21' AND '2018-09-23') THEN 1 END) AS non_summer_total,
  Count(t.id) AS total_count

FROM transactions_tp t
  INNER JOIN fares f ON t.fare_id=f.id
  INNER JOIN routes r ON t.route_id=r.id
GROUP BY route_id
ORDER BY total_count DESC
), summarized_rows as(
  select * from summarized
  union
  select '___ Total ___' as route_id, '___ Total ___' as route,
    sum(summer_total) as summer_total,
    sum(non_summer_total) as non_summer_total,
    sum(total_count) as total_count
  from summarized
)
select *
from summarized_rows
ORDER BY total_count DESC;


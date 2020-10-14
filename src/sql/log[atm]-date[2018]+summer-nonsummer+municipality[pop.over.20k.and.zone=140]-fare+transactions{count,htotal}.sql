
with summarized as(
  select m.name as municipality, f.name as fare, 
    count(case when (time_stamp BETWEEN '2018-06-21' AND '2018-09-23') then 1 end) as summer,
    count(case when (time_stamp NOT BETWEEN '2018-06-21' AND '2018-09-23') then 1 end) as non_summer
  from transactions_atm t
    INNER JOIN fares f ON t.fare_id=f.id
    INNER JOIN stops s ON t.stop_id=s.id
    INNER JOIN municipalities m ON s.municipality_id=m.id
  where m.pop_2018 > 20000 and zone_id=140
  group by m.id, f.id
), summarized_cols as (
  select municipality, fare, summer, non_summer, 
    (summer+non_summer) as total_count
  from summarized
)
select *
from summarized_cols;

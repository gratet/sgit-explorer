
with summarized as(
select card,
  count(distinct stop_id) as visited_stops_summer,
  count(distinct municipality_id) as visited_municipalities_summer,
  count(distinct zone_id) as visited_zones_summer,
  count(distinct route_id) as used_routes_summer, 
  count(distinct strftime("%d-%m-%Y", time_stamp)) as active_days_summer,
  count(distinct strftime("%m-%Y", time_stamp)) as active_months_summer
from transactions_atm AS t
    inner join stops s on t.stop_id=s.id
    inner join municipalities m on s.municipality_id=m.id
WHERE time_stamp BETWEEN '2018-06-21' AND '2018-09-23'
group by card
)
select *
from summarized
order by visited_stops_summer desc;
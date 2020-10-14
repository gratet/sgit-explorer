
with summarized as(
select card,
  count(distinct stop_id) as visited_stops,
  count(distinct municipality_id) as visited_municipalities,
  count(distinct zone_id) as visited_zones,
  count(distinct route_id) as used_routes,  
  count(distinct strftime("%d-%m-%Y", time_stamp)) as active_days,
  count(distinct strftime("%m-%Y", time_stamp)) as active_months
from transactions_atm AS t
    inner join stops s on t.stop_id=s.id
    inner join municipalities m on s.municipality_id=m.id
group by card
)
select *
from summarized
order by visited_stops desc;

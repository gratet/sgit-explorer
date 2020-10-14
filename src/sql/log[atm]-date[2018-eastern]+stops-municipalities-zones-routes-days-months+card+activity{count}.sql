
with summarized as(
select card,
  count(distinct stop_id) as visited_stops_eastern,
  count(distinct municipality_id) as visited_municipalities_eastern,
  count(distinct zone_id) as visited_zones_eastern,
  count(distinct route_id) as used_routes_eastern, 
  count(distinct strftime("%d-%m-%Y", time_stamp)) as active_days_eastern,
  count(distinct strftime("%m-%Y", time_stamp)) as active_months_eastern
from transactions_atm AS t
    inner join stops s on t.stop_id=s.id
    inner join municipalities m on s.municipality_id=m.id
WHERE time_stamp BETWEEN '2018-03-24' AND '2018-04-02'
group by card
)
select *
from summarized
order by visited_stops_eastern desc;
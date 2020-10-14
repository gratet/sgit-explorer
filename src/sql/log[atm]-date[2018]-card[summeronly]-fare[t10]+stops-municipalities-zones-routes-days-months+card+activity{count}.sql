
with on_winter_cards as(
select distinct card
from transactions_atm
where time_stamp NOT BETWEEN '2018-06-21' AND '2018-09-23'
), on_summer_cards as(
select distinct card
from transactions_atm
where time_stamp BETWEEN '2018-06-21' AND '2018-09-23'
), summerly_cards as(
select card
from on_summer_cards s
  left join on_winter_cards w using (card)
where w.card is null
), summarized as(
select card,
  count(distinct stop_id) as visited_stops,
  count(distinct municipality_id) as visited_municipalities,
  count(distinct zone_id) as visited_zones,
  count(distinct route_id) as used_routes,  
  count(distinct strftime("%d-%m-%Y", time_stamp)) as active_days,
  count(distinct strftime("%m-%Y", time_stamp)) as active_months
from transactions_atm AS t
    inner join summerly_cards using(card)
    inner join stops s on t.stop_id=s.id
    inner join municipalities m on s.municipality_id=m.id
where fare_id=1
group by card
)
select *
from summarized
order by visited_stops desc;

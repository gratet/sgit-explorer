
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
)
select t.id as id, card, time_stamp,
a.name as agency_name, f.name as fare_name, r.name as route_name, s.name as stop_name,
machine_id
from transactions_atm t
inner join summerly_cards using(card)
inner join agency a on agency_id=a.id
inner join fares f on fare_id=f.id
inner join routes r on route_id=r.id
inner join stops s on stop_id=s.id
where fare_id=1;
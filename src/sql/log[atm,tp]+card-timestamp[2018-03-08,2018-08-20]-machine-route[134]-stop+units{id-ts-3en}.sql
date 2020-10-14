
with winter_expedition_atm as(
  select id,card,time_stamp,agency_id,fare_id,route_id,stop_id,machine_id
  from transactions_atm
  where route_id = '134'
    and time_stamp BETWEEN '2018-03-08 00:00:00' AND '2018-03-08 23:59:59'
), winter_expedition_tp as(
  select id,'tp'as card,time_stamp,agency_id,fare_id,route_id,stop_id,machine_id
  from transactions_tp
  where route_id = '134'
    and time_stamp BETWEEN '2018-03-08 00:00:00' AND '2018-03-08 23:59:59'
), summer_expedition_atm as(
select id,card,time_stamp,agency_id,fare_id,route_id,stop_id,machine_id
from transactions_atm
where route_id = '134'
and time_stamp BETWEEN '2018-08-20 00:00:00' AND '2018-08-20 23:59:59'
), summer_expedition_tp as(
select id,'tp'as card,time_stamp,agency_id,fare_id,route_id,stop_id,machine_id
from transactions_tp
where route_id = '134'
and time_stamp BETWEEN '2018-08-20 00:00:00' AND '2018-08-20 23:59:59'
), winter_expedition as (
  select * from winter_expedition_atm
  union
  select * from winter_expedition_tp
), summer_expedition as (
  select * from summer_expedition_atm
  union
  select * from summer_expedition_tp
), expeditions as(
  SELECT * FROM winter_expedition 
  UNION
  SELECT * FROM summer_expedition
)
select card,
  time_stamp,
  a.name as agency,
  f.name as fare,
  r.name as route,
  s.name as stop,
  machine_id
from expeditions e
inner join agency a on e.agency_id=a.id
inner join fares f on e.fare_id=f.id  
inner join routes r on e.route_id=r.id 
inner join stops s on e.stop_id=s.id
order by time_stamp asc;


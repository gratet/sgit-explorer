
with winter_expedition_atm as(
  select id,card,time_stamp,agency_id,fare_id,route_id,stop_id,machine_id
  from transactions_atm
  where stop_id = '26445'
    and machine_id ='07356'
    and route_id = '134'
    and time_stamp BETWEEN '2018-03-08 10:00:00' AND '2018-03-08 11:00:00'
), winter_expedition_tp as(
  select id,'tp'as card,time_stamp,agency_id,fare_id,route_id,stop_id,machine_id
  from transactions_tp
  where stop_id = '26445'
    and machine_id ='07356'
    and route_id = '134'
    and time_stamp BETWEEN '2018-03-08 10:00:00' AND '2018-03-08 11:00:00'
), summer_expedition_atm as(
select id,card,time_stamp,agency_id,fare_id,route_id,stop_id,machine_id
from transactions_atm
where stop_id = '26445'
and machine_id ='08210'
and route_id = '134'
and time_stamp BETWEEN '2018-08-20 10:00:00' AND '2018-08-20 11:00:00'
), summer_expedition_tp as(
select id,'tp'as card,time_stamp,agency_id,fare_id,route_id,stop_id,machine_id
from transactions_tp
where stop_id = '26445'
and machine_id ='08210'
and route_id = '134'
and time_stamp BETWEEN '2018-08-20 10:00:00' AND '2018-08-20 11:00:00'
), winter_expedition as (
  select * from winter_expedition_atm
  union
  select * from winter_expedition_tp
), summer_expedition as (
  select * from summer_expedition_atm
  union
  select * from summer_expedition_tp
), winter_expedition_report as (
select count(card) as people,
  Cast ((julianday(max(time_stamp))- julianday(min(time_stamp))) * 24 * 60 As Integer) as boarding_period_min,
  min(time_stamp) as door_opening,
  max(time_stamp) as door_closing,
  machine_id,
  r.name as route,
  s.name as stop
from winter_expedition e
inner join routes r on e.route_id=r.id 
inner join stops s on e.stop_id=s.id
), summer_expedition_report as (
select count(card) as people,
  Cast ((julianday(max(time_stamp))- julianday(min(time_stamp))) * 24 * 60 As Integer) as boarding_period_min,
  min(time_stamp) as door_opening,
  max(time_stamp) as door_closing,
  machine_id,
  r.name as route,
  s.name as stop
from summer_expedition e
inner join routes r on e.route_id=r.id 
inner join stops s on e.stop_id=s.id
)
SELECT * FROM winter_expedition_report 
UNION
SELECT * FROM summer_expedition_report;

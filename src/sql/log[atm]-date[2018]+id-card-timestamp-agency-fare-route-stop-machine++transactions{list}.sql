select t.id as id, card, time_stamp,
a.name as agency_name, f.name as fare_name, r.name as route_name, s.name as stop_name,
machine_id
from transactions_atm t
inner join agency a on agency_id=a.id
inner join fares f on fare_id=f.id
inner join routes r on route_id=r.id
inner join stops s on stop_id=s.id;

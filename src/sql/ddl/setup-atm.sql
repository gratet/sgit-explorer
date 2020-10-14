
--TODO: Revise naming with schemas.org and google transport API
-- Perform column refactoring
create table transactions_atm_backup (id integer primary key, trip_id text, card text, time_stamp text, agency_id text, fare_id text, route_id text, stop_id text, machine_id text);
insert into transactions_atm_backup(id, trip_id, card, time_stamp, agency_id, fare_id, route_id, stop_id, machine_id)
WITH f_agency AS(
  SELECT * FROM agency WHERE name not in ('EMT','RENFE','Reus Transport Públic','Penedès - Servei urbà del Vendrell')
), main as(
  select LOG_ID as id, 
    TRAVEL_ID as trip_id, 
    CARD as card, 
    (substr(OPERATIONDATE,7,4)||'-'||substr(OPERATIONDATE,4,2)||'-'||substr(OPERATIONDATE,1,2)||' '||
  substr(OPERATIONDATE,12,2)||':'||substr(OPERATIONDATE,15,2)||':'||substr(OPERATIONDATE,18,2)) as time_stamp, -- Format DATETIMES in ISO-8601
    a.id as agency_id, 
    f.id as fare_id, 
    r.id as route_id, 
    s.id as stop_id,
    MACHINE_CODE as machine_id
--    VLVZ as zone_id 
--    TFXMZ as max_zones, 
--    PERFIL as profile, --Split to a table?
--    ENTITAT as organization, --Split to a table?
--    MUNICIPI as municipality --Split to a table?
  from transactions_atm t 
  inner join f_agency a on t.OPERATOR_NAME=a.name
  inner join fares f on t.title_name=f.name
  inner join routes r on t.LINE=r.name
  inner join stops s on t.stop=s.name
)
select * from main 
where trip_id !='' 
ORDER BY time_stamp;

drop table transactions_atm;
alter table transactions_atm_backup rename to transactions_atm;


-- Before indexing
vacuum;
analyze;

create index idx_transactions_atm_time_stamp on transactions_atm (time_stamp);

create index idx_transactions_atm_agency  on transactions_atm(agency_id);
create index idx_transactions_atm_fare    on transactions_atm(fare_id);
create index idx_transactions_atm_route   on transactions_atm(route_id);
create index idx_transactions_atm_stop    on transactions_atm(stop_id);
create index idx_transactions_atm_machine on transactions_atm(machine_id);
--create index idx_transactions_atm_zone   on transactions_atm(zone_id);



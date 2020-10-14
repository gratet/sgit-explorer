
create table transactions_tp_backup (id integer primary key, time_stamp text, agency_id text, fare_id text, route_id text, stop_id text, stop_id_dest text, machine_id);
insert into transactions_tp_backup(id, time_stamp, agency_id, fare_id, route_id, stop_id, stop_id_dest, machine_id)
with f_agency AS(
  SELECT * FROM agency WHERE name not in ('EMT','RENFE','Reus Transport Públic','Penedès - Servei urbà del Vendrell')
), f_fares AS(
  SELECT * FROM fares WHERE name not in ('Títol propi extern zona integrada')
), main as(
  select LOG_ID as id, 
    (substr(OPERATIONDATE,7,4)||'-'||substr(OPERATIONDATE,4,2)||'-'||substr(OPERATIONDATE,1,2)||' '||
  substr(OPERATIONDATE,12,2)||':'||substr(OPERATIONDATE,15,2)||':'||substr(OPERATIONDATE,18,2)) as time_stamp, -- Format DATETIMES in ISO-8601
    a.id as agency_id, 
    f.id as fare_id, 
    r.id as route_id, 
    s1.id as stop_id,
    s2.id as stop_id_dest,
    MACHINE_CODE as machine_id
  from transactions_tp t 
  inner join f_agency a on t.OPERATOR_NAME=a.name
  inner join f_fares f on t.TITLE_NAME=f.name
  inner join routes r on t.LINE_NAME=r.name
  inner join stops s1 on t.INITSTOPCODE=s1.id
  inner join stops s2 on t.ENDSTOPCODE=s2.id
)
select * from main
ORDER BY time_stamp;

drop table transactions_tp;
alter table transactions_tp_backup rename to transactions_tp;

-- Before indexing
vacuum;
analyze;


create index idx_transactions_tp_time_stamp on transactions_tp (time_stamp);

create index idx_transactions_tp_agency on transactions_tp(agency_id);
create index idx_transactions_tp_fare   on transactions_tp(fare_id);
create index idx_transactions_tp_route  on transactions_tp(route_id);
create index idx_transactions_tp_stop1  on transactions_tp(stop_id);
create index idx_transactions_tp_stop2  on transactions_tp(stop_id_dest);
create index idx_transactions_tp_machine  on transactions_tp(machine_id);

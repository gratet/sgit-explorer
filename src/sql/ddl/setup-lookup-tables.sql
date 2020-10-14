
--After bulk insertion?
--VACUUM;
--ANALYZE;

/*
Redundant columns:
-----------------
ACC_DATE2, ATM2
--select * from trips where ACC_DATE <> ACC_DATE2; --> 0 Rows
--select * from trips where ATM <> ATM2; --> 0 Rows

Unused by ATM:
-------------
ACQ_DATE, TVXCVAB, TVXCVAA, TOP, CIERRE_ID, VTMT, SUTYPE, SQUANTITY, TVXCVIB, TVXCVIA, TVXSVB, TVXSVA, TGGTXTB, TGGTXTA, TGGTXZB, TGGTXZA, TGGTXS, SERRCODE, STATEID

select distinct = 1:
------------
ATM_ID, REGTYPE, IPADDRESS, ATM, TGGTXM, TVT

Not relevant:
------------
FILENAME, REGVERSION, TTC, BLACKLIST, TGGTXI, TGGTXE, TGGTXTA, PRECIO_VIAJE, REINTEGRO,
ACC_DATE, TFC, VTMH2, VTMH1, TVXFV, TVXFVS, TFXLVA, TGNT,
MACHINECOUNTER, MACHINE_CODE,

Lookup tables:
-------------
OPERATOR_NAME -> agency
TITLE_NAME -> fares
LINE -> routes
*/

-- Split table 'agency', with ATM codes (excluding EMT, RENFE and ?)
create table agency (id integer primary key, name text);
insert into agency(id,name) 
  WITH operators_atm AS(
    select distinct OPERATOR_ID as id, OPERATOR_NAME as agency_name 
    from transactions_atm
  ), operators_tp AS(
    select distinct COMPANY_ID as id, OPERATOR_NAME as agency_name 
    from transactions_tp
  ), operators AS (
    SELECT * FROM operators_atm
    UNION ALL
    SELECT * FROM operators_tp
  )
  SELECT DISTINCT * 
  FROM operators
  ORDER BY id ASC;

-- Split table 'fares', with auto-codes
create table fares (id integer primary key autoincrement, name text, fare_type text);
insert into fares(name, fare_type) 
  WITH fares_atm AS (
    select distinct TITLE_NAME as name, 1 AS fare_type
    from transactions_atm 
    where TITLE_NAME!=''
    ORDER BY TITLE_NAME ASC
  ), fares_tp AS(
    select distinct TITLE_NAME as name, 2 AS fare_type 
    from transactions_tp 
    where TITLE_NAME!=''
    ORDER BY TITLE_NAME ASC
  ), fares AS(
    SELECT * FROM fares_atm
    UNION
    SELECT * FROM fares_tp
  )
  SELECT DISTINCT * FROM fares
  ORDER BY fare_type;


-- Split table 'routes', with auto-codes
create table routes (id integer primary key autoincrement, name text);
insert into routes(name) 
  WITH routes_atm AS (
    select distinct LINE as name
    from transactions_atm 
    ORDER BY name ASC
  ), routes_tp AS(
    select distinct LINE_NAME as name
    from transactions_tp 
    ORDER BY LINE_NAME ASC
  ), t_routes AS(
    SELECT * FROM routes_atm
    UNION
    SELECT * FROM routes_tp
  )
  SELECT DISTINCT * FROM t_routes
  ORDER BY name;


-- Add municipality_id to stops
-- This way we avoid performing many spatial joins when grouping stops.
create table stops_backup as 
  select s.*,m.id as municipality_id
  from stops s
  inner join municipalities m on intersects(s.geom,m.geom);

drop table stops;
alter table stops_backup rename to stops;



--select spatialite_version();
-->4.3.0a

--log[atm]-date[2018]+summer[2018-08-23,2018-08-30]-winter[2018-12-19,2018-12-26]-diff~stop-geom+transactions{count,count,diff}

with summer_agg as(
  select stop_id,count(id) as summer_transactions
  from transactions_atm t
  where time_stamp BETWEEN '2018-08-23 00:00:00' AND '2018-08-30 00:00:00'
  group by stop_id
), winter_agg as(
  select stop_id,count(id) as winter_transactions
  from transactions_atm t
  where time_stamp BETWEEN '2018-12-19 00:00:00' AND '2018-12-26 00:00:00'
  group by stop_id
), bind as(
  select * from summer_agg as s
  inner join winter_agg w on s.stop_id=w.stop_id 
), sp as(
  select * from bind as b
  inner join stops s on b.stop_id=s.id 
)
select stop_id, summer_transactions, winter_transactions, 
  summer_transactions-winter_transactions as diff, 
  st_astext(geom) as geom 
from sp 
order by diff desc;


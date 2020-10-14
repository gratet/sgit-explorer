
with summarized as(
select card,
  count(distinct t.id) as transactions_summer, 
  count(distinct trip_id) as transaction_chains_summer,
  count(case when municipality_id IN ('43148','43123') then 1 end) as transactions_tarragona_reus_summer,
  count(case when municipality_id IN ('43038','43905','43171') then 1 end) as transactions_cgc_summer
from transactions_atm AS t
  inner join stops s on t.stop_id = s.id
WHERE time_stamp BETWEEN '2018-06-21' AND '2018-09-23'
group by card
)
select *
from summarized
order by transactions_summer desc;

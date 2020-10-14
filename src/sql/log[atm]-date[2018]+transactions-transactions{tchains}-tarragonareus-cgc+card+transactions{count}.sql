
with summarized as(
select card,
  count(distinct t.id) as transactions, 
  count(distinct trip_id) as transaction_chains,
  count(case when municipality_id IN ('43148','43123') then 1 end) as transactions_tarragona_reus,
  count(case when municipality_id IN ('43038','43905','43171') then 1 end) as transactions_cgc
from transactions_atm AS t
  inner join stops s on t.stop_id = s.id
group by card
)
select *
from summarized
order by transactions desc;

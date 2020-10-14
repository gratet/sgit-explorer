
with summarized as(
select card,
  count(distinct t.id) as transactions_eastern, 
  count(distinct trip_id) as transaction_chains_eastern,
  count(case when municipality_id IN ('43148','43123') then 1 end) as transactions_tarragona_reus_eastern,
  count(case when municipality_id IN ('43038','43905','43171') then 1 end) as transactions_cgc_eastern
from transactions_atm AS t
  inner join stops s on t.stop_id = s.id
WHERE time_stamp BETWEEN '2018-03-24' AND '2018-04-02'
group by card
)
select *
from summarized
order by transactions_eastern desc;

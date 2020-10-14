
with on_winter_cards as(
select distinct card
from transactions_atm
where time_stamp NOT BETWEEN '2018-06-21' AND '2018-09-23'
), on_summer_cards as(
select distinct card
from transactions_atm
where time_stamp BETWEEN '2018-06-21' AND '2018-09-23'
), summerly_cards as(
select card
from on_summer_cards s
  left join on_winter_cards w using (card)
where w.card is null
), summarized as(
select card,
  count(distinct t.id) as transactions_summer, 
  count(distinct trip_id) as transaction_chains_summer,
  count(case when municipality_id IN ('43148','43123') then 1 end) as transactions_tarragona_reus_summer,
  count(case when municipality_id IN ('43038','43905','43171') then 1 end) as transactions_cgc_summer
from transactions_atm AS t
  inner join summerly_cards using(card)
  inner join stops s on t.stop_id = s.id
where fare_id=1
group by card
)
select *
from summarized
order by transactions_summer desc;
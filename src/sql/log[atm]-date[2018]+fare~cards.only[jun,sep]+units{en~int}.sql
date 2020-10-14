with on_winter_cards as(
select distinct card
from transactions_atm
where time_stamp NOT BETWEEN '2018-06-01' AND '2018-09-30'
), on_summer_cards as(
select distinct card
from transactions_atm
where time_stamp BETWEEN '2018-06-01' AND '2018-09-30'
), summerly_cards as(
select card
from on_summer_cards s
  left join on_winter_cards w using (card)
where w.card is null
), summarized as(
select f.name AS fare,
  Count(DISTINCT card) AS cards
from transactions_atm AS t
    inner join summerly_cards using(card)
	inner join fares f on f.id = t.fare_id
group by fare_id
)
select *
from summarized;

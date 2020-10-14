with on_rest_cards as(
select distinct card
from transactions_atm
where time_stamp NOT BETWEEN '2018-03-24' AND '2018-04-02'
), on_eastern_cards as(
select distinct card
from transactions_atm
where time_stamp BETWEEN '2018-03-24' AND '2018-04-02'
), easternly_cards as(
select card
from on_eastern_cards s
  left join on_rest_cards w using (card)
where w.card is null
), summarized as(
select f.name AS fare,
  Count(DISTINCT card) AS easternly_cards
from transactions_atm AS t
    inner join easternly_cards using(card)
	inner join fares f on f.id = t.fare_id
group by t.fare_id
)
select *
from summarized;

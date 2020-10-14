
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
  CAST(julianday(max(date(time_stamp))) - julianday(min(date(time_stamp))) + 1 AS integer) as enabled_days
from transactions_atm AS t
    inner join summerly_cards using(card)
where fare_id=1
group by card
)
select *
from summarized
order by enabled_days desc;

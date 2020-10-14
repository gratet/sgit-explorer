
--TODO: rewrite using window functions
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
  time_stamp,
  count(t.id) as group_size,
  machine_id
from transactions_atm AS t
    inner join summerly_cards using(card)
where fare_id=1
group by card, datetime(strftime('%s', time_stamp) - strftime('%s', time_stamp) % 1800, 'unixepoch', 'localtime'), machine_id
)
select card,max(group_size) as max_group_size,cast(avg(group_size) as integer) as avg_group_size
from summarized
group by card
order by max_group_size desc;

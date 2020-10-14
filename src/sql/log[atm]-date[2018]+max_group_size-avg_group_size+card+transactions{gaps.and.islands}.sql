
--TODO: rewrite using window functions
with cards as(
select distinct card
from transactions_atm
), summarized as(
select card,
  time_stamp,
  count(t.id) as group_size,
  machine_id
from transactions_atm AS t
    inner join cards using(card)
group by card, datetime(strftime('%s', time_stamp) - strftime('%s', time_stamp) % 1800, 'unixepoch', 'localtime'), machine_id
)
select card,max(group_size) as max_group_size,cast(avg(group_size) as integer) as avg_group_size
from summarized
group by card
order by max_group_size desc;

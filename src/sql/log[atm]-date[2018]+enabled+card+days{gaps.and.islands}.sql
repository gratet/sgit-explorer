
with summarized as(
select card,
  CAST(julianday(max(date(time_stamp))) - julianday(min(date(time_stamp))) + 1 AS integer) as enabled_days
from transactions_atm AS t
group by card
)
select *
from summarized
order by enabled_days desc;

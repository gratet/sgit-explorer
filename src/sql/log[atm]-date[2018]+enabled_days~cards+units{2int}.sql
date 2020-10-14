WITH lifespan AS (
select card,
  CAST(julianday(max(date(time_stamp))) - julianday(min(date(time_stamp))) + 1 AS integer) as enabled_days
from transactions_atm AS t
group by card
)
SELECT DISTINCT enabled_days, Count(card) AS cards
FROM lifespan
GROUP BY enabled_days;

select
  strftime('%Y-%m', time_stamp) as date, 
  count(distinct trip_id) as transactions
from transactions_atm
group by strftime('%m-%Y', time_stamp)
order by date;

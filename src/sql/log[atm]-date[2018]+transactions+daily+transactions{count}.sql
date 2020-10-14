
select
  strftime('%Y-%m-%d', time_stamp) as date, 
  count(distinct trip_id) as transactions
from transactions_atm
group by strftime('%d-%m-%Y', time_stamp)
order by date;

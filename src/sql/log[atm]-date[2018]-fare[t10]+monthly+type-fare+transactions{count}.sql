
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
), winterly_cards as(
select card
from on_winter_cards w
  left join on_summer_cards s using (card)
where s.card is null
), yearly_cards as(
select card
from on_winter_cards w
  inner join on_summer_cards s using (card)
), summerly_t10 as(
  SELECT f.name AS fare,
    Count(CASE WHEN strftime('%m', time_stamp) == '01' THEN 1 END) AS jan,
    Count(CASE WHEN strftime('%m', time_stamp) == '02' THEN 1 END) AS feb,
    Count(CASE WHEN strftime('%m', time_stamp) == '03' THEN 1 END) AS mar,
    Count(CASE WHEN strftime('%m', time_stamp) == '04' THEN 1 END) AS apr,
    Count(CASE WHEN strftime('%m', time_stamp) == '05' THEN 1 END) AS may,
    Count(CASE WHEN strftime('%m', time_stamp) == '06' THEN 1 END) AS jun,
    Count(CASE WHEN strftime('%m', time_stamp) == '07' THEN 1 END) AS jul,
    Count(CASE WHEN strftime('%m', time_stamp) == '08' THEN 1 END) AS aug,
    Count(CASE WHEN strftime('%m', time_stamp) == '09' THEN 1 END) AS sep,
    Count(CASE WHEN strftime('%m', time_stamp) == '10' THEN 1 END) AS oct,
    Count(CASE WHEN strftime('%m', time_stamp) == '11' THEN 1 END) AS nov,
    Count(CASE WHEN strftime('%m', time_stamp) == '12' THEN 1 END) AS dec
  FROM transactions_atm t
      inner join summerly_cards using(card)
    JOIN fares f ON t.fare_id = f.id 
  where fare_id=1
  GROUP BY t.fare_id
), winterly_t10 as(
  SELECT f.name AS fare,
    Count(CASE WHEN strftime('%m', time_stamp) == '01' THEN 1 END) AS jan,
    Count(CASE WHEN strftime('%m', time_stamp) == '02' THEN 1 END) AS feb,
    Count(CASE WHEN strftime('%m', time_stamp) == '03' THEN 1 END) AS mar,
    Count(CASE WHEN strftime('%m', time_stamp) == '04' THEN 1 END) AS apr,
    Count(CASE WHEN strftime('%m', time_stamp) == '05' THEN 1 END) AS may,
    Count(CASE WHEN strftime('%m', time_stamp) == '06' THEN 1 END) AS jun,
    Count(CASE WHEN strftime('%m', time_stamp) == '07' THEN 1 END) AS jul,
    Count(CASE WHEN strftime('%m', time_stamp) == '08' THEN 1 END) AS aug,
    Count(CASE WHEN strftime('%m', time_stamp) == '09' THEN 1 END) AS sep,
    Count(CASE WHEN strftime('%m', time_stamp) == '10' THEN 1 END) AS oct,
    Count(CASE WHEN strftime('%m', time_stamp) == '11' THEN 1 END) AS nov,
    Count(CASE WHEN strftime('%m', time_stamp) == '12' THEN 1 END) AS dec
  FROM transactions_atm t
      inner join winterly_cards using(card)
    JOIN fares f ON t.fare_id = f.id 
  where fare_id=1
  GROUP BY t.fare_id
), yearly_t10 as(
  SELECT f.name AS fare,
    Count(CASE WHEN strftime('%m', time_stamp) == '01' THEN 1 END) AS jan,
    Count(CASE WHEN strftime('%m', time_stamp) == '02' THEN 1 END) AS feb,
    Count(CASE WHEN strftime('%m', time_stamp) == '03' THEN 1 END) AS mar,
    Count(CASE WHEN strftime('%m', time_stamp) == '04' THEN 1 END) AS apr,
    Count(CASE WHEN strftime('%m', time_stamp) == '05' THEN 1 END) AS may,
    Count(CASE WHEN strftime('%m', time_stamp) == '06' THEN 1 END) AS jun,
    Count(CASE WHEN strftime('%m', time_stamp) == '07' THEN 1 END) AS jul,
    Count(CASE WHEN strftime('%m', time_stamp) == '08' THEN 1 END) AS aug,
    Count(CASE WHEN strftime('%m', time_stamp) == '09' THEN 1 END) AS sep,
    Count(CASE WHEN strftime('%m', time_stamp) == '10' THEN 1 END) AS oct,
    Count(CASE WHEN strftime('%m', time_stamp) == '11' THEN 1 END) AS nov,
    Count(CASE WHEN strftime('%m', time_stamp) == '12' THEN 1 END) AS dec
  FROM transactions_atm t
      inner join yearly_cards using(card)
    JOIN fares f ON t.fare_id = f.id 
  where fare_id=1
  GROUP BY t.fare_id
)
select 'summerly' as type, * from summerly_t10
union
select 'yearly' as type, * from yearly_t10
union
select 'winterly' as type, * from winterly_t10;
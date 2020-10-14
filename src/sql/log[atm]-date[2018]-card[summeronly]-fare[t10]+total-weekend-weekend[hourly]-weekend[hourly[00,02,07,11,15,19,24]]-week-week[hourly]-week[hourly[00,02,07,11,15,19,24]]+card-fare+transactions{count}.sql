

with prepared as(
  select *,
    cast(strftime('%w', time_stamp) as integer) as weekday,
    cast(strftime('%H', time_stamp) as integer) as hour
  from transactions_atm

), on_winter_cards as(
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
)

, summarized as (
  select card, 
    f.name as fare,
    count(t.id) as transactions,

 ------------
/* WEEKEND */
------------
    COUNT(CASE WHEN (weekday NOT BETWEEN 1 AND 5) THEN 1 END) AS weekend,

 ----------------------
/* WEEKEND PER HOURS */
----------------------
    COUNT(CASE WHEN (weekday NOT BETWEEN 1 AND 5) AND (hour = 0) THEN 1 END) AS weekend_00,
    COUNT(CASE WHEN (weekday NOT BETWEEN 1 AND 5) AND (hour = 1) THEN 1 END) AS weekend_01,
    COUNT(CASE WHEN (weekday NOT BETWEEN 1 AND 5) AND (hour = 2) THEN 1 END) AS weekend_02,
    COUNT(CASE WHEN (weekday NOT BETWEEN 1 AND 5) AND (hour = 3) THEN 1 END) AS weekend_03,
    COUNT(CASE WHEN (weekday NOT BETWEEN 1 AND 5) AND (hour = 4) THEN 1 END) AS weekend_04,
    COUNT(CASE WHEN (weekday NOT BETWEEN 1 AND 5) AND (hour = 5) THEN 1 END) AS weekend_05,
    COUNT(CASE WHEN (weekday NOT BETWEEN 1 AND 5) AND (hour = 6) THEN 1 END) AS weekend_06,
    COUNT(CASE WHEN (weekday NOT BETWEEN 1 AND 5) AND (hour = 7) THEN 1 END) AS weekend_07,
    COUNT(CASE WHEN (weekday NOT BETWEEN 1 AND 5) AND (hour = 8) THEN 1 END) AS weekend_08,
    COUNT(CASE WHEN (weekday NOT BETWEEN 1 AND 5) AND (hour = 9) THEN 1 END) AS weekend_09,
    COUNT(CASE WHEN (weekday NOT BETWEEN 1 AND 5) AND (hour = 10) THEN 1 END) AS weekend_10,
    COUNT(CASE WHEN (weekday NOT BETWEEN 1 AND 5) AND (hour = 11) THEN 1 END) AS weekend_11,
    COUNT(CASE WHEN (weekday NOT BETWEEN 1 AND 5) AND (hour = 12) THEN 1 END) AS weekend_12,
    COUNT(CASE WHEN (weekday NOT BETWEEN 1 AND 5) AND (hour = 13) THEN 1 END) AS weekend_13,
    COUNT(CASE WHEN (weekday NOT BETWEEN 1 AND 5) AND (hour = 14) THEN 1 END) AS weekend_14,
    COUNT(CASE WHEN (weekday NOT BETWEEN 1 AND 5) AND (hour = 15) THEN 1 END) AS weekend_15,
    COUNT(CASE WHEN (weekday NOT BETWEEN 1 AND 5) AND (hour = 16) THEN 1 END) AS weekend_16,
    COUNT(CASE WHEN (weekday NOT BETWEEN 1 AND 5) AND (hour = 17) THEN 1 END) AS weekend_17,
    COUNT(CASE WHEN (weekday NOT BETWEEN 1 AND 5) AND (hour = 18) THEN 1 END) AS weekend_18,
    COUNT(CASE WHEN (weekday NOT BETWEEN 1 AND 5) AND (hour = 19) THEN 1 END) AS weekend_19,
    COUNT(CASE WHEN (weekday NOT BETWEEN 1 AND 5) AND (hour = 20) THEN 1 END) AS weekend_20,
    COUNT(CASE WHEN (weekday NOT BETWEEN 1 AND 5) AND (hour = 21) THEN 1 END) AS weekend_21,
    COUNT(CASE WHEN (weekday NOT BETWEEN 1 AND 5) AND (hour = 22) THEN 1 END) AS weekend_22,
    COUNT(CASE WHEN (weekday NOT BETWEEN 1 AND 5) AND (hour = 23) THEN 1 END) AS weekend_23,

 ------------------------
/* WEEKEND TONI GROUPS */
------------------------
    COUNT(CASE WHEN (weekday NOT BETWEEN 1 AND 5) AND (hour BETWEEN 0 AND 1) THEN 1 END) AS weekend_00_02,
    COUNT(CASE WHEN (weekday NOT BETWEEN 1 AND 5) AND (hour BETWEEN 2 AND 6) THEN 1 END) AS weekend_02_07,
    COUNT(CASE WHEN (weekday NOT BETWEEN 1 AND 5) AND (hour BETWEEN 7 AND 10) THEN 1 END) AS weekend_07_11,
    COUNT(CASE WHEN (weekday NOT BETWEEN 1 AND 5) AND (hour BETWEEN 11 AND 14) THEN 1 END) AS weekend_11_15,
    COUNT(CASE WHEN (weekday NOT BETWEEN 1 AND 5) AND (hour BETWEEN 15 AND 18) THEN 1 END) AS weekend_15_19,
    COUNT(CASE WHEN (weekday NOT BETWEEN 1 AND 5) AND (hour BETWEEN 19 AND 23) THEN 1 END) AS weekend_19_24,

 -------------
/* WEEKDAYS */
-------------
    COUNT(CASE WHEN (weekday BETWEEN 1 AND 5) THEN 1 END) AS week,

 -----------------------
/* WEEKDAYS PER HOURS */
-----------------------
    COUNT(CASE WHEN (weekday BETWEEN 1 AND 5) AND (hour = '00') THEN 1 END) AS week_00,
    COUNT(CASE WHEN (weekday BETWEEN 1 AND 5) AND (hour = '01') THEN 1 END) AS week_01,
    COUNT(CASE WHEN (weekday BETWEEN 1 AND 5) AND (hour = '02') THEN 1 END) AS week_02,
    COUNT(CASE WHEN (weekday BETWEEN 1 AND 5) AND (hour = '03') THEN 1 END) AS week_03,
    COUNT(CASE WHEN (weekday BETWEEN 1 AND 5) AND (hour = '04') THEN 1 END) AS week_04,
    COUNT(CASE WHEN (weekday BETWEEN 1 AND 5) AND (hour = '05') THEN 1 END) AS week_05,
    COUNT(CASE WHEN (weekday BETWEEN 1 AND 5) AND (hour = '06') THEN 1 END) AS week_06,
    COUNT(CASE WHEN (weekday BETWEEN 1 AND 5) AND (hour = '07') THEN 1 END) AS week_07,
    COUNT(CASE WHEN (weekday BETWEEN 1 AND 5) AND (hour = '08') THEN 1 END) AS week_08,
    COUNT(CASE WHEN (weekday BETWEEN 1 AND 5) AND (hour = '09') THEN 1 END) AS week_09,
    COUNT(CASE WHEN (weekday BETWEEN 1 AND 5) AND (hour = '10') THEN 1 END) AS week_10,
    COUNT(CASE WHEN (weekday BETWEEN 1 AND 5) AND (hour = '11') THEN 1 END) AS week_11,
    COUNT(CASE WHEN (weekday BETWEEN 1 AND 5) AND (hour = '12') THEN 1 END) AS week_12,
    COUNT(CASE WHEN (weekday BETWEEN 1 AND 5) AND (hour = '13') THEN 1 END) AS week_13,
    COUNT(CASE WHEN (weekday BETWEEN 1 AND 5) AND (hour = '14') THEN 1 END) AS week_14,
    COUNT(CASE WHEN (weekday BETWEEN 1 AND 5) AND (hour = '15') THEN 1 END) AS week_15,
    COUNT(CASE WHEN (weekday BETWEEN 1 AND 5) AND (hour = '16') THEN 1 END) AS week_16,
    COUNT(CASE WHEN (weekday BETWEEN 1 AND 5) AND (hour = '17') THEN 1 END) AS week_17,
    COUNT(CASE WHEN (weekday BETWEEN 1 AND 5) AND (hour = '18') THEN 1 END) AS week_18,
    COUNT(CASE WHEN (weekday BETWEEN 1 AND 5) AND (hour = '19') THEN 1 END) AS week_19,
    COUNT(CASE WHEN (weekday BETWEEN 1 AND 5) AND (hour = '20') THEN 1 END) AS week_20,
    COUNT(CASE WHEN (weekday BETWEEN 1 AND 5) AND (hour = '21') THEN 1 END) AS week_21,
    COUNT(CASE WHEN (weekday BETWEEN 1 AND 5) AND (hour = '22') THEN 1 END) AS week_22,
    COUNT(CASE WHEN (weekday BETWEEN 1 AND 5) AND (hour = '23') THEN 1 END) AS week_23,

 -------------------------
/* WEEKDAYS TONI GROUPS */
-------------------------
    COUNT(CASE WHEN (weekday BETWEEN 1 AND 5) AND (hour BETWEEN 0 AND 1) THEN 1 END) AS week_00_02,
    COUNT(CASE WHEN (weekday BETWEEN 1 AND 5) AND (hour BETWEEN 2 AND 6) THEN 1 END) AS week_02_07,
    COUNT(CASE WHEN (weekday BETWEEN 1 AND 5) AND (hour BETWEEN 7 AND 10) THEN 1 END) AS week_07_11,
    COUNT(CASE WHEN (weekday BETWEEN 1 AND 5) AND (hour BETWEEN 11 AND 14) THEN 1 END) AS week_11_15,
    COUNT(CASE WHEN (weekday BETWEEN 1 AND 5) AND (hour BETWEEN 15 AND 18) THEN 1 END) AS week_15_19,
    COUNT(CASE WHEN (weekday BETWEEN 1 AND 5) AND (hour BETWEEN 19 AND 23) THEN 1 END) AS week_19_24

  from prepared t
    inner join summerly_cards using(card)
    inner join fares f on t.fare_id=f.id
    inner join stops s on t.stop_id=s.id
  where fare_id=1
  group by card
)
select *
from summarized
order by transactions desc;
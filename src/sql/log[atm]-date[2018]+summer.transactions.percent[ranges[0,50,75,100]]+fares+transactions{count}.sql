
WITH summarized AS(
  SELECT card, fare_id,
    Round((Count(CASE WHEN (time_stamp BETWEEN '2018-06-21' AND '2018-09-23') THEN 1 END)*1.0/Count(id))*100,1) AS summer_transactions_percent,
    Count(id) AS card_transactions
  FROM transactions_atm
  GROUP BY card
), reclassified AS(
  SELECT card, fare_id, card_transactions, summer_transactions_percent,
    CASE
      WHEN (summer_transactions_percent < 50) THEN 0
      WHEN (summer_transactions_percent >= 50) AND (summer_transactions_percent < 75) THEN 1
      WHEN (summer_transactions_percent >= 75) AND (summer_transactions_percent < 100) THEN 2
      WHEN (summer_transactions_percent = 100) THEN  3
    END AS range
  FROM summarized
), spreaded AS (
  SELECT fare_id,
    Sum(CASE WHEN (range = 0) THEN card_transactions END) AS range_0_50,
    Sum(CASE WHEN (range = 1) THEN card_transactions END) AS range_50_75,
    Sum(CASE WHEN (range = 2) THEN card_transactions END) AS range_75_100,
    Sum(CASE WHEN (range = 3) THEN card_transactions END) AS range_100
  FROM reclassified
  GROUP BY fare_id
), summarized_rows AS (
  SELECT f.name AS fare,range_0_50,range_50_75,range_75_100,range_100
  FROM spreaded
    INNER JOIN fares f ON fare_id=f.id
  UNION
  SELECT 'Total' AS fare,
    Sum(range_0_50) AS range_0_50,
    Sum(range_50_75) AS range_50_75,
    Sum(range_75_100) AS range_75_100,
    Sum(range_100) AS range_100
  FROM spreaded
), summarized_cols AS(
  SELECT fare, (range_0_50+range_50_75+range_75_100+range_100+'Total') AS total_count
  FROM summarized_rows
)
SELECT * 
FROM summarized_rows
  INNER JOIN summarized_cols using(fare);

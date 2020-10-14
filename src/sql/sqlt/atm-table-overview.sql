--Use before setup
WITH  column_report AS (
	SELECT DISTINCT ${i} ,  count(${i}) AS ocurrences, 
	CASE ${i}
		WHEN '' 
			THEN 'Empty'|| ' (' || count(${i}) || ')'
		ELSE ${i}  || ' (' || count(${i}) || ')'
		END AS label
	FROM atm_trips
	GROUP BY ${i}
	ORDER BY ocurrences DESC
)
SELECT '**${i}**' AS c, group_concat(label,', ') AS v FROM column_report;

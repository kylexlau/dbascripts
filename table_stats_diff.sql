select report, maxdiffpct from
table(dbms_stats.diff_table_stats_in_history('&owner','&table_name',systimestamp-&days_ago))
/

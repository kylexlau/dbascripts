col read_G for 99999999
col write_G for 99999999
col inter_G for 99999999
col read_ratio for 0.99

select * from (SELECT SQL_ID,
    SUM(DELTA_READ_IO_REQUESTS),
    SUM(DELTA_WRITE_IO_REQUESTS),
    SUM(DELTA_READ_IO_BYTES) / 1024 / 1024 / 1024 read_G,
    ratio_to_report(sum(DELTA_READ_IO_BYTES)) over () read_ratio,
    SUM(DELTA_WRITE_IO_BYTES) / 1024 / 1024 / 1024 write_G,
    SUM(DELTA_INTERCONNECT_IO_BYTES) / 1024 / 1024 / 1024 inter_G
    FROM GV$ACTIVE_SESSION_HISTORY where sql_id is not null
    GROUP BY SQL_ID
    ORDER BY read_ratio DESC)
where rownum < 20;

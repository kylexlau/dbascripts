set lines 155
set pages 9999

col execs for 999,999,999
col elapsed_time_ms for 999,999.999
col avg_buffer_get for 999,999,999.9
col end_interval_time for a30
col node for 99999

break on plan_hash_value on startup_time skip 1

select 
sn.snap_id snap,
s.instance_number node,
to_char(sn.end_interval_time, 'YYYY-MM-DD HH24:MI:SS') end_interval_time,
s.plan_hash_value,
s.executions_delta,
round(s.elapsed_time_delta / s.executions_delta) / 1000 / 1000 elapsed_time_s,
round(s.BUFFER_GETS_delta / s.executions_delta) * 8 /1024 avg_buffer_get_mb,
round(s.CPU_TIME_delta / s.executions_delta) / 1000 CPU_TIME_ms
from dba_hist_snapshot sn, DBA_HIST_SQLSTAT s
-- sys.WRH$_SQLSTAT s
where s.snap_id = sn.snap_id
and s.sql_id = nvl('&sql_id', '0hch9c91yc370')
and s.instance_number = sn.instance_number
and s.executions_delta > 0
order by sn.end_interval_time desc
/

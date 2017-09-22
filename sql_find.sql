set verify off
set pagesize 9999
set lines 300

col sql_text for a60 
col sql_profile for a20 
col baseline for a20 
col username format a13
col prog format a22
col sid format 999
col inst_id format 9
col child_number format 99999 heading CHILD
col ocategory format a10
col avg_etime format 9,999,999.99
col avg_pio format 9,999,999.99
col avg_lio format 999,999,999,999
col etime format 9,999,999.99

select inst_id,sql_id, child_number, plan_hash_value plan_hash, executions execs, 
(elapsed_time/1000000)/decode(nvl(executions,0),0,1,executions) avg_etime, 
buffer_gets/decode(nvl(executions,0),0,1,executions) avg_lio,
sql_plan_baseline baseline,
--sql_profile,
substr(sql_text,1,60) 
from gv$sql s
where sql_id like nvl('&sql_id',sql_id)
and upper(sql_text) like upper(nvl('&sql_text',sql_text))
and sql_text not like '%from v$sql where sql_text like nvl(%'
order by 1, 2, 3
/

-- show active user sessions on all instances

set pagesize 999
set lines 150

col username format a13
col prog format a10 trunc
col sql_text format a40 trunc
col inst_id for 9
col sid format 9999
col child for 99999
col avg_etime for 999,999.99

select /* as.sql query*/
a.inst_id inst, sid, substr(program,1,19) prog,
-- address,  hash_value, 
b.sql_id, child_number child, plan_hash_value, executions execs, 
(elapsed_time/decode(nvl(executions,0),0,1,executions))/1000000 avg_etime, sql_text
from gv$session a, gv$sql b
where a.inst_id = b.inst_id
and a.sql_id = b.sql_Id
and a.sql_child_number = b.child_number
and a.status = 'ACTIVE'
and a.type = 'USER'
and a.username is not null
and sql_text not like 'select /* as.sql query%' 
order by avg_etime, inst, sql_id, sql_child_number
/

set pages 9999
set lines 300

select a.inst_id, 'kill -9 ' || b.spid, a.machine, a.program
  from gv$session a, gv$process b
 where a.inst_id = b.inst_id
   and a.paddr = b.addr
   and a.sql_id = '&sql_id' order by 1
/

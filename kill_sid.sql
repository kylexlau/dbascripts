set pages 9999
set lines 300

select 'kill -9 ' || b.spid
  from v$session a, v$process b
 where a.paddr = b.addr and 
 a.sid in
( &sids )
/

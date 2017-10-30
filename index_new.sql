set pages 999
set lines 300

col owner for a10
col object_name for a30
col object_type for a20
col created for a20

 select owner, object_name, object_type, created
  from dba_objects
 where object_type in ('INDEX', 'INDEX PARTITION')
   and owner not in ('SYS','SYSTEM')
   and created > sysdate - &days
   order by created
/

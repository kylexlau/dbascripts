set pages 999
set lines 300

col owner for a10
col object_name for a30
col object_type for a20
col tablespace_name for a20
col created for a20

 select a.owner, a.object_name, a.object_type,b.tablespace_name,a.created
  from dba_objects a, dba_indexes b
 where a.object_name = b.index_name
   and a.object_type in ('INDEX', 'INDEX PARTITION')
   and a.owner not in ('SYS','SYSTEM')
   and a.created > sysdate - &days
   order by a.created
/

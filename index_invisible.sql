col owner for a15
col seg_name for a30
col tab_name for a30
col tab_owner for a10
col ts_name for a15
col mb for 99999999

select 
a.owner owner
,b.segment_name seg_name
,a.table_owner tab_owner
,a.table_name  tab_name
,a.tablespace_name ts_name
,c.last_ddl_time
,sum(b.bytes)/1024/1024 MB
from 
dba_indexes a,
dba_segments b,
dba_objects c
where 
a.index_name = b.segment_name
and a.index_name = c.object_name
and a.visibility = 'INVISIBLE'
group by 
a.owner
,b.segment_name
,a.table_owner
,a.table_name
,a.tablespace_name
,c.last_ddl_time
order by c.last_ddl_time desc
/

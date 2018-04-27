col owner for a20
col segment_type for a20
col segment_name for a30
col partition_name for a20
col MB for 999,999,999

select * from (
    select owner,segment_name,partition_name,segment_type, bytes/1024/1024 MB from dba_segments where tablespace_name like '%&ts%'order by bytes desc)
where rownum < &2
/

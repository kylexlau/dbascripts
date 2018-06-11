col owner for a20
col segment_type for a20
col segment_name for a30
col partition_name for a20
col MB for 999,999,999
col ratio for 0.99

select * from (
    select owner,segment_name,partition_name,segment_type, bytes/1024/1024 MB,ratio_to_report(bytes) over() ratio from dba_segments where tablespace_name like '%&ts%' and bytes is not null order by bytes desc)
where rownum < &2
/

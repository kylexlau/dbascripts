col MB for 999,999,999
select * from (
    select segment_name,segment_type, bytes/1024/1024 MB from dba_segments order by bytes desc)
where rownum <11
/

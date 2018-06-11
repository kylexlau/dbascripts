col GB for 999999999999.99
col ratio for 0.99

select * from (
    select segment_name,sum(bytes/1024/1024/1024) GB,ratio_to_report(sum(bytes)) over () ratio from dba_segments group by segment_name order by 2 desc
) where rownum < &1;

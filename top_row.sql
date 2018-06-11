col ratio for 0.99

select * from (
    select owner,table_name,num_rows,ratio_to_report(num_rows) over () ratio from dba_tables where num_rows is not null order by num_rows desc
) where rownum < &1;

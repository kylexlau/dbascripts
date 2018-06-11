col G for 99999999
col owner for a10
col RATIO for 0.99

select * from (
    select 
    b.object_name,
    b.object_type,
    b.owner,
    round(sum(a.db_block_changes_delta) * 8 / 1024 / 1024, 0) change_GB,
    ratio_to_report(sum(a.db_block_changes_delta)) over () ratio
    from dba_hist_seg_stat a, dba_hist_seg_stat_obj b, dba_hist_snapshot c
    where a.obj# = b.obj#
    and a.ts# = b.ts#
    and a.dataobj# = b.dataobj#
    and a.snap_id = c.snap_id
    and b.object_type != 'UNDEFINED'
    and c.begin_interval_time > sysdate - &day
    group by b.object_name, b.object_type, b.owner
    order by 4 desc)
where rownum < 20;

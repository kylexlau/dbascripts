select *
from (select a.parsing_schema_name,
    a.module,
    a.sql_id,
    a.plan_hash_value,
    round(sum(a.buffer_gets_delta) * 8 / 1024 / 1024, 0) GB
    from dba_hist_sqlstat      a,
    dba_hist_snapshot     c
    where a.snap_id = c.snap_id
    and c.begin_interval_time > sysdate - &days
    and a.parsing_schema_name is not null
    and a.instance_number in (&insts)
    group by a.sql_id,a.parsing_schema_name,a.module,a.plan_hash_value
    order by 5 desc)
where rownum < 20;

set lines 300
set pages 9999

col inst_id format 9
col text for a80 tru

with m as
(select *
    from (select sql_plan_hash_value, sql_plan_line_id, count(*) cnt
        from gv$active_session_history
        where session_state = 'ON CPU'
        and sample_time > &sample_time
        group by sql_plan_hash_value, sql_plan_line_id
        having count(*) > &cnt
        order by cnt desc
    )
    where rownum <= 10)
select a.INST_ID             inst,
a.sql_id              sql,
m.sql_plan_hash_value plan,
m.sql_plan_line_id    line,
m.cnt,
a.sql_text            text
from m
left join (select inst_id,
    PLAN_HASH_VALUE,
    sql_id,
    sql_text,
    row_number() over(partition by inst_id, plan_hash_value order by buffer_gets) rn
    from gv$sql) a
on m.sql_plan_hash_value = a.plan_hash_value
where rn = 1
and sql_plan_hash_value != 0
order by cnt desc
;

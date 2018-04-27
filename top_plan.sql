set lines 300
set pages 9999

col inst_id format 9
col text for a30 tru
col last_load_time for a30 
col schema for a15 trunc
col module for a15 trunc

with m as
(select *
    from (select sql_plan_hash_value, sql_plan_line_id, count(*) cnt
        from gv$active_session_history
        where session_state = 'ON CPU'
        and sample_time > &sample_time
        and inst_id in (&inst_ids)
        group by sql_plan_hash_value, sql_plan_line_id
        having count(*) > &cnt
        order by cnt desc
    )
    where rownum <= 20)
select
m.sql_plan_hash_value plan,
m.sql_plan_line_id    line,
m.cnt,
a.inst_id             inst_id,
a.sql_id              sql,
a.parsing_schema_name schema,
a.module              module,
a.last_load_time      last_load_time
--a.sql_text            text
from m
left join (select
      inst_id,
      PLAN_HASH_VALUE,
      sql_id,
      last_load_time,
      sql_text,
      parsing_schema_name,
      module,
      row_number() over(partition by plan_hash_value order by last_load_time desc) rn
      from gv$sql) a
on m.sql_plan_hash_value = a.plan_hash_value
where rn = 1
and sql_plan_hash_value != 0
order by cnt desc
;

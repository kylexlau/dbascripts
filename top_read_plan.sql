set lines 300
set pages 9999

col inst_id format 9
col text for a50 tru
col last_load_time for a30
col schema for a15 trunc
col module for a15 trunc
col force_matching_signature for 9999999999999999999999999

with w as 
(select *
from (select force_matching_signature,
    round(sum(delta_read_io_bytes) / 1024 / 1024 / 1024, 2) read_GB
    from gv$active_session_history
    where sample_time > &sample_time
    and force_matching_signature is not null
    and force_matching_signature != 0
    group by force_matching_signature
    order by 2 desc)
where rownum < 20)
select 
w.force_matching_signature,
w.read_gb,
g.inst_id,
g.plan_hash_value,
g.sql_id,
--g.sql_text text,
g.parsing_schema_name schema,
g.module module,
g.last_load_time
from w
left join (select
    inst_id,
    PLAN_HASH_VALUE,
    sql_id,
    last_load_time,
    sql_text,
    parsing_schema_name,
    module,
    force_matching_signature,
    row_number() over(partition by force_matching_signature order by last_load_time desc) rn
    from gv$sql) g
on w.force_matching_signature = g.force_matching_signature
where rn = 1
and w.read_gb is not null
order by w.read_gb desc;

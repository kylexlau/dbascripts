col text for a30 tru
col last_load_time for a30
col schema for a15 trunc
col module for a15 trunc
col ratio for 0.99

with t1 as
 (select *
    from (select s.FORCE_MATCHING_SIGNATURE, count(*) cnt
            from gv$sql s
           where s.FORCE_MATCHING_SIGNATURE != 0
           group by FORCE_MATCHING_SIGNATURE
          having count(*) > &cnt
           order by 2 desc)
   where rownum <= &top_n)
select t1.cnt,
       t1.FORCE_MATCHING_SIGNATURE,
       t2.PLAN_HASH_VALUE,
       t2.inst_id,
       t2.sql_id,
       t2.last_load_time,
       t2.parsing_schema_name schema,
       t2.module,
       t2.sql_text text,
       ratio_to_report(t1.cnt) over () ratio
  from t1
  left join (select inst_id,
                    PLAN_HASH_VALUE,
                    FORCE_MATCHING_SIGNATURE,
                    sql_id,
                    last_load_time,
                    sql_text,
                    parsing_schema_name,
                    module,
                    row_number() over(partition by FORCE_MATCHING_SIGNATURE order by last_load_time desc) rn
               from gv$sql) t2
    on t1.FORCE_MATCHING_SIGNATURE = t2.FORCE_MATCHING_SIGNATURE
 where rn = 1
 order by cnt desc
/

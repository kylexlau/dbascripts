set lines 300
set pages 9999

select sql_id from gv$sqlarea where plan_hash_value = &plan_hash
/
 
select sql_id from dba_hist_sqlstat where plan_hash_value = &plan_hash
/

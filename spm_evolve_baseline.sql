set lines 400
set pages 49999
set longc 49999

SELECT DBMS_SPM.evolve_sql_plan_baseline(sql_handle => '&sql_handle') From dual;

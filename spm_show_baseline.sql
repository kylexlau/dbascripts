set pages 50000
set lines 500
set long  399999

select * from table(dbms_xplan.display_sql_plan_baseline(
        sql_handle=>'&sql_handle',
        plan_name=>'&plan_name'))
/

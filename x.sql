set lines 400
set pages 49999

select * from table(dbms_xplan.display_cursor(null,null,'allstats last'))
/

-- select * from table(dbms_xplan.display_cursor(null,null,'ADVANCED RUNSTATS_LAST'));

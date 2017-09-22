set lines 500
set pages 9999

select * from table(dbms_xplan.display_cursor('&sql_id',nvl('&child_no',null),'allstats +peeked_binds'))
/

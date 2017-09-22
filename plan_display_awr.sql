set lines 400
set pages 49999

SELECT * FROM table(dbms_xplan.display_awr(nvl('&sql_id','0hch9c91yc370'),nvl('&plan_hash_value',null),null,'typical +peeked_binds'))
/

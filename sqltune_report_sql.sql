-- set linesize 2000 PAGESIZE 0 LONG 100000
SET LONG 100000
SET LONGCHUNKSIZE 10000
SET PAGESIZE 9999
SET LINESIZE 200
set serveroutput on;

variable object_id number;

begin
select object_id into :object_id 
from (select *
    from dba_advisor_sqlstats
    where sql_id = '&sql'
    order by execution_name desc)
where rownum = 1;
end;
/

select DBMS_SQLTUNE.REPORT_AUTO_TUNING_TASK(object_id => nvl(:object_id,0)) FROM DUAL;

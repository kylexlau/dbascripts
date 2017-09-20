-- run sql tunning task and report 

SET LONG 100000
SET LONGCHUNKSIZE 10000
SET PAGESIZE 9999
SET LINESIZE 200
set serveroutput on;

accept sql_id -
    prompt 'Enter value for sql_id: '

var tuning_task varchar2(100);  

DECLARE  
l_sql_id v$session.prev_sql_id%TYPE;  
l_tuning_task VARCHAR2(30);  
BEGIN  
    l_sql_id:='&&sql_id';  
    l_tuning_task := dbms_sqltune.create_tuning_task(sql_id => l_sql_id);  
    :tuning_task:=l_tuning_task;  
    dbms_sqltune.execute_tuning_task(l_tuning_task);  
    dbms_output.put_line(l_tuning_task);  
END;  
/

SELECT dbms_sqltune.report_tuning_task(:tuning_task) FROM dual;

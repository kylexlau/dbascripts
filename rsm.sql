----------------------------------------------------------------------------------------
--
-- File name:   rsm.sql (report_sql_monitor.sql)
--
-- Purpose:     Execute DBMS_SQLTUNE.REPORT_SQL_MONITOR function.
--
-- Author:      Kerry Osborne
--              
-- Usage:       This scripts prompts for two values (SQL_ID and SQL_EXEC_ID), both of 
--              which can be left blank.
--
--              If both parameters are left blank, the last statement monitored
--              for the current session will be reported on.
--
--              If the SQL_ID is specified and the SQL_EXEC_ID is left blank,
--              the last execution of the specified statement will be reported,
--              regardless of which session executed it.
--
--              If the SQL_EXEC_ID is specified and the SQL_ID is left blank,
--              the last statement executed with the specified SQL_EXEC_ID will be
--              reported (although this probably doesn't make much sense to do).
--
--              Note:   If a match is not found - the header is printed with no data.
--                    In such a case, look in v$sql_monitor to see if your statement
--                    is still there.
--
--
--             See kerryosborne.oracle-guy.com for additional information.
--             Also check out Tanel's post on sql_exec_id: http://goo.gl/FBGAhh
---------------------------------------------------------------------------------------
set long 999999999
set lines 400
col report for a379
select
DBMS_SQLTUNE.REPORT_SQL_MONITOR(
       sql_id=>'&sql_id',
       sql_exec_id=>'&sql_exec_id',
       report_level=>'ALL') 
as report
from dual;
set lines 155


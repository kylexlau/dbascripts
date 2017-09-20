-- report sql monitor, html format

SET LONG 1000000
SET LONGCHUNKSIZE 1000000
SET LINESIZE 1000
SET PAGESIZE 0
SET TRIM ON
SET TRIMSPOOL ON
SET ECHO OFF
SET FEEDBACK OFF

SPOOL report_sql_monitor.htm
SELECT DBMS_SQLTUNE.report_sql_monitor(
      sql_id       => '&sql_id',
      type         => 'ACTIVE',
      report_level => 'ALL'
      ) AS report
FROM dual;
SPOOL OFF

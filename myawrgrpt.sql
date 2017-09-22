-- sqlplus setting
set echo off veri off feedback off termout on heading off linesize 1500

-- variables declaration
variable dbid number;
variable bid  number;
variable eid  number;
variable dbname varchar2(20);

-- variables definition
begin
    select dbid into :dbid from v$database;
    select name into :dbname from v$database;
    select max(snap_id)-1 into :bid from sys.dba_hist_snapshot where begin_interval_time < &begin_time;
    select max(snap_id)   into :eid from sys.dba_hist_snapshot;
end;
/

-- report name
set termout off;
column report_name new_value report_name noprint;
--select lower(:dbname) || '_awrgrpt_' || to_char(sysdate,'yyyymmdd')||'_' || to_char(to_char(sysdate,'hh24')-1) || '-' || to_char(sysdate,'hh24') || '.html' report_name from dual;
select lower(:dbname) || '_awrgrpt_' || to_char(sysdate,'yyyymmdd')|| '_' || :bid || '-' || :eid || '.html' report_name from dual;
set termout on;

-- report
spool &report_name;
select output from table(dbms_workload_repository.awr_global_report_html(:dbid,'',:bid,:eid,0));
spool off;

exit;

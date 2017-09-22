-- sqlplus setting
set echo off veri off feedback off termout on heading off linesize 1500

-- variables declaration
variable dbid number;
variable bid  number;
variable eid  number;
variable inst_num  number;
variable inst_name varchar2(20);

-- variables definition
begin
    select dbid into :dbid from v$database;
    select instance_name into :inst_name from v$instance;
    select instance_number into :inst_num from v$instance;
    select max(snap_id)-1 into :bid from sys.dba_hist_snapshot where instance_number = :inst_num and begin_interval_time < &begin_time;
    select max(snap_id) into :eid from sys.dba_hist_snapshot where instance_number = :inst_num;
end;
/

-- report name
set termout off;
column report_name new_value report_name noprint;
select :inst_name || '_awrrpt_' || to_char(sysdate,'yyyymmdd')||'_' || to_char(to_char(&begin_time,'hh24')-1) || '-' || to_char(sysdate,'hh24') || '.html' report_name from dual;
set termout on;

-- report
spool &report_name;
select output from table(dbms_workload_repository.awr_report_html(:dbid,:inst_num,:bid,:eid,0 ));
spool off;

exit;

-- generate awr sql report

set lines 600 
set pages 49999 
set longc 49999

accept days-
  prompt 'Enter value for days: ' -
  default 'null'

variable dbid number;
variable inst_num  number;
variable bid  number;
variable eid  number;
variable sqlid varchar2(30);

begin
  select dbid            into :dbid from v$database;
  select instance_number into :inst_num from v$instance;

  select min(snap_id)    into :bid  from dba_hist_snapshot s where 
         s.end_interval_time >= sysdate - &days 
         and s.instance_number = (select instance_number from v$instance);

  select max(snap_id)    into :eid  from dba_hist_snapshot s where 
         s.end_interval_time >= sysdate - &days 
         and s.instance_number = (select instance_number from v$instance);

  select lower('&sql_id')  into :sqlid from dual;
end;
/


select output from table(
    dbms_workload_repository.awr_sql_report_text( 
        :dbid,
        :inst_num,
        :bid, 
        :eid,
        :sqlid,
        0)
);


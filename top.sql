set echo off feed off
set serveroutput on size 1000000 format wrapped
set lines 200 pages 9999

col schema format a15 trunc
col module format a20 trunc

-- variables declaration
variable bid  number;
variable eid  number;
variable limit  number;

-- variables definition
begin
    select max(snap_id) into :bid from sys.dba_hist_snapshot where begin_interval_time < &begin_time;
    select max(snap_id) into :eid from sys.dba_hist_snapshot;
    select &limit into :limit from dual;
end;
/

-- time period
alter session set NLS_TIMESTAMP_FORMAT="YYYY-MM-DD HH24:MI:SS";
select snap_id id,begin_interval_time time from dba_hist_snapshot where snap_id = :bid and rownum = 1
union all
select snap_id id,end_interval_time time from dba_hist_snapshot where snap_id = :eid and rownum = 1;

-- top sqls
exec dbms_output.new_line;
exec dbms_output.new_line;
exec dbms_output.put_line('Top SQL by buffer gets');

SELECT 
sql_id,
plan_hash_value,
-- substr(sql_text,0,20) sql_text,
parsing_schema_name schema,
module,
round(elapsed_time/1000/1000) etime,
round(cpu_time/1000/1000) cpu_time,
round(buffer_gets*8/1024/1024) gets_G,
round(disk_reads*8/1024/1024) reads_G,
rows_processed,
fetches,
executions
FROM table(
    DBMS_SQLTUNE.SELECT_WORKLOAD_REPOSITORY(
        begin_snap       => :bid,
        end_snap         => :eid,
        --basic_filter     => 'parsing_schema_name <> ''SYS''',
        ranking_measure1 => 'buffer_gets',
        result_limit     => :limit
    )
);


exec dbms_output.new_line;
exec dbms_output.put_line('Top SQL by CPU time');

SELECT 
sql_id,
plan_hash_value,
-- substr(sql_text,0,20) sql_text,
parsing_schema_name schema,
module,
round(elapsed_time/1000/1000) etime,
round(cpu_time/1000/1000) cpu_time,
round(buffer_gets*8/1024/1024) gets_G,
round(disk_reads*8/1024/1024) reads_G,
rows_processed,
fetches,
executions
FROM table(
    DBMS_SQLTUNE.SELECT_WORKLOAD_REPOSITORY(
        begin_snap       => :bid,
        end_snap         => :eid,
        --basic_filter     => 'parsing_schema_name <> ''SYS''',
        ranking_measure1 => 'cpu_time',
        result_limit     => :limit
    )
);


exec dbms_output.new_line;
exec dbms_output.put_line('Top SQL by Disk Reads');

SELECT 
sql_id,
plan_hash_value,
-- substr(sql_text,0,20) sql_text,
parsing_schema_name schema,
module,
round(elapsed_time/1000/1000) etime,
round(cpu_time/1000/1000) cpu_time,
round(buffer_gets*8/1024/1024) gets_G,
round(disk_reads*8/1024/1024) reads_G,
rows_processed,
fetches,
executions
FROM table(
    DBMS_SQLTUNE.SELECT_WORKLOAD_REPOSITORY(
        begin_snap       => :bid,
        end_snap         => :eid,
        --basic_filter     => 'parsing_schema_name <> ''SYS''',
        ranking_measure1 => 'disk_reads',
        result_limit     => :limit
    )
);


exec dbms_output.new_line;
exec dbms_output.put_line('Top SQL by elapsed time');

SELECT 
sql_id,
plan_hash_value,
-- substr(sql_text,0,20) sql_text,
parsing_schema_name schema,
module,
round(elapsed_time/1000/1000) etime,
round(cpu_time/1000/1000) cpu_time,
round(buffer_gets*8/1024/1024) gets_G,
round(disk_reads*8/1024/1024) reads_G,
rows_processed,
fetches,
executions
FROM table(
    DBMS_SQLTUNE.SELECT_WORKLOAD_REPOSITORY(
        begin_snap       => :bid,
        end_snap         => :eid,
        --basic_filter     => 'parsing_schema_name <> ''SYS''',
        ranking_measure1 => 'elapsed_time',
        result_limit     => :limit
    )
);


exec dbms_output.new_line;
exec dbms_output.put_line('Top SQL by executions');

SELECT 
sql_id,
plan_hash_value,
-- substr(sql_text,0,20) sql_text,
parsing_schema_name schema,
module,
round(elapsed_time/1000/1000) etime,
round(cpu_time/1000/1000) cpu_time,
round(buffer_gets*8/1024/1024) gets_G,
round(disk_reads*8/1024/1024) reads_G,
rows_processed,
fetches,
executions
FROM table(
    DBMS_SQLTUNE.SELECT_WORKLOAD_REPOSITORY(
        begin_snap       => :bid,
        end_snap         => :eid,
        --basic_filter     => 'parsing_schema_name <> ''SYS''',
        ranking_measure1 => 'executions',
        result_limit     => :limit
    )
);


exec dbms_output.new_line;
exec dbms_output.put_line('Top SQL by fetches');

SELECT 
sql_id,
plan_hash_value,
-- substr(sql_text,0,20) sql_text,
parsing_schema_name schema,
module,
round(elapsed_time/1000/1000) etime,
round(cpu_time/1000/1000) cpu_time,
round(buffer_gets*8/1024/1024) gets_G,
round(disk_reads*8/1024/1024) reads_G,
rows_processed,
fetches,
executions
FROM table(
    DBMS_SQLTUNE.SELECT_WORKLOAD_REPOSITORY(
        begin_snap       => :bid,
        end_snap         => :eid,
        --basic_filter     => 'parsing_schema_name <> ''SYS''',
        ranking_measure1 => 'fetches',
        result_limit     => :limit
    )
);


exec dbms_output.new_line;
exec dbms_output.new_line;
exec dbms_output.put_line('Top SQL by rows processed');

SELECT 
sql_id,
plan_hash_value,
-- substr(sql_text,0,20) sql_text,
parsing_schema_name schema,
module,
round(elapsed_time/1000/1000) etime,
round(cpu_time/1000/1000) cpu_time,
round(buffer_gets*8/1024/1024) gets_G,
round(disk_reads*8/1024/1024) reads_G,
rows_processed,
fetches,
executions
FROM table(
    DBMS_SQLTUNE.SELECT_WORKLOAD_REPOSITORY(
        begin_snap       => :bid,
        end_snap         => :eid,
        --basic_filter     => 'parsing_schema_name <> ''SYS''',
        ranking_measure1 => 'rows_processed',
        result_limit     => :limit
    )
);

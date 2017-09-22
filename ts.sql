set pages 9999
set lines 500

--Comprehensive tablespace free space report.
column ts_name      format a32                 heading "Tablespace Name"
column extensible   format 999,999,999,999,999 heading "Extensible|MB"
column extens_free  format 999,999,999,999,999 heading "Extensible|Free"
column pct_used_ext format 999.9               heading "Ext. %|Used"
column allocated    format 999,999,999,999,999 heading "Allocated|MB"
column alloc_free   format 999,999,999,999,999 heading "Allocated|Free"
column used         format 999,999,999,999,999 heading "Used|MB"
column pct_used     format 999.9               heading "%|Used"
column ne           format 999,999,999,999     heading "Extendable"
break on report
compute sum of extensible  on report
compute sum of allocated   on report
compute sum of used        on report
compute sum of alloc_free  on report
compute sum of extens_free on report

select ts_name
,        extensible_bytes/1024/1024               extensible
,        allocated_bytes/1024/1024                allocated
,        alloc_free/1024/1024                     alloc_free  
,        (allocated_bytes - alloc_free)/1024/1024 used
,        100 * (allocated_bytes - alloc_free) / allocated_bytes pct_used
,        to_number(decode(allocated_bytes, extensible_bytes, NULL,
        extensible_bytes
        - (allocated_bytes - alloc_free)))/1024/1024 ne
,        to_number(decode(allocated_bytes, extensible_bytes, NULL, 
        100 * (extensible_bytes - (extensible_bytes - (allocated_bytes - alloc_free)))
        / extensible_bytes))             pct_used_ext
from (  
    select a.tablespace_name              ts_name
    ,        sum(decode(b.autoextensible, 'YES', b.maxbytes, b.bytes))
    / count(distinct a.file_id||'.'||a.block_id) extensible_bytes
    ,        sum(b.bytes)/count(distinct a.file_id||'.'||a.block_id)  allocated_bytes
    ,        sum(a.bytes)/count(distinct b.file_id) alloc_free
    from sys.dba_free_space             a
    ,        sys.dba_data_files             b
    where a.tablespace_name              = b.tablespace_name (+)
    group by a.tablespace_name
    ,        b.tablespace_name)
order by 6 desc;

column ts_name clear
column extensible clear
column extens_free clear
column pct_used_ext clear
column allocated clear
column alloc_free clear
column used clear
column pct_used clear
column ne clear

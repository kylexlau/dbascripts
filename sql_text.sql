set pages 49999
set lines 400
set longc 399999
col sql_text for a999

accept sql_id -
    prompt 'Enter value for sql_id: ' -
    default 'X0X0X0X0'

select sql_fulltext from gv$sqlarea where sql_id = '&sql_id' and rownum =1
/

select sql_text from dba_hist_sqltext where sql_id = '&sql_id'
/

-- set serveroutput on size 1000000
set trimspool on
set long 5000
set pages 9999 lines 400
col report format a400
column plan_plus_exp format a80

-- sqlprompt
column global_name new_value gname
set termout off
define gname=idle
column global_name new_value gname
-- select lower(user) ||'@'|| substr(global_name,1,decode(dot,0,length(global_name),dot-1)) global_name
-- from (select global_name,instr(global_name,'.') dot from global_name);
select lower(user) ||'@'|| instance_name global_name from v$instance;

set sqlprompt '&gname>'
set termout on
def _editor=vi

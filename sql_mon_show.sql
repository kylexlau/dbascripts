select inst_id,sql_id,status,sql_exec_id,sql_exec_start,
    BUFFER_GETS*8/1024 gets_mb,ELAPSED_TIME/1000/1000 etime_s, program,username
from gv$sql_monitor where sql_id = '&sql_id' order by 2,4;

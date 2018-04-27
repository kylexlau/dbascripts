select logtime,
count(*),  
round(sum(blocks * block_size) / 1024 / 1024/1024, 0) size_Gb
from (select trunc(first_time, 'dd') as logtime, a.BLOCKS, a.BLOCK_SIZE
    from v$archived_log a  
    where a.DEST_ID = 1 
    and a.FIRST_TIME > trunc(sysdate - &days))  
group by logtime
order by logtime desc;

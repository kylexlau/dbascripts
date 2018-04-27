--------------------------------------------------------------------------------
--
-- File name:   disco.sql
-- Purpose:     Generates commands for disconnecting selected sessions
--
-- Author:      Tanel Poder
-- Copyright:   (c) http://www.tanelpoder.com
--              
-- Usage:       @disco <filter expression>
-- 	        @disco sid=150
--	        @disco username='SYSTEM'
--              @disco "username='APP' and program like 'sqlplus%'"
--
-- Other:       This script doesnt actually kill or disconnect any sessions       
--              it just generates the ALTER SYSTEM DISCONNECT SESSION
--              commands, the user can select and paste in the selected
--              commands manually
--
--------------------------------------------------------------------------------

select 'alter system disconnect session '''||a.sid||','||a.serial#||''' immediate -- '
       || 'plan: ' || b.plan_hash_value || ' inst_id: ' || a.inst_id || ' ' ||username||'@'||machine||' ('||program||');' commands_to_verify_and_run
from gv$session a,gv$sql b
where a.inst_id = b.inst_id
and a.sql_id = b.sql_id
and b.plan_hash_value=&1
and type='USER'
/

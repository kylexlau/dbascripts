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

select 'alter system disconnect session '''||sid||','||serial#||''' immediate -- '
       || 'inst_id: ' || inst_id || ' ' ||username||'@'||machine||' ('||program||');' commands_to_verify_and_run
from gv$session
where &1
and type='USER'
order by inst_id
/

----------------------------------------------------------------------------------------
--
-- File name:   gps.sql
--
-- Purpose:     Creates a SQL Profile on a statement adding  the GATHER_PLAN_STATISTICS hint.
-
-- Author:      Kerry Osborne
--
-- Usage:       This scripts prompts for one value.
--
--              sql_id: the sql_id of the statement to attach the profile to (must be in the shared pool)
--
--
--              See kerryosborne.oracle-guy.com for additional information.
----------------------------------------------------------------------------------------- 

accept sql_id -
    prompt 'Enter value for sql_id: ' -
    default 'X0X0X0X0'

set feedback off
set sqlblanklines on

declare
l_profile_name varchar2(30);
cl_sql_text clob;
begin

    select
    sql_fulltext
    into
    cl_sql_text
    from
    v$sqlarea
    where
    sql_id = '&&sql_id';

    l_profile_name := 'PROFILE_'||'&&sql_id'||'_GPS';

    dbms_sqltune.import_sql_profile(
        sql_text => cl_sql_text, 
        profile => sqlprof_attr('gather_plan_statistics'),
        category => 'DEFAULT',
        name => l_profile_name);

    dbms_output.put_line(' ');
    dbms_output.put_line('Profile '||l_profile_name||' created.');
    dbms_output.put_line(' ');

    exception
    when NO_DATA_FOUND then
        dbms_output.put_line(' ');
        dbms_output.put_line('ERROR: sql_id: '||'&&sql_id'||' not found in v$sqlarea.');
        dbms_output.put_line(' ');

end;
/

undef sql_id

set sqlblanklines off
set feedback on

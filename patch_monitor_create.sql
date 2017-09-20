----------------------------------------------------------------------------------------
--
-- File name:   monitor_sql.sql
--
-- Purpose:     Prompts for a ql_id and creates a patch with the monitor hint
-
-- Author:      Kerry Osborne
--
-- Usage:       This scripts prompts for one value.
--
--              sql_id: the sql_id of the statement to attach the patch to 
--                      (the statement must be in the shared pool)
--
--              
--              See kerryosborne.oracle-guy.com for additional information.
----------------------------------------------------------------------------------------- 

accept sql_id -
    prompt 'Enter value for sql_id: ' -
    default 'X0X0X0X0'


set feedback off
set sqlblanklines on
set serverout on format wrapped

declare
l_patch_name varchar2(30);
cl_sql_text clob;
l_category varchar2(30);
l_validate varchar2(3);
b_validate boolean;
begin


    select
    sql_fulltext
    into
    cl_sql_text
    from
    v$sqlarea
    where
    sql_id = '&&sql_id';

    dbms_sqldiag_internal.i_create_patch(
        sql_text => cl_sql_text, 
        hint_text => 'MONITOR',
        name => 'MONITOR_PATCH_'||'&&sql_id',
        category => 'DEFAULT',
        validate => FALSE
    );

    dbms_output.put_line(' ');
    dbms_output.put_line('SQL Patch '||l_patch_name||' created.');
    dbms_output.put_line(' ');

    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line(' ');
        dbms_output.put_line('ERROR: SQL_ID: '||'&&sql_id'||' does not exist in v$sqlarea.');
        dbms_output.put_line('The SQL statement must be in the shared pool to use this script.');
        dbms_output.put_line(' ');
end;
/

undef sql_id

set sqlblanklines off
set feedback on
set serverout off


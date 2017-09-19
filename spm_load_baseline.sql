-- load baseline from other sql

declare
  ret PLS_INTEGER;
begin
 ret :=dbms_spm.load_plans_from_cursor_cache(
    sql_id => '&sql',
    plan_hash_value => '&plan',
    sql_handle => '&handle',
    fixed => 'NO',
    enabled => 'YES');
end;
/

-- disable a baseline

declare
  ret PLS_INTEGER;
begin
 ret :=dbms_spm.alter_sql_plan_baseline(
    sql_handle => '&sql_handle',
    plan_name => '&plan_name',
    attribute_name => 'enabled',
    attribute_value => 'NO'
    );
end;
/

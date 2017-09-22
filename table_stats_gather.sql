set sqlblanklines on
set serveroutput on

accept owner-
  prompt 'Enter value for owner: ' -
  default 'null'

accept table_name-
  prompt 'Enter value for table name: '-
  default 'null'


begin

    dbms_stats.gather_table_stats(
        ownname => '&&owner',
        tabname => '&&table_name' ,
        estimate_percent => 10,
        method_opt => 'for all columns size repeat' ,
        cascade => true,
        degree => 4
    );

end;
/

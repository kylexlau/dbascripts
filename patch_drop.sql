-- drop a sql patch 

BEGIN
  DBMS_SQLDIAG.drop_sql_patch(name => '&patch_name');
END;
/

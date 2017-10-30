declare
done boolean;
begin
    done:=dbms_repair.online_index_clean(&index_id);
end;
/

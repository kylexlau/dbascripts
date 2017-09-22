set lines 300
set pages 9999

select
extractvalue(value(d), '/hint') as outline_hints
from
xmltable('/*/outline_data/hint'
    passing (
        select
        xmltype(other_xml) as xmlval
        from
        v$sql_plan
        where
        sql_id like nvl('&sql_id',sql_id)
        and child_number = nvl('&child_no',0)
        and other_xml is not null
    )
) d;

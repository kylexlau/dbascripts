rem $Header$
rem $Name$

rem Copyright (c); 2004 by Hotsos Enterprises, Ltd.
rem
rem Retrieve statistics information for a table
rem
rem Usage:  SQL>@hstats <table name>
rem
--
-- Modified by Kerry Osborne
-- commented out Histogram section
-- added prompts
-- added ability to run against table in another schmea

set echo off feed off
set serveroutput on size 1000000

 accept ownname prompt 'Owner : '
 accept tabname prompt 'Table : '

set lines 80

define v_desc = '&ownname..&tabname.'
desc &v_desc
set lines 200

declare
  v_query varchar2(4000)  ;
  v_owner varchar2(30) := upper('&&ownname');
  v_table varchar2(30) := upper('&&tabname');
  v_max_colname   number ;
  v_max_ndv               number ;
  v_max_nulls     number ;
  v_max_bkts      number ;
  v_max_smpl      number ;
  v_max_endnum    number ;
  v_max_endval    number ;
  v_ct                    number ;
  prev_col                varchar2(30) ;


  cursor col_stats is
  select a.column_name, nvl(a.last_analyzed,to_date('01/01/1900','mm/dd/yyyy')) last_analyzed,
                 decode(a.nullable,'N','NOT NULL','        ') nullable,
                 a.num_distinct, a.density, a.num_nulls,
         a.num_buckets, a.avg_col_len, a.sample_size
    from all_tab_columns a
   where a.owner = v_owner
     and a.table_name = v_table ;

  cursor hist_stats is
  select b.column_name, b.endpoint_number, b.endpoint_value, b.endpoint_actual_value
        from all_tab_histograms b
   where b.owner = v_owner
         and b.table_name = v_table
         and (exists (select 1 from all_tab_columns
                           where num_buckets > 1
                             and owner = b.owner
                             and table_name = b.table_name
                             and column_name = b.column_name)
                  or
                  exists (select 1 from all_tab_histograms
                           where endpoint_number > 1
                             and owner = b.owner
                             and table_name = b.table_name
                             and column_name = b.column_name)
                 )
        order by b.column_name, b.endpoint_number;

        procedure print_table ( p_query in varchar2,  p_date_fmt in varchar2 default 'dd-MON-yyyy hh24:mi:ss' ) is
                    l_theCursor     integer default dbms_sql.open_cursor;
                    l_columnValue   varchar2(4000);
                    l_status        integer;
                    l_descTbl       dbms_sql.desc_tab;
                    l_colCnt        number;
                    l_cs            varchar2(255);
                    l_date_fmt      varchar2(255);

                    -- Small inline procedure to restore the session's state.
                    -- We may have modified the cursor sharing and nls date format
                    -- session variables. This just restores them.
                    procedure restore
                    is
                    begin
                       if ( upper(l_cs) not in ( 'FORCE','SIMILAR' ))
                       then
                           execute immediate
                           'alter session set cursor_sharing=exact';
                       end if;
                       if ( p_date_fmt is not null )
                       then
                           execute immediate
                               'alter session set nls_date_format=''' || l_date_fmt || '''';
                       end if;
                       dbms_sql.close_cursor(l_theCursor);
                    end restore;
                begin
                    -- I like to see the dates print out with times, by default. The
                    -- format mask I use includes that.  In order to be "friendly"
                    -- we save the current session's date format and then use
                    -- the one with the date and time.  Passing in NULL will cause
                    -- this routine just to use the current date format.
                    if ( p_date_fmt is not null )
                    then
                       select sys_context( 'userenv', 'nls_date_format' )
                         into l_date_fmt
                         from dual;
                       execute immediate
                       'alter session set nls_date_format=''' || p_date_fmt || '''';
                    end if;

                    -- To be bind variable friendly on ad-hoc queries, we
                    -- look to see if cursor sharing is already set to FORCE or
                    -- similar. If not, set it to force so when we parse literals
                    -- are replaced with binds.
                    if ( dbms_utility.get_parameter_value
                         ( 'cursor_sharing', l_status, l_cs ) = 1 )
                    then
                        if ( upper(l_cs) not in ('FORCE','SIMILAR'))
                        then
                            execute immediate
                           'alter session set cursor_sharing=force';
                        end if;
                    end if;


                    -- Parse and describe the query sent to us.  We need
                    -- to know the number of columns and their names.
                    dbms_sql.parse(  l_theCursor,  p_query, dbms_sql.native );
                    dbms_sql.describe_columns
                    ( l_theCursor, l_colCnt, l_descTbl );

                    -- Define all columns to be cast to varchar2s. We
                    -- are just printing them out.
                    for i in 1 .. l_colCnt loop
                        dbms_sql.define_column
                        (l_theCursor, i, l_columnValue, 4000);
                    end loop;

                    -- Execute the query, so we can fetch.
                    l_status := dbms_sql.execute(l_theCursor);

                    -- Loop and print out each column on a separate line.
                    -- Bear in mind that dbms_output prints only 255 characters/line
                    -- so we'll see only the first 200 characters by my design...
                    while ( dbms_sql.fetch_rows(l_theCursor) > 0 )
                    loop
                        for i in 1 .. l_colCnt loop
                            dbms_sql.column_value
                            ( l_theCursor, i, l_columnValue );
                            dbms_output.put_line
                            ( rpad( l_descTbl(i).col_name, 30 )
                              || ': ' ||
                              substr( l_columnValue, 1, 200 ) );
                        end loop;
                        dbms_output.put_line( '-----------------' );
                    end loop;

                    -- Now, restore the session state, no matter what.
                    restore;
                exception
                    when others then
                        restore;
                        raise;
                end;


begin
  dbms_output.put_line('==========================================================================================');
  dbms_output.put_line('  Table Statistics');
  dbms_output.put_line('==========================================================================================');


  v_query := 'select table_name, last_analyzed, trim(degree) degree, partitioned,
                                 num_rows, chain_cnt, blocks, empty_blocks, avg_space,
                                 avg_row_len, monitoring, sample_size
                            from all_tables
                           where owner = ''' || UPPER(v_owner) || ''' and table_name = ''' || UPPER(v_table) || '''';
  print_table (v_query);

  v_ct := 0 ;

  select count(1)
    into v_ct
        from all_tab_partitions
   where table_owner = v_owner
     and table_name = v_table;

  if v_ct > 0 then
          dbms_output.put_line('==========================================================================================');
          dbms_output.put_line('  Partition Information');
          dbms_output.put_line('==========================================================================================');


          v_query := 'select partition_name, last_analyzed, high_value,
                                         num_rows, chain_cnt, blocks, empty_blocks,
                                         avg_space, avg_row_len
                                        from all_tab_partitions
                                   where table_owner = ''' || UPPER(v_owner) || '''
                                     and table_name = ''' || UPPER(v_table) || '''';

          print_table (v_query);
  end if ;

  select max(length(column_name)) + 1, max(length(num_distinct)) + 3,
                 max(length(num_nulls)) + 1, max(length(num_buckets)) + 1,
                 max(length(sample_size)) + 1
    into v_max_colname, v_max_ndv, v_max_nulls, v_max_bkts, v_max_smpl
    from all_tab_columns
   where owner = v_owner
     and table_name = v_table ;

  if v_max_nulls < 8 then
     v_max_nulls := 8 ;
  end if ;

  if v_max_bkts < 10 then
     v_max_bkts := 10 ;
  end if ;

  if v_max_smpl < 7 then
     v_max_smpl := 7;
  end if;

  dbms_output.put_line('==========================================================================================');
  dbms_output.put_line('  Column Statistics');
  dbms_output.put_line('==========================================================================================');
  dbms_output.put_line(' ' || rpad('Name',v_max_colname) || '  Analyzed    Null?    ' ||
                rpad(' NDV',v_max_ndv) || '  ' || rpad(' Density',10) ||
                rpad('# Nulls',v_max_nulls) || '  ' || rpad('# Buckets',v_max_bkts) || '  ' ||
                rpad('Sample',v_max_smpl) || '  Avg Col Len');
  dbms_output.put_line('==========================================================================================');


  for v_rec in col_stats loop
      dbms_output.put_line(rpad(v_rec.column_name,v_max_colname) || '  ' ||
      to_char(v_rec.last_analyzed,'mm/dd/yyyy') || '  ' ||
      v_rec.nullable || '  ' ||
      rpad(v_rec.num_distinct,v_max_ndv) ||
      to_char(v_rec.density,'9.999999') || '  ' ||
      rpad(v_rec.num_nulls,v_max_nulls) || '  ' ||
      rpad(v_rec.num_buckets,v_max_bkts) || '  ' ||
      rpad(v_rec.sample_size,v_max_smpl) || '  ' ||
      v_rec.avg_col_len );

  end loop ;

  select max(length(column_name)) + 1, max(length(endpoint_number)) + 1,
                 max(length(endpoint_value)) + 1
    into v_max_colname, v_max_endnum, v_max_endval
    from all_tab_histograms
   where owner = v_owner
     and table_name = v_table ;

  if v_max_endnum < 12 then
     v_max_endnum := 12 ;
  end if ;

  if v_max_endval < 16 then
     v_max_endval := 16 ;
  end if ;

  select count(1)
    into v_ct
        from all_tab_histograms b
   where b.owner = v_owner
         and b.table_name = v_table
         and (exists (select 1 from all_tab_columns
                           where num_buckets > 1
                             and owner = b.owner
                             and table_name = b.table_name
                             and column_name = b.column_name)
                  or
                  exists (select 1 from all_tab_histograms
                           where endpoint_number > 1
                             and owner = b.owner
                             and table_name = b.table_name
                             and column_name = b.column_name)
                 );

/* Histogram data commented out

  if v_ct > 0 then
          dbms_output.put_line('==========================================================================================');
          dbms_output.put_line('  Histogram Statistics');
          dbms_output.put_line('==========================================================================================');
          dbms_output.put_line(' ' || rpad('Name',v_max_colname) || '  ' ||
                        rpad('Endpoint #',v_max_endnum) || '  ' ||
                        rpad('Endpoint Value',v_max_endval) || '  Endpoint Actual Value');

          v_ct := 0 ;
          for v_rec in hist_stats loop
              if v_ct = 0 then
                 v_ct := 1 ;
                 prev_col := v_rec.column_name ;
              elsif prev_col <> v_rec.column_name then
                 dbms_output.put_line('------------------------------------------------------------------------------------------');
                 prev_col := v_rec.column_name ;
              end if ;
                  dbms_output.put_line(rpad(v_rec.column_name, v_max_colname) || '  ' ||
                        rpad(v_rec.endpoint_number,v_max_endnum) || '  ' ||
                        rpad(v_rec.endpoint_value,v_max_endval) || '  ' ||
                        substr(v_rec.endpoint_actual_value,1,20) ) ;
          end loop ;
  end if ;
*/

  v_ct := 0;

  select count(1)
    into v_ct
    from all_indexes a
   where a.table_owner = v_owner
     and a.table_name = v_table;

  if v_ct > 0 then
          dbms_output.put_line('==========================================================================================');
          dbms_output.put_line('  Index Information');
          dbms_output.put_line('==========================================================================================');

          v_query := 'select a.index_name, substr(a.index_type, 1, 4) index_type,
                             a.last_analyzed, a.degree, a.partitioned, a.blevel,
                             a.leaf_blocks, a.distinct_keys,
                             a.avg_leaf_blocks_per_key, a.avg_data_blocks_per_key,
                             a.clustering_factor, b.blocks blocks_in_table, b.num_rows rows_in_table
                                        from all_indexes a, all_tables b
                                   where (a.table_name = b.table_name and a.table_owner = b.owner)
                                     and a.table_owner = ''' || UPPER(v_owner) || '''
                                     and a.table_name = ''' || UPPER(v_table) || '''' ;

          print_table (v_query);

          dbms_output.put_line('==========================================================================================');
          dbms_output.put_line('  Index Columns Information');
          dbms_output.put_line('==========================================================================================');
          dbms_output.put_line('Index Name                           Pos# Order Column Name          Expression');
          dbms_output.put_line('==========================================================================================');
  end if;

end ;
/

set verify off feed off numwidth 15 lines 500 heading off
column column_name format a30 heading 'Column Name'
column index_name heading 'Index Name' format a30
column column_position format 999999999 heading 'Position'
column descend format a5 heading 'Order'
column column_expression format a40 heading 'Expression'

break on index_name skip 1

select b.index_name, b.column_position, b.descend, b.column_name,  e.column_expression
from all_ind_columns b, all_ind_expressions e
where b.table_owner = upper('&ownname')
and b.table_name = UPPER('&tabname')
and b.index_name = e.index_name(+)
order by b.index_name, b.column_position, b.column_name
/

undefine ownname
undefine tabname

set feed on numwidth 12 lines 120

clear columns
clear breaks
set lines 155
set head on

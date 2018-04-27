
select endpoint_value, endpoint_number, 
       endpoint_number - lag(endpoint_number,1,0) over(order by endpoint_number) as frequency
    from dba_tab_histograms
    where table_name = '&table'
    and column_name = '&column'
    order by endpoint_number;

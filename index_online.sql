select i.obj#, i.flags, u.name, o.name, o.type#  
  from sys.obj$ o, sys.user$ u, sys.ind_online$ i  
 where (bitand(i.flags, 256) = 256 or bitand(i.flags, 512) = 512)  
   and (not ((i.type# = 9) and bitand(i.flags, 8) = 8))  
   and o.obj# = i.obj#  
   and o.owner# = u.user#;  

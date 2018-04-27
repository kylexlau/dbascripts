col owner for a20;

SELECT 
   /*+ RULE */ 
   tab_owner.name owner, t.name table_name, 
   o1.name || '(' || DECODE(bitand(i1.property, 1), 0, 'N', 1, 'U', '*') || ')' included_index_name , 
   o2.name || '(' || DECODE(bitand(i2.property, 1), 0, 'N', 1, 'U', '*') || ')' including_index_name 
FROM  sys.USER$ tab_owner, sys.OBJ$ t, sys.IND$ i1, sys.OBJ$ o1, sys.IND$ i2, sys.OBJ$ o2 
WHERE i1.bo# = i2.bo# AND i1.obj# <> i2.obj# AND i2.cols >= i1.cols AND i1.cols > 0 AND
   i1.cols = ( SELECT /*+ ORDERED */ COUNT(1) FROM sys.ICOL$ cc1, sys.icol$ cc2 
               WHERE cc2.obj# = i2.obj# AND cc1.obj# = i1.obj# AND 
                     cc2.pos# = cc1.pos# AND cc2.COL# = cc1.COL#) AND 
   i1.obj# = o1.obj# AND i2.obj# = o2.obj# AND t.obj# = i1.bo# AND 
   t.owner# = tab_owner.USER# AND tab_owner.name like '&owner%' 
ORDER BY 1, 2;


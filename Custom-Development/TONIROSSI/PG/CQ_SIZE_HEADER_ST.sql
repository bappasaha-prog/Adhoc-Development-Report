/*><><>< || Custom Development || Object : CQ_SIZE_HEADER_ST || Ticket Id : 420262,420293 || Developer : Dipankar || ><><><*/
  SELECT row_number() OVER()                                UK,
         INVCODE,
         MAX (CASE WHEN SEQ = 1 THEN I_SIZE ELSE NULL END) COL1,
         MAX (CASE WHEN SEQ = 2 THEN I_SIZE ELSE NULL END) COL2,
         MAX (CASE WHEN SEQ = 3 THEN I_SIZE ELSE NULL END) COL3,
         MAX (CASE WHEN SEQ = 4 THEN I_SIZE ELSE NULL END) COL4,
         MAX (CASE WHEN SEQ = 5 THEN I_SIZE ELSE NULL END) COL5,
         MAX (CASE WHEN SEQ = 6 THEN I_SIZE ELSE NULL END) COL6,
         MAX (CASE WHEN SEQ = 7 THEN I_SIZE ELSE NULL END) COL7,
         MAX (CASE WHEN SEQ = 8 THEN I_SIZE ELSE NULL END) COL8
    FROM (SELECT DISTINCT
                 D.INVCODE,
                 TRIM (I.CATEGORY3) I_SIZE,
                 DENSE_RANK ()
                    OVER (PARTITION BY D.INVCODE ORDER BY TRIM (I.CATEGORY3))
                    SEQ
            FROM SALINVDET D INNER JOIN GINVIEW.LV_ITEM I ON D.ICODE = I.CODE
           where(INVCODE in (
							select
													unnest(regexp_matches('@DocumentId@',
													'[^|~|]+',
													'g'))::bigint as col1)
								or coalesce (nullif ('@DocumentId@',
													''),
													'0')::text = 0::text))
GROUP BY INVCODE
/*><><>< || Custom Development || Object : CQ_SIZE_HEADER_SI || Ticket Id : 404247 || Developer : Dipankar || ><><><*/
  SELECT GINVIEW.FNC_UK ()                                UK,
         INVCODE,
         ARTICLE_NAME,
         MAX (CASE WHEN SEQ = 1 THEN I_SIZE ELSE NULL END) COL1,
         MAX (CASE WHEN SEQ = 2 THEN I_SIZE ELSE NULL END) COL2,
         MAX (CASE WHEN SEQ = 3 THEN I_SIZE ELSE NULL END) COL3,
         MAX (CASE WHEN SEQ = 4 THEN I_SIZE ELSE NULL END) COL4,
         MAX (CASE WHEN SEQ = 5 THEN I_SIZE ELSE NULL END) COL5,
         MAX (CASE WHEN SEQ = 6 THEN I_SIZE ELSE NULL END) COL6,
         MAX (CASE WHEN SEQ = 7 THEN I_SIZE ELSE NULL END) COL7,
         MAX (CASE WHEN SEQ = 8 THEN I_SIZE ELSE NULL END) COL8,
         MAX (CASE WHEN SEQ = 9 THEN I_SIZE ELSE NULL END) COL9,
         MAX (CASE WHEN SEQ = 10 THEN I_SIZE ELSE NULL END) COL10,
         MAX (CASE WHEN SEQ = 11 THEN I_SIZE ELSE NULL END) COL11,
         MAX (CASE WHEN SEQ = 12 THEN I_SIZE ELSE NULL END) COL12,
         MAX (CASE WHEN SEQ = 13 THEN I_SIZE ELSE NULL END) COL13,
         MAX (CASE WHEN SEQ = 14 THEN I_SIZE ELSE NULL END) COL14,
         MAX (CASE WHEN SEQ = 15 THEN I_SIZE ELSE NULL END) COL15
    FROM (SELECT DISTINCT
                 D.INVCODE,
                 I.ARTICLE_NAME,
                 TRIM (I.CATEGORY3) I_SIZE,
                 DENSE_RANK ()
                    OVER (PARTITION BY D.INVCODE ORDER BY TRIM (CONCAT (I.INVITEM_UDFSTRING07, I.CATEGORY3)))
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
GROUP BY INVCODE,ARTICLE_NAME
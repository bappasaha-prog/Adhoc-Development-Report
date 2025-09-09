/*><><>< || Custom Development || Object : CQ_SIZE_HEADER_PO || Ticket Id : 404272 || Developer : Dipankar || ><><><*/
  SELECT GINVIEW.FNC_UK ()                                UK,
         ORDCODE,
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
                 D.ORDCODE,
                 I.ARTICLE_NAME,
                 TRIM (I.CATEGORY3) I_SIZE,
                 DENSE_RANK ()
                    OVER (PARTITION BY D.ORDCODE ORDER BY TRIM (CONCAT (I.INVITEM_UDFSTRING07, I.CATEGORY3)))
                    SEQ
            FROM PURORDDET D INNER JOIN GINVIEW.LV_ITEM I ON D.ICODE = I.CODE
           where(ordcode in (
							select
													unnest(regexp_matches('@DocumentId@',
													'[^|~|]+',
													'g'))::bigint as col1)
								or coalesce (nullif ('@DocumentId@',
													''),
													'0')::text = 0::text))
GROUP BY ORDCODE,ARTICLE_NAME
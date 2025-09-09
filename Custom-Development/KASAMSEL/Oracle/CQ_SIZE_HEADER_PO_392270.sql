/* Formatted on 2025-02-11 12:44:06 (QP5 v5.294) */
/*><><>< || Custom Development || Object : CQ_SIZE_HEADER_PO || Ticket Id : 392270 || Developer : Dipankar || ><><><*/
  SELECT GINVIEW.FNC_UK ()                                UK,
         ORDCODE,
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
         MAX (CASE WHEN SEQ = 15 THEN I_SIZE ELSE NULL END) COL15,
         MAX (CASE WHEN SEQ = 16 THEN I_SIZE ELSE NULL END) COL16,
         MAX (CASE WHEN SEQ = 17 THEN I_SIZE ELSE NULL END) COL17,
         MAX (CASE WHEN SEQ = 18 THEN I_SIZE ELSE NULL END) COL18,
         MAX (CASE WHEN SEQ = 19 THEN I_SIZE ELSE NULL END) COL19,
         MAX (CASE WHEN SEQ = 20 THEN I_SIZE ELSE NULL END) COL20
    FROM (SELECT DISTINCT
                 D.ORDCODE,
                 TRIM (I.CATEGORY3) I_SIZE,
                 DENSE_RANK ()
                    OVER (PARTITION BY D.ORDCODE ORDER BY TRIM (I.CATEGORY3))
                    SEQ
            FROM PURORDDET D INNER JOIN GINVIEW.LV_ITEM I ON D.ICODE = I.CODE
           WHERE (   D.ORDCODE IN
                        (    SELECT REGEXP_SUBSTR ('@DocumentId@',
                                                   '[^|~|]+',
                                                   1,
                                                   LEVEL)
                                       COL1
                               FROM DUAL
                         CONNECT BY LEVEL <=
                                       REGEXP_COUNT ('@DocumentId@', '|~|') + 1)
                  OR NVL (REGEXP_COUNT ('@DocumentId@', '|~|') + 1, 0) = 0))
GROUP BY ORDCODE
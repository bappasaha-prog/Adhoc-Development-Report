/* Formatted on 2025-02-10 18:54:09 (QP5 v5.294) */
/*><><>< || Custom Development || Object : CQ_SIZE_STOCK_HEADER || Ticket Id : 388812 || Developer : Dipankar || ><><><*/
  SELECT GINVIEW.FNC_UK()                                   UK,
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
                 I.ARTICLE_NAME,
                 I.CATEGORY3 I_SIZE,
                 DENSE_RANK ()
                 OVER (
                    PARTITION BY I.ARTICLE_NAME
                    ORDER BY
                       TRIM (
                          CONCAT (LPAD (I.INVITEM_UDFSTRING07, 3, 0),
                                  I.CATEGORY3)))
                    SEQ
            FROM GINVIEW.LV_ITEM I)
GROUP BY ARTICLE_NAME
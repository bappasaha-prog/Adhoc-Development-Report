/* Formatted on 2025-06-25 16:29:36 (QP5 v5.294) */
/*|| Custom Development || Object : CQ_GRC_STOCK || Ticket Id :  418626 || Developer : Dipankar ||*/

WITH GRC
     AS (SELECT D.ICODE,
                COALESCE (D.INVBATCH_SERIAL_CODE, 999999999)
                   INVBATCH_SERIAL_CODE,
                M.GRCDT        LAST_DATE,
                M.SCHEME_DOCNO GRCNO,
                ROW_NUMBER ()
                OVER (
                   PARTITION BY ICODE,
                                COALESCE (D.INVBATCH_SERIAL_CODE, 999999999)
                   ORDER BY M.TIME DESC)
                   RN
           FROM INVGRCMAIN M INNER JOIN INVGRCDET D ON M.GRCCODE = D.GRCCODE
          WHERE TRUNC (M.GRCDT) <= TO_DATE ('@ASON@', 'YYYY-MM-DD'))
  SELECT GINVIEW.FNC_UK () UK,
         A.ICODE,
         A.INVBATCH_SERIAL_CODE,
         BS.BATCH_SERIAL_NO,
         A.ADMSITE_CODE,
         S.NAME          SITENAME,
         B.LAST_DATE,
         B.GRCNO,
         SUM (A.STOCK_QTY) STOCK_QTY
    FROM (  SELECT K.ICODE,
                   COALESCE (K.INVBATCH_SERIAL_CODE, 999999999)
                      INVBATCH_SERIAL_CODE,
                   K.ADMSITE_CODE,
                   SUM (K.QTY) STOCK_QTY
              FROM INVSTOCK K
             WHERE     TRUNC (K.ENTDT) <= TO_DATE ('@ASON@', 'YYYY-MM-DD')
                   AND K.LOCCODE <> 2
          GROUP BY K.ICODE,
                   COALESCE (K.INVBATCH_SERIAL_CODE, 999999999),
                   K.ADMSITE_CODE
          UNION ALL
            SELECT D.ICODE,
                   COALESCE (D.INVBATCH_SERIAL_CODE, 999999999)
                      INVBATCH_SERIAL_CODE,
                   M.ADMSITE_CODE,
                   -1 * SUM (D.QTY) STOCK_QTY
              FROM PSITE_POSBILL M
                   INNER JOIN PSITE_POSBILLITEM_PARK D
                      ON M.CODE = D.PSITE_POSBILL_CODE
             WHERE TRUNC (M.BILLDATE) <= TO_DATE ('@ASON@', 'YYYY-MM-DD')
          GROUP BY D.ICODE,
                   COALESCE (D.INVBATCH_SERIAL_CODE, 999999999),
                   M.ADMSITE_CODE) A
         LEFT JOIN (SELECT ICODE,
                           INVBATCH_SERIAL_CODE,
                           LAST_DATE,
                           GRCNO
                      FROM GRC
                     WHERE RN = 1) B
            ON     A.ICODE = B.ICODE
               AND A.INVBATCH_SERIAL_CODE = B.INVBATCH_SERIAL_CODE
         INNER JOIN ADMSITE S ON A.ADMSITE_CODE = S.CODE
         LEFT JOIN INVBATCH_SERIAL BS ON A.INVBATCH_SERIAL_CODE = BS.CODE
GROUP BY A.ICODE,
         A.INVBATCH_SERIAL_CODE,
         BS.BATCH_SERIAL_NO,
         A.ADMSITE_CODE,
         S.NAME,
         B.LAST_DATE,
         B.GRCNO
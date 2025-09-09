/*|| Custom Development || Object : CQ_ALL_SALE_STK_PO || Ticket Id :  427005 || Developer : Dipankar ||*/

SELECT   GINVIEW.FNC_UK ()    UK,
         A.ICODE,
         A.ADMSITE_CODE,
         SUM (A.SALE_QTY)     SALE_QTY,
         SUM (A.STOCK_QTY)    STOCK_QTY,
         SUM (A.TRANSIT_QTY)  TRANSIT_QTY,
         SUM (A.ORDER_QTY)    ORDER_QTY,
         SUM (A.RECEIVE_QTY)  RECEIVE_QTY,
         SUM (A.PENDING_TO_RCV) PENDING_TO_RCV
    FROM (  SELECT ICODE,
                   ADMSITE_CODE,
                   SUM (SALE_QTY) SALE_QTY,
                   0          STOCK_QTY,
                   0          TRANSIT_QTY,
                   0          ORDER_QTY,
                   0          RECEIVE_QTY,
                   0          PENDING_TO_RCV
              FROM (  SELECT D.ICODE,
                             M.ADMSITE_CODE,
                             SUM (COALESCE (D.QTY, 0)) SALE_QTY
                        FROM PSITE_POSBILL M
                             INNER JOIN PSITE_POSBILLITEM D
                                ON M.CODE = D.PSITE_POSBILL_CODE
                             INNER JOIN GINVIEW.LV_ITEM I ON D.ICODE = I.CODE
                       WHERE     TRUNC (M.BILLDATE) BETWEEN TO_DATE ('@DTFR@',
                                                                     'YYYY-MM-DD')
                                                        AND TO_DATE ('@DTTO@',
                                                                     'YYYY-MM-DD')
                             AND (   (    I.DIVISION =
                                             COALESCE ('@Division@', '-1')
                                      AND COALESCE ('@Division@', '-1') <> '-1')
                                  OR (COALESCE ('@Division@', '-1') = '-1'))
                             AND (   (    I.SECTION = COALESCE ('@Section@', '-1')
                                      AND COALESCE ('@Section@', '-1') <> '-1')
                                  OR (COALESCE ('@Section@', '-1') = '-1'))
                             AND (   (    I.DEPARTMENT =
                                             COALESCE ('@Department@', '-1')
                                      AND COALESCE ('@Department@', '-1') <> '-1')
                                  OR (COALESCE ('@Department@', '-1') = '-1'))
                             AND (   I.CATEGORY6 IN
                                        (    SELECT REGEXP_SUBSTR (
                                                       '@#ItemCategory6Multi#@',
                                                       '[^æ]+',
                                                       1,
                                                       LEVEL)
                                                       COL1
                                               FROM DUAL
                                         CONNECT BY LEVEL <=
                                                         REGEXP_COUNT (
                                                            '@#ItemCategory6Multi#@',
                                                            'æ')
                                                       + 1)
                                  OR NVL (
                                          REGEXP_COUNT ('@#ItemCategory6Multi#@',
                                                        'æ')
                                        + 1,
                                        0) = 0)
                             AND (   I.CATEGORY2 IN
                                        (    SELECT REGEXP_SUBSTR (
                                                       '@#ItemCategory2Multi#@',
                                                       '[^æ]+',
                                                       1,
                                                       LEVEL)
                                                       COL1
                                               FROM DUAL
                                         CONNECT BY LEVEL <=
                                                         REGEXP_COUNT (
                                                            '@#ItemCategory2Multi#@',
                                                            'æ')
                                                       + 1)
                                  OR NVL (
                                          REGEXP_COUNT ('@#ItemCategory2Multi#@',
                                                        'æ')
                                        + 1,
                                        0) = 0)
                    GROUP BY D.ICODE, M.ADMSITE_CODE
                    UNION ALL
                      SELECT D.ICODE,
                             M.ADMSITE_CODE_OWNER   ADMSITE_CODE,
                             SUM (COALESCE (D.INVQTY, 0)) SALE_QTY
                        FROM SALINVMAIN M
                             INNER JOIN SALINVDET D ON M.INVCODE = D.INVCODE
                             INNER JOIN GINVIEW.LV_ITEM I ON D.ICODE = I.CODE
                       WHERE     M.SALETYPE = 'O'
                             AND TRUNC (M.INVDT) BETWEEN TO_DATE ('@DTFR@',
                                                                  'YYYY-MM-DD')
                                                     AND TO_DATE ('@DTTO@',
                                                                  'YYYY-MM-DD')
                             AND (   (    I.DIVISION =
                                             COALESCE ('@Division@', '-1')
                                      AND COALESCE ('@Division@', '-1') <> '-1')
                                  OR (COALESCE ('@Division@', '-1') = '-1'))
                             AND (   (    I.SECTION = COALESCE ('@Section@', '-1')
                                      AND COALESCE ('@Section@', '-1') <> '-1')
                                  OR (COALESCE ('@Section@', '-1') = '-1'))
                             AND (   (    I.DEPARTMENT =
                                             COALESCE ('@Department@', '-1')
                                      AND COALESCE ('@Department@', '-1') <> '-1')
                                  OR (COALESCE ('@Department@', '-1') = '-1'))
                             AND (   I.CATEGORY6 IN
                                        (    SELECT REGEXP_SUBSTR (
                                                       '@#ItemCategory6Multi#@',
                                                       '[^æ]+',
                                                       1,
                                                       LEVEL)
                                                       COL1
                                               FROM DUAL
                                         CONNECT BY LEVEL <=
                                                         REGEXP_COUNT (
                                                            '@#ItemCategory6Multi#@',
                                                            'æ')
                                                       + 1)
                                  OR NVL (
                                          REGEXP_COUNT ('@#ItemCategory6Multi#@',
                                                        'æ')
                                        + 1,
                                        0) = 0)
                             AND (   I.CATEGORY2 IN
                                        (    SELECT REGEXP_SUBSTR (
                                                       '@#ItemCategory2Multi#@',
                                                       '[^æ]+',
                                                       1,
                                                       LEVEL)
                                                       COL1
                                               FROM DUAL
                                         CONNECT BY LEVEL <=
                                                         REGEXP_COUNT (
                                                            '@#ItemCategory2Multi#@',
                                                            'æ')
                                                       + 1)
                                  OR NVL (
                                          REGEXP_COUNT ('@#ItemCategory2Multi#@',
                                                        'æ')
                                        + 1,
                                        0) = 0)
                    GROUP BY D.ICODE, M.ADMSITE_CODE_OWNER)
          GROUP BY ICODE, ADMSITE_CODE
          UNION ALL
            SELECT ICODE,
                   ADMSITE_CODE,
                   0                                   SALE_QTY,
                   SUM (STOCK_QTY) - SUM (UNSETTLESALEQTY) STOCK_QTY,
                   SUM (TRANSIT_QTY)                   TRANSIT_QTY,
                   0                                   ORDER_QTY,
                   0                                   RECEIVE_QTY,
                   0                                   PENDING_TO_RCV
              FROM (  SELECT M.ADMSITE_CODE,
                             M.ICODE,
                             SUM (
                                CASE
                                   WHEN L.LOCTYPE <> 'T' THEN COALESCE (M.QTY, 0)
                                END)
                                STOCK_QTY,
                             SUM (
                                CASE
                                   WHEN L.LOCTYPE = 'T' THEN COALESCE (M.QTY, 0)
                                END)
                                TRANSIT_QTY,
                             0 UNSETTLESALEQTY
                        FROM INVSTOCK_ONHAND M
                             LEFT JOIN INVLOC L ON M.LOCCODE = L.LOCCODE
                             INNER JOIN GINVIEW.LV_ITEM I ON M.ICODE = I.CODE
                       WHERE     (   (    I.DIVISION =
                                             COALESCE ('@Division@', '-1')
                                      AND COALESCE ('@Division@', '-1') <> '-1')
                                  OR (COALESCE ('@Division@', '-1') = '-1'))
                             AND (   (    I.SECTION = COALESCE ('@Section@', '-1')
                                      AND COALESCE ('@Section@', '-1') <> '-1')
                                  OR (COALESCE ('@Section@', '-1') = '-1'))
                             AND (   (    I.DEPARTMENT =
                                             COALESCE ('@Department@', '-1')
                                      AND COALESCE ('@Department@', '-1') <> '-1')
                                  OR (COALESCE ('@Department@', '-1') = '-1'))
                             AND (   I.CATEGORY6 IN
                                        (    SELECT REGEXP_SUBSTR (
                                                       '@#ItemCategory6Multi#@',
                                                       '[^æ]+',
                                                       1,
                                                       LEVEL)
                                                       COL1
                                               FROM DUAL
                                         CONNECT BY LEVEL <=
                                                         REGEXP_COUNT (
                                                            '@#ItemCategory6Multi#@',
                                                            'æ')
                                                       + 1)
                                  OR NVL (
                                          REGEXP_COUNT ('@#ItemCategory6Multi#@',
                                                        'æ')
                                        + 1,
                                        0) = 0)
                             AND (   I.CATEGORY2 IN
                                        (    SELECT REGEXP_SUBSTR (
                                                       '@#ItemCategory2Multi#@',
                                                       '[^æ]+',
                                                       1,
                                                       LEVEL)
                                                       COL1
                                               FROM DUAL
                                         CONNECT BY LEVEL <=
                                                         REGEXP_COUNT (
                                                            '@#ItemCategory2Multi#@',
                                                            'æ')
                                                       + 1)
                                  OR NVL (
                                          REGEXP_COUNT ('@#ItemCategory2Multi#@',
                                                        'æ')
                                        + 1,
                                        0) = 0)
                    GROUP BY M.ADMSITE_CODE, M.ICODE
                    UNION ALL
                      SELECT M.ADMSITE_CODE,
                             D.ICODE,
                             0                   STOCK_QTY,
                             0                   TRANSIT_QTY,
                             SUM (COALESCE (D.QTY, 0)) UNSETTLESALEQTY
                        FROM PSITE_POSBILL_PARK M
                             INNER JOIN PSITE_POSBILLITEM_PARK D
                                ON M.CODE = D.PSITE_POSBILL_CODE
                             INNER JOIN GINVIEW.LV_ITEM I ON D.ICODE = I.CODE
                       WHERE     (   (    I.DIVISION =
                                             COALESCE ('@Division@', '-1')
                                      AND COALESCE ('@Division@', '-1') <> '-1')
                                  OR (COALESCE ('@Division@', '-1') = '-1'))
                             AND (   (    I.SECTION = COALESCE ('@Section@', '-1')
                                      AND COALESCE ('@Section@', '-1') <> '-1')
                                  OR (COALESCE ('@Section@', '-1') = '-1'))
                             AND (   (    I.DEPARTMENT =
                                             COALESCE ('@Department@', '-1')
                                      AND COALESCE ('@Department@', '-1') <> '-1')
                                  OR (COALESCE ('@Department@', '-1') = '-1'))
                             AND (   I.CATEGORY6 IN
                                        (    SELECT REGEXP_SUBSTR (
                                                       '@#ItemCategory6Multi#@',
                                                       '[^æ]+',
                                                       1,
                                                       LEVEL)
                                                       COL1
                                               FROM DUAL
                                         CONNECT BY LEVEL <=
                                                         REGEXP_COUNT (
                                                            '@#ItemCategory6Multi#@',
                                                            'æ')
                                                       + 1)
                                  OR NVL (
                                          REGEXP_COUNT ('@#ItemCategory6Multi#@',
                                                        'æ')
                                        + 1,
                                        0) = 0)
                             AND (   I.CATEGORY2 IN
                                        (    SELECT REGEXP_SUBSTR (
                                                       '@#ItemCategory2Multi#@',
                                                       '[^æ]+',
                                                       1,
                                                       LEVEL)
                                                       COL1
                                               FROM DUAL
                                         CONNECT BY LEVEL <=
                                                         REGEXP_COUNT (
                                                            '@#ItemCategory2Multi#@',
                                                            'æ')
                                                       + 1)
                                  OR NVL (
                                          REGEXP_COUNT ('@#ItemCategory2Multi#@',
                                                        'æ')
                                        + 1,
                                        0) = 0)
                    GROUP BY M.ADMSITE_CODE, D.ICODE)
          GROUP BY ICODE, ADMSITE_CODE
          UNION ALL
            SELECT D.ICODE,
                   M.ADMSITE_CODE,
                   0                        SALE_QTY,
                   0                        STOCK_QTY,
                   0                        TRANSIT_QTY,
                   SUM (COALESCE (D.ORDQTY, 0)) ORDER_QTY,
                   SUM (COALESCE (D.RCQTY, 0)) RECEIVE_QTY,
                   SUM (
                        COALESCE (D.ORDQTY, 0)
                      - COALESCE (D.RCQTY, 0)
                      - COALESCE (D.CNLQTY, 0))
                      PENDING_TO_RCV
              FROM PURORDMAIN M
                   INNER JOIN PURORDDET D ON M.ORDCODE = D.ORDCODE
                   INNER JOIN GINVIEW.LV_ITEM I ON D.ICODE = I.CODE
             WHERE     TRUNC (M.ORDDT) BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                                           AND TO_DATE ('@DTTO@', 'YYYY-MM-DD')
                   AND (   (    I.DIVISION = COALESCE ('@Division@', '-1')
                            AND COALESCE ('@Division@', '-1') <> '-1')
                        OR (COALESCE ('@Division@', '-1') = '-1'))
                   AND (   (    I.SECTION = COALESCE ('@Section@', '-1')
                            AND COALESCE ('@Section@', '-1') <> '-1')
                        OR (COALESCE ('@Section@', '-1') = '-1'))
                   AND (   (    I.DEPARTMENT = COALESCE ('@Department@', '-1')
                            AND COALESCE ('@Department@', '-1') <> '-1')
                        OR (COALESCE ('@Department@', '-1') = '-1'))
                   AND (   I.CATEGORY6 IN
                              (    SELECT REGEXP_SUBSTR ('@#ItemCategory6Multi#@',
                                                         '[^æ]+',
                                                         1,
                                                         LEVEL)
                                             COL1
                                     FROM DUAL
                               CONNECT BY LEVEL <=
                                               REGEXP_COUNT (
                                                  '@#ItemCategory6Multi#@',
                                                  'æ')
                                             + 1)
                        OR NVL (
                              REGEXP_COUNT ('@#ItemCategory6Multi#@', 'æ') + 1,
                              0) = 0)
                   AND (   I.CATEGORY2 IN
                              (    SELECT REGEXP_SUBSTR ('@#ItemCategory2Multi#@',
                                                         '[^æ]+',
                                                         1,
                                                         LEVEL)
                                             COL1
                                     FROM DUAL
                               CONNECT BY LEVEL <=
                                               REGEXP_COUNT (
                                                  '@#ItemCategory2Multi#@',
                                                  'æ')
                                             + 1)
                        OR NVL (
                              REGEXP_COUNT ('@#ItemCategory2Multi#@', 'æ') + 1,
                              0) = 0)
          GROUP BY D.ICODE, M.ADMSITE_CODE) A
GROUP BY A.ICODE, A.ADMSITE_CODE
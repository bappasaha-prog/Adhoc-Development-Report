/* Formatted on 6-20-2025 12:24:03 PM (QP5 v5.294) */
/*|| Custom Development || Object : CQ_SALES || Ticket Id : 418317 || Developer : Dipankar ||*/

  SELECT GINVIEW.FNC_UK () UK,
         1               ABCD,
         I.DEPARTMENT,
         I.CATEGORY4     SIZE_VALUE,
         SUM (A.STOCK_QTY) STOCK_QTY,
         SUM (B.MONTH1)  MONTH1,
         SUM (B.MONTH2)  MONTH2,
         SUM (B.MONTH3)  MONTH3,
         SUM (B.MONTH4)  MONTH4,
         SUM (B.MONTH5)  MONTH5,
         SUM (B.MONTH6)  MONTH6,
         SUM (B.MONTH7)  MONTH7,
         SUM (B.MONTH8)  MONTH8,
         SUM (B.MONTH9)  MONTH9,
         SUM (B.MONTH10) MONTH10,
         SUM (B.MONTH11) MONTH11,
         SUM (B.MONTH12) MONTH12,
         SUM (B.MONTH13) MONTH13,
         SUM (B.TOTAL_QTY) TOTAL_QTY
    FROM (  SELECT F.ICODE, SUM (F.STOCK_QTY) STOCK_QTY
              FROM (  SELECT K.ICODE, SUM (K.QTY) STOCK_QTY
                        FROM INVSTOCK_ONHAND K
                             INNER JOIN GINVIEW.LV_ITEM I ON K.ICODE = I.CODE
                             INNER JOIN ADMSITE S ON K.ADMSITE_CODE = S.CODE
                       WHERE     K.LOCCODE <> 2
                             AND S.SITETYPE LIKE 'MS%'
                             AND (   (    I.DIVISION =
                                             COALESCE ('@Division@', '-1')
                                      AND COALESCE ('@Division@', '-1') <> '-1')
                                  OR (COALESCE ('@Division@', '-1') = '-1'))
                             AND (   (    K.ADMSITE_CODE =
                                             COALESCE ('@MSSiteTypeSiteName@',
                                                       '-1')
                                      AND COALESCE ('@MSSiteTypeSiteName@', '-1') <>
                                             '-1')
                                  OR (COALESCE ('@MSSiteTypeSiteName@', '-1') =
                                         '-1'))
                    GROUP BY K.ICODE
                    UNION ALL
                      SELECT D.ICODE, -1 * SUM (D.QTY) STOCK_QTY
                        FROM PSITE_POSBILL_PARK M
                             INNER JOIN PSITE_POSBILLITEM_PARK D
                                ON M.CODE = D.PSITE_POSBILL_CODE
                             INNER JOIN GINVIEW.LV_ITEM I ON D.ICODE = I.CODE
                       WHERE     (   (    I.DIVISION =
                                             COALESCE ('@Division@', '-1')
                                      AND COALESCE ('@Division@', '-1') <> '-1')
                                  OR (COALESCE ('@Division@', '-1') = '-1'))
                             AND (   (    M.ADMSITE_CODE =
                                             COALESCE ('@MSSiteTypeSiteName@',
                                                       '-1')
                                      AND COALESCE ('@MSSiteTypeSiteName@', '-1') <>
                                             '-1')
                                  OR (COALESCE ('@MSSiteTypeSiteName@', '-1') =
                                         '-1'))
                    GROUP BY D.ICODE) F
          GROUP BY F.ICODE) A
         LEFT JOIN
         (  SELECT ICODE,
                   SUM (QTY) TOTAL_QTY,
                   SUM (CASE WHEN BILL_MONTH = MONTH_NAME1 THEN QTY ELSE 0 END)
                      MONTH1,
                   SUM (CASE WHEN BILL_MONTH = MONTH_NAME2 THEN QTY ELSE 0 END)
                      MONTH2,
                   SUM (CASE WHEN BILL_MONTH = MONTH_NAME3 THEN QTY ELSE 0 END)
                      MONTH3,
                   SUM (CASE WHEN BILL_MONTH = MONTH_NAME4 THEN QTY ELSE 0 END)
                      MONTH4,
                   SUM (CASE WHEN BILL_MONTH = MONTH_NAME5 THEN QTY ELSE 0 END)
                      MONTH5,
                   SUM (CASE WHEN BILL_MONTH = MONTH_NAME6 THEN QTY ELSE 0 END)
                      MONTH6,
                   SUM (CASE WHEN BILL_MONTH = MONTH_NAME7 THEN QTY ELSE 0 END)
                      MONTH7,
                   SUM (CASE WHEN BILL_MONTH = MONTH_NAME8 THEN QTY ELSE 0 END)
                      MONTH8,
                   SUM (CASE WHEN BILL_MONTH = MONTH_NAME9 THEN QTY ELSE 0 END)
                      MONTH9,
                   SUM (CASE WHEN BILL_MONTH = MONTH_NAME10 THEN QTY ELSE 0 END)
                      MONTH10,
                   SUM (CASE WHEN BILL_MONTH = MONTH_NAME11 THEN QTY ELSE 0 END)
                      MONTH11,
                   SUM (CASE WHEN BILL_MONTH = MONTH_NAME12 THEN QTY ELSE 0 END)
                      MONTH12,
                   SUM (CASE WHEN BILL_MONTH = MONTH_NAME13 THEN QTY ELSE 0 END)
                      MONTH13
              FROM (  SELECT 1     DIP,
                             F.ICODE,
                             SUM (F.QTY) QTY,
                             F.BILL_MONTH
                        FROM (  SELECT D.ICODE,
                                       TO_CHAR (M.BILLDATE, 'MON-YY') BILL_MONTH,
                                       SUM (D.QTY)            QTY
                                  FROM PSITE_POSBILL M
                                       INNER JOIN PSITE_POSBILLITEM D
                                          ON M.CODE = D.PSITE_POSBILL_CODE
                                       INNER JOIN GINVIEW.LV_ITEM I
                                          ON D.ICODE = I.CODE
                                 WHERE     TRUNC (M.BILLDATE) BETWEEN ADD_MONTHS (
                                                                         TO_DATE (
                                                                            '@ASON@',
                                                                            'YYYY-MM-DD'),
                                                                         -12)
                                                                  AND TO_DATE (
                                                                         '@ASON@',
                                                                         'YYYY-MM-DD')
                                       AND (   (    I.DIVISION =
                                                       COALESCE ('@Division@', '-1')
                                                AND COALESCE ('@Division@', '-1') <>
                                                       '-1')
                                            OR (COALESCE ('@Division@', '-1') = '-1'))
                                       AND (   (    M.ADMSITE_CODE =
                                                       COALESCE (
                                                          '@MSSiteTypeSiteName@',
                                                          '-1')
                                                AND COALESCE ('@MSSiteTypeSiteName@',
                                                              '-1') <> '-1')
                                            OR (COALESCE ('@MSSiteTypeSiteName@',
                                                          '-1') = '-1'))
                              GROUP BY D.ICODE, TO_CHAR (M.BILLDATE, 'MON-YY')) F
                    GROUP BY F.ICODE, F.BILL_MONTH) A
                   INNER JOIN
                   (SELECT 1 DIP,
                           MAX (CASE WHEN SEQ = 1 THEN MONTH_NAME ELSE NULL END)
                              MONTH_NAME1,
                           MAX (CASE WHEN SEQ = 2 THEN MONTH_NAME ELSE NULL END)
                              MONTH_NAME2,
                           MAX (CASE WHEN SEQ = 3 THEN MONTH_NAME ELSE NULL END)
                              MONTH_NAME3,
                           MAX (CASE WHEN SEQ = 4 THEN MONTH_NAME ELSE NULL END)
                              MONTH_NAME4,
                           MAX (CASE WHEN SEQ = 5 THEN MONTH_NAME ELSE NULL END)
                              MONTH_NAME5,
                           MAX (CASE WHEN SEQ = 6 THEN MONTH_NAME ELSE NULL END)
                              MONTH_NAME6,
                           MAX (CASE WHEN SEQ = 7 THEN MONTH_NAME ELSE NULL END)
                              MONTH_NAME7,
                           MAX (CASE WHEN SEQ = 8 THEN MONTH_NAME ELSE NULL END)
                              MONTH_NAME8,
                           MAX (CASE WHEN SEQ = 9 THEN MONTH_NAME ELSE NULL END)
                              MONTH_NAME9,
                           MAX (CASE WHEN SEQ = 10 THEN MONTH_NAME ELSE NULL END)
                              MONTH_NAME10,
                           MAX (CASE WHEN SEQ = 11 THEN MONTH_NAME ELSE NULL END)
                              MONTH_NAME11,
                           MAX (CASE WHEN SEQ = 12 THEN MONTH_NAME ELSE NULL END)
                              MONTH_NAME12,
                           MAX (CASE WHEN SEQ = 13 THEN MONTH_NAME ELSE NULL END)
                              MONTH_NAME13
                      FROM (  SELECT ROW_NUMBER () OVER (ORDER BY MCODE ASC) SEQ,
                                     MONTH_NAME
                                FROM ADMMONTH
                               WHERE DTFR BETWEEN (SELECT DTFR
                                                     FROM ADMMONTH
                                                    WHERE ADD_MONTHS (
                                                             TO_DATE ('@ASON@',
                                                                      'YYYY-MM-DD'),
                                                             -12) BETWEEN DTFR
                                                                      AND DTTO)
                                              AND (SELECT DTFR
                                                     FROM ADMMONTH
                                                    WHERE TO_DATE ('@ASON@',
                                                                   'YYYY-MM-DD') BETWEEN DTFR
                                                                                     AND DTTO)
                            ORDER BY MCODE ASC)) M
                      ON A.DIP = M.DIP
          GROUP BY ICODE) B
            ON A.ICODE = B.ICODE
         INNER JOIN GINVIEW.LV_ITEM I ON A.ICODE = I.CODE
GROUP BY I.DEPARTMENT, I.CATEGORY4
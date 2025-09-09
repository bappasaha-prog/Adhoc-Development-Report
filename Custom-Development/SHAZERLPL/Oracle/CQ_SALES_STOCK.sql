/* Formatted on 2025-04-18 13:08:59 (QP5 v5.294) */
/*><><>< || Custom Development || Object : CQ_SALES_STOCK || Ticket Id : 397755,403895 || Developer : Dipankar || ><><><*/

SELECT GINVIEW.FNC_UK () UK,
       1,
       A.ICODE,
       A.NO_OF_MON,
       A.MONTH1,
       A.MONTH2,
       A.MONTH3,
       A.MONTH4,
       A.MONTH5,
       A.MONTH6,
       A.MONTH7,
       A.MONTH8,
       A.MONTH9,
       A.MONTH10,
       A.MONTH11,
       A.MONTH12,
       A.MONTH13,
       A.TOTAL_QTY,
       B.TRANSIT_QTY,
       CASE
          WHEN A.NO_OF_MON = 0 THEN 0
          ELSE ROUND (A.TOTAL_QTY / A.NO_OF_MON)
       END
          AVG_SALES,
       CASE
          WHEN D.STOCK_QTY = 0 THEN 0
          ELSE ROUND ( (A.TOTAL_QTY / D.STOCK_QTY) * 100)
       END
          SALES_THRU,
       C.GOOD_BIN,
       C.BAD_BIN,
       D.STOCK_QTY,
       E.COLABA_STOCK_QTY,
       E.GG_STOCK_QTY,
       E.HUGHES_STOCK_QTY,
       E.OBEROI_STOCK_QTY,
       E.T2_STOCK_QTY,
       E.TAJ_STOCK_QTY,
       E.BHIWANDI_STOCK_QTY
  FROM (  SELECT ICODE,
                 COUNT (DISTINCT A.BILL_MONTH) NO_OF_MON,
                 SUM (QTY)                   TOTAL_QTY,
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
            FROM (  SELECT 1,
                           F.ICODE,
                           SUM (F.QTY) QTY,
                           F.BILL_MONTH
                      FROM (  SELECT D.ICODE,
                                     TO_CHAR (M.INVDT, 'MON-YY') BILL_MONTH,
                                     SUM (D.INVQTY)        QTY
                                FROM SALINVMAIN M
                                     INNER JOIN SALINVDET D
                                        ON M.INVCODE = D.INVCODE
                               WHERE     M.SALETYPE = 'O'
                                     AND TRUNC (M.INVDT) BETWEEN ADD_MONTHS (
                                                                    TO_DATE (
                                                                       '@ASON@',
                                                                       'YYYY-MM-DD'),
                                                                    -12)
                                                             AND TO_DATE (
                                                                    '@ASON@',
                                                                    'YYYY-MM-DD')
                            GROUP BY D.ICODE, TO_CHAR (M.INVDT, 'MON-YY')
                            UNION ALL
                              SELECT D.ICODE,
                                     TO_CHAR (M.CSDATE, 'MON-YY') BILL_MONTH,
                                     SUM (D.QTY)            QTY
                                FROM SALCSMAIN M
                                     INNER JOIN SALCSDET D ON M.CSCODE = D.CSCODE
                               WHERE TRUNC (M.CSDATE) BETWEEN ADD_MONTHS (
                                                                 TO_DATE (
                                                                    '@ASON@',
                                                                    'YYYY-MM-DD'),
                                                                 -12)
                                                          AND TO_DATE (
                                                                 '@ASON@',
                                                                 'YYYY-MM-DD')
                            GROUP BY D.ICODE, TO_CHAR (M.CSDATE, 'MON-YY')
                            UNION ALL
                              SELECT D.ICODE,
                                     TO_CHAR (M.SSDATE, 'MON-YY') BILL_MONTH,
                                     SUM (D.QTY)            QTY
                                FROM SALSSMAIN M
                                     INNER JOIN SALSSDET D ON M.SSCODE = D.SSCODE
                               WHERE TRUNC (M.SSDATE) BETWEEN ADD_MONTHS (
                                                                 TO_DATE (
                                                                    '@ASON@',
                                                                    'YYYY-MM-DD'),
                                                                 -12)
                                                          AND TO_DATE (
                                                                 '@ASON@',
                                                                 'YYYY-MM-DD')
                            GROUP BY D.ICODE, TO_CHAR (M.SSDATE, 'MON-YY')) F
                  GROUP BY F.ICODE, F.BILL_MONTH) A
                 INNER JOIN
                 (SELECT 1,
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
                    ON A."1" = M."1"
        GROUP BY ICODE) A
       LEFT JOIN (  SELECT K.ICODE, SUM (K.QTY) TRANSIT_QTY
                      FROM INVSTOCK_ONHAND K
                     WHERE K.LOCCODE = 2
                  GROUP BY K.ICODE) B
          ON A.ICODE = B.ICODE
       LEFT JOIN
       (  SELECT H.ICODE,
                 SUM (
                    CASE
                       WHEN B.UDFSTRING01 = 'Good' THEN H.STOCK_ON_HAND
                       ELSE 0
                    END)
                    GOOD_BIN,
                 SUM (
                    CASE
                       WHEN B.UDFSTRING01 = 'Bad' THEN H.STOCK_ON_HAND
                       ELSE 0
                    END)
                    BAD_BIN
            FROM INVBINSTOCK_ONHAND H
                 INNER JOIN INVBIN B ON INVBIN_CODE = B.CODE
        GROUP BY H.ICODE) C
          ON A.ICODE = C.ICODE
       LEFT JOIN (  SELECT K.ICODE, SUM (K.QTY) STOCK_QTY
                      FROM INVSTOCK_ONHAND K
                     WHERE K.LOCCODE <> 2
                  GROUP BY K.ICODE) D
          ON A.ICODE = D.ICODE
       LEFT JOIN
       (  SELECT K.ICODE,
                 SUM (CASE WHEN K.ADMSITE_CODE = 3 THEN K.QTY ELSE 0 END)
                    COLABA_STOCK_QTY,
                 SUM (CASE WHEN K.ADMSITE_CODE = 6 THEN K.QTY ELSE 0 END)
                    GG_STOCK_QTY,
                 SUM (CASE WHEN K.ADMSITE_CODE = 5 THEN K.QTY ELSE 0 END)
                    HUGHES_STOCK_QTY,
                 SUM (CASE WHEN K.ADMSITE_CODE = 4 THEN K.QTY ELSE 0 END)
                    OBEROI_STOCK_QTY,
                 SUM (CASE WHEN K.ADMSITE_CODE = 8 THEN K.QTY ELSE 0 END)
                    T2_STOCK_QTY,
                 SUM (CASE WHEN K.ADMSITE_CODE = 7 THEN K.QTY ELSE 0 END)
                    TAJ_STOCK_QTY,
                 SUM (CASE WHEN K.ADMSITE_CODE = 1 THEN K.QTY ELSE 0 END)
                    BHIWANDI_STOCK_QTY
            FROM INVSTOCK_ONHAND K
           WHERE     K.LOCCODE <> 2
                 AND K.ADMSITE_CODE IN (3,
                                        6,
                                        5,
                                        4,
                                        8,
                                        7,
                                        1)
        GROUP BY K.ICODE) E
          ON A.ICODE = E.ICODE
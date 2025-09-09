/* Formatted on 2025-06-06 12:50:47 (QP5 v5.294) */
/*|| Custom Development || Object : CQ_POS_PERIODIC_GROWTH || Ticket Id :  416020 || Developer : Dipankar ||*/

  SELECT GINVIEW.FNC_UK () UK,
         I.DIVISION,
         M.ADMSITE_CODE,
         COUNT (
            DISTINCT CASE
                        WHEN TRUNC (M.BILLDATE) BETWEEN TO_DATE (
                                                           '@Period1DateFrom@',
                                                           'yyyy-mm-dd')
                                                    AND TO_DATE (
                                                           '@Period1DateTo@',
                                                           'yyyy-mm-dd')
                        THEN
                           M.CODE
                     END)
            AS PERIOD1_NOB,
         SUM (
            CASE
               WHEN TRUNC (M.BILLDATE) BETWEEN TO_DATE ('@Period1DateFrom@',
                                                        'yyyy-mm-dd')
                                           AND TO_DATE ('@Period1DateTo@',
                                                        'yyyy-mm-dd')
               THEN
                  COALESCE (D.QTY, 0)
               ELSE
                  0
            END)
            AS PERIOD1_QTY,
         SUM (
            CASE
               WHEN TRUNC (M.BILLDATE) BETWEEN TO_DATE ('@Period1DateFrom@',
                                                        'yyyy-mm-dd')
                                           AND TO_DATE ('@Period1DateTo@',
                                                        'yyyy-mm-dd')
               THEN
                  COALESCE (D.NETAMT, 0)
               ELSE
                  0
            END)
            AS PERIOD1_SALEAMT,
         SUM (
            CASE
               WHEN TRUNC (M.BILLDATE) BETWEEN TO_DATE ('@Period1DateFrom@',
                                                        'yyyy-mm-dd')
                                           AND TO_DATE ('@Period1DateTo@',
                                                        'yyyy-mm-dd')
               THEN
                  COALESCE (D.MRPAMT, 0)
               ELSE
                  0
            END)
            AS PERIOD1_MRPAMT,
         SUM (
            CASE
               WHEN TRUNC (M.BILLDATE) BETWEEN TO_DATE ('@Period1DateFrom@',
                                                        'yyyy-mm-dd')
                                           AND TO_DATE ('@Period1DateTo@',
                                                        'yyyy-mm-dd')
               THEN
                  COALESCE (I.LAST_INWARD_RATE, 0)
               ELSE
                  0
            END)
            AS PERIOD1_COSTAMT,
         COUNT (
            DISTINCT CASE
                        WHEN TRUNC (M.BILLDATE) BETWEEN TO_DATE (
                                                           '@Period2DateFrom@',
                                                           'yyyy-mm-dd')
                                                    AND TO_DATE (
                                                           '@Period2DateTo@',
                                                           'yyyy-mm-dd')
                        THEN
                           M.CODE
                     END)
            AS PERIOD2_NOB,
         SUM (
            CASE
               WHEN TRUNC (M.BILLDATE) BETWEEN TO_DATE ('@Period2DateFrom@',
                                                        'yyyy-mm-dd')
                                           AND TO_DATE ('@Period2DateTo@',
                                                        'yyyy-mm-dd')
               THEN
                  COALESCE (D.QTY, 0)
               ELSE
                  0
            END)
            AS PERIOD2_QTY,
         SUM (
            CASE
               WHEN TRUNC (M.BILLDATE) BETWEEN TO_DATE ('@Period2DateFrom@',
                                                        'yyyy-mm-dd')
                                           AND TO_DATE ('@Period2DateTo@',
                                                        'yyyy-mm-dd')
               THEN
                  COALESCE (D.NETAMT, 0)
               ELSE
                  0
            END)
            AS PERIOD2_SALEAMT,
         SUM (
            CASE
               WHEN TRUNC (M.BILLDATE) BETWEEN TO_DATE ('@Period2DateFrom@',
                                                        'yyyy-mm-dd')
                                           AND TO_DATE ('@Period2DateTo@',
                                                        'yyyy-mm-dd')
               THEN
                  COALESCE (D.MRPAMT, 0)
               ELSE
                  0
            END)
            AS PERIOD2_MRPAMT,
         SUM (
            CASE
               WHEN TRUNC (M.BILLDATE) BETWEEN TO_DATE ('@Period2DateFrom@',
                                                        'yyyy-mm-dd')
                                           AND TO_DATE ('@Period2DateTo@',
                                                        'yyyy-mm-dd')
               THEN
                  COALESCE (I.LAST_INWARD_RATE, 0)
               ELSE
                  0
            END)
            AS PERIOD2_COSTAMT,
         SUM (
            CASE
               WHEN TRUNC (M.BILLDATE) =
                       TO_DATE ('@Period2DateTo@', 'yyyy-mm-dd')
               THEN
                  COALESCE (D.QTY, 0)
               ELSE
                  0
            END)
            AS TODATE_QTY,
         SUM (
            CASE
               WHEN TRUNC (M.BILLDATE) =
                       TO_DATE ('@Period2DateTo@', 'yyyy-mm-dd')
               THEN
                  COALESCE (D.NETAMT, 0)
               ELSE
                  0
            END)
            AS TODATE_SALEAMT
    FROM PSITE_POSBILL M
         INNER JOIN PSITE_POSBILLITEM D ON M.CODE = D.PSITE_POSBILL_CODE
         INNER JOIN GINVIEW.LV_ITEM I ON D.ICODE = I.CODE
   WHERE (   (TRUNC (M.BILLDATE) BETWEEN TO_DATE ('@Period1DateFrom@',
                                                  'yyyy-mm-dd')
                                     AND TO_DATE ('@Period1DateTo@',
                                                  'yyyy-mm-dd'))
          OR (TRUNC (M.BILLDATE) BETWEEN TO_DATE ('@Period2DateFrom@',
                                                  'yyyy-mm-dd')
                                     AND TO_DATE ('@Period2DateTo@',
                                                  'yyyy-mm-dd')))
GROUP BY I.DIVISION, M.ADMSITE_CODE
/* Formatted on 2025/05/14 13:48:50 (QP5 v5.294) */
/*
Purpose              Object                        ID                            Developer          
Custom Development   CQ_DIVISION_SALE_GROWTH       382055,409976,410526          Dipankar
*/

  SELECT GINVIEW.FNC_UK () UK,
         M.ADMSITE_CODE,
         I.DIVISION,
         SUM (
            CASE
               WHEN TRUNC (M.BILLDATE) BETWEEN TO_DATE ('@Period1DateFrom@',
                                                        'yyyy-mm-dd')
                                           AND TO_DATE ('@Period1DateTo@',
                                                        'yyyy-mm-dd')
               THEN
                  CASE
                     WHEN PD.NAME = 'DISCOUNT'
                     THEN
                        COALESCE (D.NETAMT, 0) + COALESCE (D.MDISCOUNTAMT, 0)
                     ELSE
                        COALESCE (D.NETAMT, 0)
                  END
            END)
            PERIOD_1_AMT,
         SUM (
            CASE
               WHEN TRUNC (M.BILLDATE) BETWEEN TO_DATE ('@Period1DateFrom@',
                                                        'yyyy-mm-dd')
                                           AND TO_DATE ('@Period1DateTo@',
                                                        'yyyy-mm-dd')
               THEN
                  I.STANDARD_RATE * D.QTY
            END)
            PERIOD_1_STANDARD_RATE,
         SUM (
            CASE
               WHEN TRUNC (M.BILLDATE) BETWEEN TO_DATE ('@Period1DateFrom@',
                                                        'yyyy-mm-dd')
                                           AND TO_DATE ('@Period1DateTo@',
                                                        'yyyy-mm-dd')
               THEN
                  D.QTY
            END)
            PERIOD_1_QTY,
         SUM (
            CASE
               WHEN TRUNC (M.BILLDATE) BETWEEN TO_DATE ('@Period2DateFrom@',
                                                        'yyyy-mm-dd')
                                           AND TO_DATE ('@Period2DateTo@',
                                                        'yyyy-mm-dd')
               THEN
                  CASE
                     WHEN PD.NAME = 'DISCOUNT'
                     THEN
                        COALESCE (D.NETAMT, 0) + COALESCE (D.MDISCOUNTAMT, 0)
                     ELSE
                        COALESCE (D.NETAMT, 0)
                  END
            END)
            PERIOD_2_AMT,
         SUM (
            CASE
               WHEN TRUNC (M.BILLDATE) BETWEEN TO_DATE ('@Period2DateFrom@',
                                                        'yyyy-mm-dd')
                                           AND TO_DATE ('@Period2DateTo@',
                                                        'yyyy-mm-dd')
               THEN
                  I.STANDARD_RATE * D.QTY
            END)
            PERIOD_2_STANDARD_RATE,
         SUM (
            CASE
               WHEN TRUNC (M.BILLDATE) BETWEEN TO_DATE ('@Period2DateFrom@',
                                                        'yyyy-mm-dd')
                                           AND TO_DATE ('@Period2DateTo@',
                                                        'yyyy-mm-dd')
               THEN
                  D.QTY
            END)
            PERIOD_2_QTY
    FROM PSITE_POSBILL M
         INNER JOIN PSITE_POSBILLITEM D ON M.CODE = D.PSITE_POSBILL_CODE
         LEFT OUTER JOIN PSITE_DISCOUNT PD ON m.MPSITE_DISCOUNT_CODE = PD.CODE
         INNER JOIN GINVIEW.LV_ITEM I ON D.ICODE = I.CODE
   WHERE     (   (TRUNC (M.BILLDATE) BETWEEN TO_DATE ('@Period1DateFrom@',
                                                      'yyyy-mm-dd')
                                         AND TO_DATE ('@Period1DateTo@',
                                                      'yyyy-mm-dd'))
              OR (TRUNC (M.BILLDATE) BETWEEN TO_DATE ('@Period2DateFrom@',
                                                      'yyyy-mm-dd')
                                         AND TO_DATE ('@Period2DateTo@',
                                                      'yyyy-mm-dd')))
         AND (   (    I.DIVISION = COALESCE ('@Division@', '-1')
                  AND COALESCE ('@Division@', '-1') <> '-1')
              OR (COALESCE ('@Division@', '-1') = '-1'))
         AND (   (    I.SECTION = COALESCE ('@Section@', '-1')
                  AND COALESCE ('@Section@', '-1') <> '-1')
              OR (COALESCE ('@Section@', '-1') = '-1'))
         AND (   (    I.DEPARTMENT = COALESCE ('@Department@', '-1')
                  AND COALESCE ('@Department@', '-1') <> '-1')
              OR (COALESCE ('@Department@', '-1') = '-1'))
GROUP BY M.ADMSITE_CODE, I.DIVISION
/* Formatted on 2025-01-23 12:47:50 (QP5 v5.294) */
/*
Purpose              Object                        ID              Developer          
Custom Development   CQ_TY_LY                      388888          Dipankar
*/
  SELECT GINVIEW.FNC_UK () UK,
         F.ICODE,
         F.SITECODE,
         SUM (
            CASE
               WHEN F.INVOICE_DATE BETWEEN TO_DATE ('@Period1DateFrom@',
                                                    'yyyy-mm-dd')
                                       AND TO_DATE ('@Period1DateTo@',
                                                    'yyyy-mm-dd')
               THEN
                  F.SALE_QTY
               ELSE
                  0
            END)
            PERIOD_1_SALE_QTY,
         SUM (
            CASE
               WHEN F.INVOICE_DATE BETWEEN TO_DATE ('@Period2DateFrom@',
                                                    'yyyy-mm-dd')
                                       AND TO_DATE ('@Period2DateTo@',
                                                    'yyyy-mm-dd')
               THEN
                  F.SALE_QTY
               ELSE
                  0
            END)
            PERIOD_2_SALE_QTY,
         SUM (
            CASE
               WHEN F.INVOICE_DATE BETWEEN TO_DATE ('@Period1DateFrom@',
                                                    'yyyy-mm-dd')
                                       AND TO_DATE ('@Period1DateTo@',
                                                    'yyyy-mm-dd')
               THEN
                  F.COGS
               ELSE
                  0
            END)
            PERIOD_1_COGS,
         SUM (
            CASE
               WHEN F.INVOICE_DATE BETWEEN TO_DATE ('@Period2DateFrom@',
                                                    'yyyy-mm-dd')
                                       AND TO_DATE ('@Period2DateTo@',
                                                    'yyyy-mm-dd')
               THEN
                  F.COGS
               ELSE
                  0
            END)
            PERIOD_2_COGS,
         SUM (
            CASE
               WHEN F.INVOICE_DATE BETWEEN TO_DATE ('@Period1DateFrom@',
                                                    'yyyy-mm-dd')
                                       AND TO_DATE ('@Period1DateTo@',
                                                    'yyyy-mm-dd')
               THEN
                  F.MRP_VALUE
               ELSE
                  0
            END)
            PERIOD_1_MRP_VALUE,
         SUM (
            CASE
               WHEN F.INVOICE_DATE BETWEEN TO_DATE ('@Period2DateFrom@',
                                                    'yyyy-mm-dd')
                                       AND TO_DATE ('@Period2DateTo@',
                                                    'yyyy-mm-dd')
               THEN
                  F.MRP_VALUE
               ELSE
                  0
            END)
            PERIOD_2_MRP_VALUE,
         SUM (
            CASE
               WHEN F.INVOICE_DATE BETWEEN TO_DATE ('@Period1DateFrom@',
                                                    'yyyy-mm-dd')
                                       AND TO_DATE ('@Period1DateTo@',
                                                    'yyyy-mm-dd')
               THEN
                  F.NETAMT
               ELSE
                  0
            END)
            PERIOD_1_NETAMT,
         SUM (
            CASE
               WHEN F.INVOICE_DATE BETWEEN TO_DATE ('@Period2DateFrom@',
                                                    'yyyy-mm-dd')
                                       AND TO_DATE ('@Period2DateTo@',
                                                    'yyyy-mm-dd')
               THEN
                  F.NETAMT
               ELSE
                  0
            END)
            PERIOD_2_NETAMT,
         SUM (
            CASE
               WHEN F.INVOICE_DATE BETWEEN TO_DATE ('@Period1DateFrom@',
                                                    'yyyy-mm-dd')
                                       AND TO_DATE ('@Period1DateTo@',
                                                    'yyyy-mm-dd')
               THEN
                  F.TAXABLE_AMOUNT
               ELSE
                  0
            END)
            PERIOD_1_TAXABLE_AMOUNT,
         SUM (
            CASE
               WHEN F.INVOICE_DATE BETWEEN TO_DATE ('@Period2DateFrom@',
                                                    'yyyy-mm-dd')
                                       AND TO_DATE ('@Period2DateTo@',
                                                    'yyyy-mm-dd')
               THEN
                  F.TAXABLE_AMOUNT
               ELSE
                  0
            END)
            PERIOD_2_TAXABLE_AMOUNT
    FROM (  SELECT D.ICODE,
                   M.ADMSITE_CODE_OWNER                  SITECODE,
                   M.INVDT::date                       INVOICE_DATE,
                   SUM (COALESCE (D.INVQTY, 0))          SALE_QTY,
                   SUM (COALESCE (D.INVQTY, 0) * D.COSTRATE) COGS,
                   SUM (COALESCE (D.INVQTY, 0) * I.MRP)  MRP_VALUE,
                   SUM (
                        (COALESCE (D.INVAMT, 0) + COALESCE (D.CHGAMT, 0))
                      + COALESCE (D.TAXAMT, 0))
                      NETAMT,
                   SUM (TAXABLE_AMOUNT)                  TAXABLE_AMOUNT
              FROM SALINVMAIN M
                   INNER JOIN SALINVDET D ON M.INVCODE = D.INVCODE
                   LEFT OUTER JOIN (  SELECT SALINVDET_CODE, APPAMT TAXABLE_AMOUNT
                                        FROM SALINVCHG_ITEM
                                       WHERE ISTAX = 'Y'
                                    GROUP BY SALINVDET_CODE, APPAMT) TAX
                      ON (D.CODE = SALINVDET_CODE)
                   INNER JOIN GINVIEW.LV_ITEM I ON D.ICODE = I.CODE
             WHERE     SALETYPE = 'O'
                   AND (   (M.INVDT::date BETWEEN TO_DATE ('@Period1DateFrom@',
                                                             'yyyy-mm-dd')
                                                AND TO_DATE ('@Period1DateTo@',
                                                             'yyyy-mm-dd'))
                        OR (M.INVDT::date BETWEEN TO_DATE ('@Period2DateFrom@',
                                                             'yyyy-mm-dd')
                                                AND TO_DATE ('@Period2DateTo@',
                                                             'yyyy-mm-dd')))
          GROUP BY D.ICODE, M.ADMSITE_CODE_OWNER, M.INVDT::date
          UNION ALL
            SELECT D.ICODE,
                   M.ADMSITE_CODE                     SITECODE,
                   M.CSDATE::date                   INVOICE_DATE,
                   SUM (COALESCE (D.QTY, 0))          SALE_QTY,
                   SUM (COALESCE (D.QTY, 0) * D.COSTRATE) COGS,
                   SUM (COALESCE (D.QTY, 0) * I.MRP)  MRP_VALUE,
                   SUM (COALESCE (D.NETAMT, 0))       NETAMT,
                   SUM (COALESCE (D.TAXABLEAMT, 0))   TAXABLE_AMOUNT
              FROM SALCSMAIN M
                   INNER JOIN SALCSDET D ON M.CSCODE = D.CSCODE
                   INNER JOIN GINVIEW.LV_ITEM I ON D.ICODE = I.CODE
             WHERE (   (M.CSDATE::date BETWEEN TO_DATE ('@Period1DateFrom@',
                                                          'yyyy-mm-dd')
                                             AND TO_DATE ('@Period1DateTo@',
                                                          'yyyy-mm-dd'))
                    OR (M.CSDATE::Date BETWEEN TO_DATE ('@Period2DateFrom@',
                                                          'yyyy-mm-dd')
                                             AND TO_DATE ('@Period2DateTo@',
                                                          'yyyy-mm-dd')))
          GROUP BY D.ICODE, M.ADMSITE_CODE, M.CSDATE::date
          UNION ALL
            SELECT D.ICODE,
                   M.ADMSITE_CODE                     SITECODE,
                   M.SSDATE::date                   INVOICE_DATE,
                   SUM (COALESCE (D.QTY, 0))          SALE_QTY,
                   SUM (COALESCE (D.QTY, 0) * D.COSTRATE) COGS,
                   SUM (COALESCE (D.QTY, 0) * I.MRP)  MRP_VALUE,
                   SUM (COALESCE (D.NETAMT, 0))       NETAMT,
                   SUM (COALESCE (D.TAXABLEAMT, 0))   TAXABLE_AMOUNT
              FROM SALSSMAIN M
                   INNER JOIN SALSSDET D ON M.SSCODE = D.SSCODE
                   INNER JOIN GINVIEW.LV_ITEM I ON D.ICODE = I.CODE
             WHERE (   (M.SSDATE::date BETWEEN TO_DATE ('@Period1DateFrom@',
                                                          'yyyy-mm-dd')
                                             AND TO_DATE ('@Period1DateTo@',
                                                          'yyyy-mm-dd'))
                    OR (M.SSDATE::date BETWEEN TO_DATE ('@Period2DateFrom@',
                                                          'yyyy-mm-dd')
                                             AND TO_DATE ('@Period2DateTo@',
                                                          'yyyy-mm-dd')))
          GROUP BY D.ICODE, M.ADMSITE_CODE, M.SSDATE::date) F
GROUP BY F.ICODE, F.SITECODE
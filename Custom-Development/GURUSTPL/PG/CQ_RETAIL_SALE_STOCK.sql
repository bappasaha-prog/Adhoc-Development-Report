/*|| Custom Development || Object : CQ_RETAIL_SALE_STOCK || Ticket Id :  418098 || Developer : Dipankar ||*/

SELECT ROW_NUMBER() OVER()  UK,
       ADMSITE_CODE,
       ICODE,
       SALEQTY,
       SALEAMOUNT,
       STKQTY,
       STOCK_AMOUNT,
       UNSETTLED_SALE_QTY,
       UNSETTLED_SALE_AMT
  FROM (  SELECT T1.ADMSITE_CODE,
                 T1.ICODE,
                 SUM (T1.SALQTY)        SALEQTY,
                 SUM (T1.SALAMT)        SALEAMOUNT,
                 SUM (T1.STKQTY)        STKQTY,
                 SUM (T1.STOCK_AMOUNT)  STOCK_AMOUNT,
                 SUM (UNSETTLED_SALE_QTY) UNSETTLED_SALE_QTY,
                 SUM (UNSETTLED_SALE_AMT) UNSETTLED_SALE_AMT
            FROM (  SELECT ADMSITE_CODE,
                           ICODE,
                           SUM (D.QTY) SALQTY,
                           SUM (D.NETAMT) SALAMT,
                           0          STKQTY,
                           0          STOCK_AMOUNT,
                           0          UNSETTLED_SALE_QTY,
                           0          UNSETTLED_SALE_AMT
                      FROM SALCSMAIN M
                           INNER JOIN SALCSDET D ON (M.CSCODE = D.CSCODE)
                     WHERE M.CSDATE BETWEEN TO_DATE ('@DTFR@', 'yyyy-mm-dd')
                                        AND TO_DATE ('@DTTO@', 'yyyy-mm-dd')
                  GROUP BY M.ADMSITE_CODE, D.ICODE
                  UNION ALL
                    SELECT ADMSITE_CODE,
                           ICODE,
                           SUM (D.QTY) SALQTY,
                           SUM (D.NETAMT) SALAMT,
                           0          STKQTY,
                           0          STOCK_AMOUNT,
                           0          UNSETTLED_SALE_QTY,
                           0          UNSETTLED_SALE_AMT
                      FROM SALSSMAIN M
                           INNER JOIN SALSSDET D ON (M.SSCODE = D.SSCODE)
                     WHERE M.SSDATE BETWEEN TO_DATE ('@DTFR@', 'yyyy-mm-dd')
                                        AND TO_DATE ('@DTTO@', 'yyyy-mm-dd')
                  GROUP BY M.ADMSITE_CODE, D.ICODE
                  UNION ALL
                    SELECT K.ADMSITE_CODE,
                           ICODE,
                           0                            SALQTY,
                           0                            SALAMT,
                           SUM (K.QTY)                  STKQTY,
                           SUM (COALESCE (K.COSTAMOUNT, 0)) STOCK_AMOUNT,
                           0                            UNSETTLED_SALE_QTY,
                           0                            UNSETTLED_SALE_AMT
                      FROM INVSTOCK K
                           INNER JOIN INVLOC L ON (K.LOCCODE = L.LOCCODE)
                     WHERE     LOCTYPE <> 'T'
                           AND K.ENTDT <= TO_DATE ('@ASON@', 'yyyy-mm-dd')
                  GROUP BY K.ADMSITE_CODE, K.ICODE
                  UNION ALL
                    SELECT K.ADMSITE_CODE,
                           ICODE,
                           0 SALQTY,
                           0 SALAMT,
                           0 STKQTY,
                           round (sum (COALESCE (K.DIFF_COST_AMT, 0)), 2)
                              STOCK_AMOUNT,
                           0 UNSETTLED_SALE_QTY,
                           0 UNSETTLED_SALE_AMT
                      FROM INVCOSTADJ K
                     WHERE     k.loccode is null
                           AND K.ADJDT <= TO_DATE ('@ASON@', 'yyyy-mm-dd')
                  GROUP BY K.ADMSITE_CODE, K.ICODE
                  UNION ALL
                    SELECT PB.ADMSITE_CODE,
                           ICODE,
                           0            SALQTY,
                           0            SALAMT,
                           0            STKQTY,
                           0            STOCK_AMOUNT,
                           SUM (PBI.QTY) UNSETTLED_SALE_QTY,
                           SUM (PBI.NETAMT) UNSETTLED_SALE_AMT
                      FROM PSITE_POSBILL_PARK PB
                           INNER JOIN PSITE_POSBILLITEM_PARK PBI
                              ON (PB.CODE = PSITE_POSBILL_CODE)
                     WHERE PB.BILLDATE BETWEEN TO_DATE ('@DTFR@', 'yyyy-mm-dd')
                                           AND TO_DATE ('@DTTO@', 'yyyy-mm-dd')
                  GROUP BY PB.ADMSITE_CODE, PBI.ICODE) T1
                 INNER JOIN V_ITEM I ON (T1.ICODE = I.ICODE)
                 INNER JOIN ADMSITE S ON (T1.ADMSITE_CODE = S.CODE)
           WHERE (   (    NULLIF ('@SiteTypeMSOS@', '') IN ('MS-OO-CM',
                                                            'MS-CO-CM',
                                                            'MS-CO-OM-TS',
                                                            'OS-OO-CM')
                      AND (   (    COALESCE (
                                      TO_NUMBER (
                                         NULLIF ('@SiteTypeSiteNameMSOS@', ''),
                                         '9G999g999999999999d99'),
                                      -1) = -1
                               AND SITETYPE = NULLIF ('@SiteTypeMSOS@', ''))
                           OR (    TO_NUMBER (
                                      NULLIF ('@SiteTypeSiteNameMSOS@', ''),
                                      '9G999g999999999999d99') <> -1
                               AND S.CODE =
                                      TO_NUMBER (
                                         NULLIF ('@SiteTypeSiteNameMSOS@', ''),
                                         '9G999g999999999999d99'))))
                  OR (    COALESCE (NULLIF ('@SiteTypeMSOS@', ''), '-1') = '-1'
                      AND (   (    COALESCE (
                                      TO_NUMBER (
                                         NULLIF ('@SiteTypeSiteNameMSOS@', ''),
                                         '9G999g999999999999d99'),
                                      -1) = -1
                               AND SITETYPE IN ('MS-OO-CM',
                                                'MS-CO-CM',
                                                'MS-CO-OM-TS',
                                                'OS-OO-CM'))
                           OR (    TO_NUMBER (
                                      NULLIF ('@SiteTypeSiteNameMSOS@', ''),
                                      '9G999g999999999999d99') <> -1
                               AND S.CODE =
                                      TO_NUMBER (
                                         NULLIF ('@SiteTypeSiteNameMSOS@', ''),
                                         '9G999g999999999999d99')))))
        GROUP BY T1.ADMSITE_CODE, T1.ICODE
          HAVING (   (SUM (SALQTY) + SUM (UNSETTLED_SALE_QTY)) <> 0
                  OR (SUM (STKQTY)) <> 0)) Q1
 WHERE (   (    TO_NUMBER ('@ShowSoldItemsOnly@', '9G999g999999999999d99') =
                   1
            AND (SALEQTY <> 0 OR UNSETTLED_SALE_QTY <> 0))
        OR TO_NUMBER ('@ShowSoldItemsOnly@', '9G999g999999999999d99') = 0)
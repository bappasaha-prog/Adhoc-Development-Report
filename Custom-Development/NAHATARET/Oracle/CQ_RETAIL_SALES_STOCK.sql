/* Formatted on 10/04/2025 18:42:46 (QP5 v5.294) */
/*><><>< || Custom Development || Object : CQ_RETAIL_SALES_STOCK || Ticket Id : 401459 || Developer : Dipankar || ><><><*/
SELECT NULL                  REQUESTID,
       ADMSITE_CODE || ICODE UK,
       ADMSITE_CODE,
       ICODE,
       SALQTY                SALEQTY,
       NET_SALE_AMT,
       STKQTY,
       CLOSING_TRANSIT_QUANTITY,
       UNSETTLED_SALE_QTY,
       UNSETTLED_SALE_AMT,
       UNSETTLED_STK_QTY
  FROM (  SELECT T1.ADMSITE_CODE,
                 T1.ICODE,
                 SUM (T1.SALQTY)              SALQTY,
                 SUM (T1.NET_SALE_AMT)        NET_SALE_AMT,
                 SUM (T1.STKQTY)              STKQTY,
                 SUM (CLOSING_TRANSIT_QUANTITY) CLOSING_TRANSIT_QUANTITY,
                 SUM (UNSETTLED_SALE_QTY)     UNSETTLED_SALE_QTY,
                 SUM (UNSETTLED_SALE_AMT)     UNSETTLED_SALE_AMT,
                 SUM (UNSETTLED_STK_QTY)      UNSETTLED_STK_QTY
            FROM (  SELECT M.ADMSITE_CODE,
                           D.ICODE,
                           SUM (D.QTY) SALQTY,
                           SUM (D.NETAMT) NET_SALE_AMT,
                           0          STKQTY,
                           0          CLOSING_TRANSIT_QUANTITY,
                           0          UNSETTLED_SALE_QTY,
                           0          UNSETTLED_SALE_AMT,
                           0          UNSETTLED_STK_QTY
                      FROM SALCSMAIN M, SALCSDET D
                     WHERE     M.CSCODE = D.CSCODE
                           AND (   (    NVL (M.CHANNELTYPE, 'RTL') =
                                           '@RetailChannelType@'
                                    AND NVL ('@RetailChannelType@', '-1') <> '-1')
                                OR NVL ('@RetailChannelType@', '-1') = '-1') /*Feature 107852*/
                           AND M.CSDATE BETWEEN TO_DATE ('@DTFR@', 'yyyy-mm-dd')
                                            AND TO_DATE ('@DTTO@', 'yyyy-mm-dd')
                  GROUP BY M.ADMSITE_CODE, D.ICODE
                  UNION ALL
                    SELECT M.ADMSITE_CODE,
                           D.ICODE,
                           SUM (D.QTY) SALQTY,
                           SUM (D.NETAMT) NET_SALE_AMT,
                           0          STKQTY,
                           0          CLOSING_TRANSIT_QUANTITY,
                           0          UNSETTLED_SALE_QTY,
                           0          UNSETTLED_SALE_AMT,
                           0          UNSETTLED_STK_QTY
                      FROM SALSSMAIN M, SALSSDET D
                     WHERE     M.SSCODE = D.SSCODE
                           AND (   (    NVL (M.CHANNELTYPE, 'RTL') =
                                           '@RetailChannelType@'
                                    AND NVL ('@RetailChannelType@', '-1') <> '-1')
                                OR NVL ('@RetailChannelType@', '-1') = '-1') /*Feature 107852*/
                           AND M.SSDATE BETWEEN TO_DATE ('@DTFR@', 'yyyy-mm-dd')
                                            AND TO_DATE ('@DTTO@', 'yyyy-mm-dd')
                  GROUP BY M.ADMSITE_CODE, D.ICODE
                  UNION ALL
                    SELECT K.ADMSITE_CODE,
                           K.ICODE,
                           0 SALQTY,
                           0 NET_SALE_AMT,
                           SUM (CASE WHEN LOCTYPE <> 'T' THEN K.QTY ELSE 0 END)
                              STKQTY,
                           SUM (CASE WHEN LOCTYPE = 'T' THEN K.QTY ELSE 0 END)
                              CLOSING_TRANSIT_QUANTITY,
                           0 UNSETTLED_SALE_QTY,
                           0 UNSETTLED_SALE_AMT,
                           0 UNSETTLED_STK_QTY
                      FROM INVSTOCK K, INVLOC L
                     WHERE     K.LOCCODE = L.LOCCODE
                           AND K.ENTDT <= TO_DATE ('@ASON@', 'yyyy-mm-dd')
                  GROUP BY K.ADMSITE_CODE, K.ICODE
                  UNION ALL
                    SELECT PB.ADMSITE_CODE,
                           PBI.ICODE,
                           0            SALQTY,
                           0            NET_SALE_AMT,
                           0            STKQTY,
                           0            CLOSING_TRANSIT_QUANTITY,
                           SUM (PBI.QTY) UNSETTLED_SALE_QTY,
                           SUM (PBI.NETAMT) UNSETTLED_SALE_AMT,
                           0            UNSETTLED_STK_QTY
                      FROM PSITE_POSBILL_PARK PB, PSITE_POSBILLITEM_PARK PBI
                     WHERE     PB.CODE = PBI.PSITE_POSBILL_CODE
                           AND TRUNC (PB.BILLDATE) BETWEEN TO_DATE ('@DTFR@',
                                                                    'yyyy-mm-dd')
                                                       AND TO_DATE ('@DTTO@',
                                                                    'yyyy-mm-dd')
                           AND (   ('@RetailChannelType@' = '-1')
                                OR ('@RetailChannelType@' = 'RTL'))
                  GROUP BY PB.ADMSITE_CODE, PBI.ICODE) T1,
                 V_ITEM I,
                 ADMSITE S
           WHERE     T1.ICODE = I.ICODE
                 AND T1.ADMSITE_CODE = S.CODE
                 AND (   (    I.LEV1GRPNAME = '@Division@'
                          AND NVL ('@Division@', '-1') <> '-1')
                      OR NVL ('@Division@', '-1') = '-1')
                 AND (   (    I.LEV2GRPNAME = '@Section@'
                          AND NVL ('@Section@', '-1') <> '-1')
                      OR NVL ('@Section@', '-1') = '-1')
                 AND (   (    I.GRPNAME = '@Department@'
                          AND NVL ('@Department@', '-1') <> '-1')
                      OR NVL ('@Department@', '-1') = '-1')
                 AND (   (    '@SiteTypeMSOS@' IN ('MS-OO-CM',
                                                   'MS-CO-CM',
                                                   'MS-CO-OM-TS',
                                                   'OS-OO-CM')
                          AND (   (    NVL ('@SiteTypeSiteNameMSOS@', -1) = -1
                                   AND SITETYPE = '@SiteTypeMSOS@')
                               OR (    '@SiteTypeSiteNameMSOS@' <> -1
                                   AND S.CODE = '@SiteTypeSiteNameMSOS@')))
                      OR (    NVL ('@SiteTypeMSOS@', '-1') = '-1'
                          AND (   (    NVL ('@SiteTypeSiteNameMSOS@', '-1') =
                                          -1
                                   AND SITETYPE IN ('MS-OO-CM',
                                                    'MS-CO-CM',
                                                    'MS-CO-OM-TS',
                                                    'OS-OO-CM'))
                               OR (    '@SiteTypeSiteNameMSOS@' <> -1
                                   AND S.CODE = '@SiteTypeSiteNameMSOS@'))))
        GROUP BY T1.ADMSITE_CODE, T1.ICODE
          HAVING (   (SUM (SALQTY) + SUM (UNSETTLED_SALE_QTY)) <> 0
                  OR SUM (CLOSING_TRANSIT_QUANTITY) <> 0
                  OR (SUM (STKQTY) - SUM (UNSETTLED_STK_QTY)) <> 0))
 WHERE (   (    '@ShowSoldItemsOnly@' = 1
            AND (SALQTY <> 0 OR UNSETTLED_SALE_QTY <> 0))
        OR '@ShowSoldItemsOnly@' = 0)
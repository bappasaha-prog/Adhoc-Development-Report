/* Formatted on 2025/05/12 13:04:09 (QP5 v5.294) */
/*
Purpose              Object                        ID                     Developer          
Custom Development   CQ_SALE_REALTIME_STOCK        408098                 Dipankar
*/

  SELECT GINVIEW.FNC_UK () UK,
         F.ADMSITE_CODE,
         SUM (F.SALE_QTY) SALE_QTY,
         SUM (F.SALE_VALUE) SALE_VALUE,
         SUM (F.COST_VALUE) COST_VALUE,
         SUM (F.SOH_QTY)  SOH_QTY,
         SUM (F.SOH_COST) SOH_COST,
         SUM (F.MRP_VALUE) MRP_VALUE
    FROM (  SELECT M.ADMSITE_CODE,
                   SUM (D.QTY)               SALE_QTY,
                   SUM (
                      CASE
                         WHEN PD.NAME = 'DISCOUNT'
                         THEN
                            COALESCE (D.NETAMT, 0) + COALESCE (D.MDISCOUNTAMT, 0)
                         ELSE
                            COALESCE (D.NETAMT, 0)
                      END)
                      SALE_VALUE,
                   SUM (I.STANDARD_RATE * D.QTY) COST_VALUE,
                   0                         SOH_QTY,
                   0                         SOH_COST,
                   0                         MRP_VALUE
              FROM PSITE_POSBILL M
                   INNER JOIN PSITE_POSBILLITEM D
                      ON M.CODE = D.PSITE_POSBILL_CODE
                   LEFT OUTER JOIN PSITE_DISCOUNT PD
                      ON M.MPSITE_DISCOUNT_CODE = PD.CODE
                   INNER JOIN GINVIEW.LV_ITEM I ON D.ICODE = I.CODE
             WHERE     TRUNC (M.BILLDATE) BETWEEN TO_DATE ('@DTFR@',
                                                           'yyyy-mm-dd')
                                              AND TO_DATE ('@DTTO@',
                                                           'yyyy-mm-dd')
                   AND (   (    I.DIVISION = COALESCE ('@Division@', '-1')
                            AND COALESCE ('@Division@', '-1') <> '-1')
                        OR (COALESCE ('@Division@', '-1') = '-1'))
          GROUP BY M.ADMSITE_CODE
          UNION ALL
            SELECT C.ADMSITE_CODE,
                   0                                          SALE_QTY,
                   0                                          SALE_VALUE,
                   0                                          COST_VALUE,
                   SUM (C.SOH_QTY) - SUM (C.UNSETTLESALEQTY)  SOH_QTY,
                   SUM ( (C.SOH_QTY - C.UNSETTLESALEQTY) * I.STANDARD_RATE)
                      SOH_COST,
                   SUM ( (C.SOH_QTY - C.UNSETTLESALEQTY) * I.MRP) MRP_VALUE
              FROM (  SELECT M.ADMSITE_CODE,
                             M.ICODE,
                             SUM (M.QTY) SOH_QTY,
                             0     UNSETTLESALEQTY
                        FROM INVSTOCK_ONHAND M
                       WHERE LOCCODE <> 2
                    GROUP BY M.ADMSITE_CODE, M.ICODE
                    UNION ALL
                      SELECT M.ADMSITE_CODE,
                             D.ICODE,
                             0     SOH_QTY,
                             SUM (D.QTY) UNSETTLESALEQTY
                        FROM PSITE_POSBILL_PARK M
                             INNER JOIN PSITE_POSBILLITEM_PARK D
                                ON M.CODE = D.PSITE_POSBILL_CODE
                    GROUP BY M.ADMSITE_CODE, D.ICODE) C
                   INNER JOIN GINVIEW.LV_ITEM I ON C.ICODE = I.CODE
             WHERE (   (    I.DIVISION = COALESCE ('@Division@', '-1')
                        AND COALESCE ('@Division@', '-1') <> '-1')
                    OR (COALESCE ('@Division@', '-1') = '-1'))
          GROUP BY C.ADMSITE_CODE) F
GROUP BY F.ADMSITE_CODE
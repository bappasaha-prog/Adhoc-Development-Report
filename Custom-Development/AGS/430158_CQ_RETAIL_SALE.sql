/*|| Custom Development || Object : CQ_RETAIL_SALE || Ticket Id :  430158 || Developer : Dipankar ||*/

SELECT   GINVIEW.FNC_UK ()                                     UK,
         M.ADMSITE_CODE,
         I.DIVISION_ALIAS,
         I.DIVISION,
         SUM (D.QTY)                                           BILL_QTY,
         SUM (D.NETAMT)                                        BILL_AMT,
         SUM (SUM (D.QTY)) OVER (PARTITION BY M.ADMSITE_CODE)  SITE_BILLQTY,
         SUM (SUM (D.NETAMT)) OVER (PARTITION BY M.ADMSITE_CODE) SITE_BILLAMT,
         SUM (SUM (D.NETAMT)) OVER (PARTITION BY 1) OVERALL_BILLAMT
    FROM PSITE_POSBILL M
         INNER JOIN PSITE_POSBILLITEM D ON M.CODE = D.PSITE_POSBILL_CODE
         INNER JOIN GINVIEW.LV_ITEM I ON D.ICODE = I.CODE
   WHERE TRUNC (M.BILLDATE) BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                                AND TO_DATE ('@DTFR@', 'YYYY-MM-DD')
GROUP BY M.ADMSITE_CODE, I.DIVISION_ALIAS, I.DIVISION
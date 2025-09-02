/* Formatted on 2025-03-12 16:07:13 (QP5 v5.294) */
/*><><>< || Custom Development || Object : CQ_PURRET_ITEM || Ticket Id : 398793 || Developer : Dipankar || ><><><*/
  SELECT GINVIEW.FNC_UK()           UK,
         RTCODE                   RTCODE,
         concat_ws(' ',I.CATEGORY1,I.CATEGORY2) ITEM_NAME,
         SUM (QTY)                RETURN_QUANTITY,
         m.RATE                     RETURN_RATE,
         SUM (NETAMT)             ITEM_GROSS_AMOUNT,
         SUM (TAX_CHARGE_AMOUNT)  TAX_CHARGE_AMOUNT,
         SUM (OTHER_CHARGE_AMOUNT) OTHER_CHARGE_AMOUNT,
           (SUM (COALESCE (NETAMT, 0)) + SUM (COALESCE (TAX_CHARGE_AMOUNT, 0)))
         + SUM (COALESCE (OTHER_CHARGE_AMOUNT, 0))
            ITEM_NET_AMOUNT,
         DIS.RATE,
         SUM (DIS.CHGAMT)         ITEM_DISCOUNT_AMT,
         I.UOM
    FROM PURRTDET M
         LEFT OUTER JOIN
         (  SELECT PURRTDET_CODE, SUM (COALESCE (CHGAMT, 0)) OTHER_CHARGE_AMOUNT
              FROM PURRTCHG_ITEM
             WHERE ISTAX = 'N'
          GROUP BY PURRTDET_CODE) OTX
            ON (CODE = OTX.PURRTDET_CODE)
         LEFT OUTER JOIN
         (  SELECT PURRTDET_CODE, SUM (COALESCE (CHGAMT, 0)) TAX_CHARGE_AMOUNT
              FROM PURRTCHG_ITEM
             WHERE ISTAX = 'Y'
          GROUP BY PURRTDET_CODE) TAX
            ON (CODE = TAX.PURRTDET_CODE)
         INNER JOIN GINVIEW.LV_ITEM I ON M.ICODE = I.CODE
         LEFT OUTER JOIN
         (SELECT PURRTDET_CODE, CHGAMT, si.RATE
            FROM PURRTCHG_ITEM SI INNER JOIN FINCHG C ON SI.CHGCODE = C.CHGCODE
           WHERE SI.ISTAX = 'N' AND SI.CHGCODE = 10) DIS
            ON (M.CODE = DIS.PURRTDET_CODE)
GROUP BY RTCODE,
         concat_ws(' ',I.CATEGORY1,I.CATEGORY2),
         ICODE,
         HSN_SAC_CODE,
         m.RATE,
         DIS.RATE,
         I.UOM
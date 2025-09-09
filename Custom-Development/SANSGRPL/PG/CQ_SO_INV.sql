/*|| Custom Development || Object : CQ_SO_INV || Ticket Id :  412168 || Developer : Dipankar ||*/
  SELECT GINVIEW.FNC_UK ()         UK,
         SM.SCHEME_DOCNO           ORDER_NO,
         SM.ORDDT                  ORDER_DATE,
         M.SCHEME_DOCNO            INVOICE_NO,
         M.INVDT                   INVOICE_DATE,
         TO_CHAR (M.INVDT::date, 'MON-YY') INVOICE_MONTH,
         M.PCODE,
         M.ADMSITE_CODE_OWNER      SITECODE,
         D.ICODE,
         L.DOCNO                   LR_DOCNO,
         L.LGTDT                   LR_DATE,
         M.SALETYPE,
         SUM (SD.ORDQTY)           ORDER_QTY,
         SUM (SD.CNLQTY)           ORD_CNL_QTY,
         SUM (D.INVQTY)            INVOICE_QTY,
         SUM (TAX.TAXABLE_AMOUNT)  TAXABLEAMT,
         SUM (TAX.CGST_AMOUNT)     CGST_AMOUNT,
         SUM (TAX.IGST_AMOUNT)     IGST_AMOUNT,
         SUM (TAX.SGST_AMOUNT)     SGST_AMOUNT,
         SUM (TAX.TAX_CHARGE_AMOUNT) TAX_CHARGE_AMOUNT,
         SUM (
              (COALESCE (D.INVAMT, 0) + COALESCE (D.CHGAMT, 0))
            + COALESCE (D.TAXAMT, 0))
            ITEM_NET_AMOUNT
    FROM SALINVMAIN M
         INNER JOIN SALINVDET D ON M.INVCODE = D.INVCODE
         LEFT OUTER JOIN
         (  SELECT SALINVDET_CODE,
                   APPAMT                 TAXABLE_AMOUNT,
                   SUM (COALESCE (CHGAMT, 0)) TAX_CHARGE_AMOUNT,
                   SUM (CASE WHEN GST_COMPONENT = 'CGST' THEN CHGAMT ELSE 0 END)
                      CGST_AMOUNT,
                   SUM (CASE WHEN GST_COMPONENT = 'SGST' THEN CHGAMT ELSE 0 END)
                      SGST_AMOUNT,
                   SUM (CASE WHEN GST_COMPONENT = 'IGST' THEN CHGAMT ELSE 0 END)
                      IGST_AMOUNT
              FROM SALINVCHG_ITEM
             WHERE ISTAX = 'Y'
          GROUP BY SALINVDET_CODE, APPAMT) TAX
            ON (D.CODE = SALINVDET_CODE)
         LEFT JOIN INVDCDET DCD ON D.INVDCDET_CODE = DCD.CODE
         LEFT JOIN SALORDDET SD
            ON DCD.SALORDDET_CODE = SD.CODE AND DCD.ORDCODE = SD.ORDCODE
         LEFT JOIN SALORDMAIN SM ON SD.ORDCODE = SM.ORDCODE
         LEFT JOIN INVLGTNOTE L ON M.LGTCODE = L.LGTCODE
   WHERE M.INVDT::date BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                             AND TO_DATE ('@DTTO@', 'YYYY-MM-DD')
GROUP BY SM.SCHEME_DOCNO,
         SM.ORDDT,
         M.SCHEME_DOCNO,
         M.INVDT,
         TO_CHAR (M.INVDT::date, 'MON-YY'),
         M.PCODE,
         M.ADMSITE_CODE_OWNER,
         D.ICODE,
         L.DOCNO,
         L.LGTDT,
         M.SALETYPE
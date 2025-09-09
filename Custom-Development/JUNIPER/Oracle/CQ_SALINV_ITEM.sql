/* Formatted on 2025-09-04 17:16:16 (QP5 v5.294) */
/*|| Custom Development || Object : CQ_SALINV_ITEM || Ticket Id :  429793 || Developer : Dipankar ||*/

WITH SIZE_ORDER
     AS (SELECT 'XS' AS SIZE_NAME, 1 AS SORT_ORDER FROM DUAL
         UNION ALL
         SELECT 'S', 2 FROM DUAL
         UNION ALL
         SELECT 'M', 3 FROM DUAL
         UNION ALL
         SELECT 'L', 4 FROM DUAL
         UNION ALL
         SELECT 'XL', 5 FROM DUAL
         UNION ALL
         SELECT 'XXL', 6 FROM DUAL
         UNION ALL
         SELECT '3XL', 7 FROM DUAL
         UNION ALL
         SELECT '4XL', 8 FROM DUAL
         UNION ALL
         SELECT '5XL', 9 FROM DUAL),
     ORDERED
     AS (  SELECT M.INVCODE,
                  I.DEPARTMENT,
                  I.CATEGORY1,
                  I.HSN_CODE,
                  I.MRP,
                  I.WSP,
                  DCD.FACTOR             DISCOUNT_FACTOR,
                  SUM (M.INVQTY)         INVOICE_QUANTITY,
                  M.RATE                 INVOICE_RATE,
                  SUM (TAX.TAXABLE_AMOUNT) TAXABLE_AMOUNT,
                  TAX.CGST_RATE,
                  SUM (TAX.CGST_AMOUNT)  CGST_AMOUNT,
                  TAX.SGST_RATE,
                  SUM (TAX.SGST_AMOUNT)  SGST_AMOUNT,
                  TAX.IGST_RATE,
                  SUM (TAX.IGST_AMOUNT)  IGST_AMOUNT,
                  S.SIZE_NAME,
                  S.SORT_ORDER,
                    S.SORT_ORDER
                  - ROW_NUMBER ()
                       OVER (PARTITION BY M.INVCODE,
                                          I.DEPARTMENT,
                                          I.CATEGORY1,
                                          I.HSN_CODE,
                                          I.MRP,
                                          I.WSP,
                                          DCD.FACTOR,
                                          M.RATE,
                                          TAX.CGST_RATE,
                                          TAX.SGST_RATE,
                                          TAX.IGST_RATE
                             ORDER BY S.SORT_ORDER)
                     GRP
             FROM SALINVDET M
                  INNER JOIN INVDCDET DCD
                     ON M.INVDCDET_CODE = DCD.DCCODE AND M.DCCODE = DCD.DCCODE
                  INNER JOIN GINVIEW.LV_ITEM I ON M.ICODE = I.CODE
                  LEFT OUTER JOIN
                  (  SELECT SALINVDET_CODE,
                            APPAMT TAXABLE_AMOUNT,
                            SUM (
                               CASE
                                  WHEN GST_COMPONENT = 'CGST' THEN RATE
                                  ELSE 0
                               END)
                               CGST_RATE,
                            SUM (
                               CASE
                                  WHEN GST_COMPONENT = 'CGST' THEN CHGAMT
                                  ELSE 0
                               END)
                               CGST_AMOUNT,
                            SUM (
                               CASE
                                  WHEN GST_COMPONENT = 'SGST' THEN RATE
                                  ELSE 0
                               END)
                               SGST_RATE,
                            SUM (
                               CASE
                                  WHEN GST_COMPONENT = 'SGST' THEN CHGAMT
                                  ELSE 0
                               END)
                               SGST_AMOUNT,
                            SUM (
                               CASE
                                  WHEN GST_COMPONENT = 'IGST' THEN RATE
                                  ELSE 0
                               END)
                               IGST_RATE,
                            SUM (
                               CASE
                                  WHEN GST_COMPONENT = 'IGST' THEN CHGAMT
                                  ELSE 0
                               END)
                               IGST_AMOUNT
                       FROM SALINVCHG_ITEM
                      WHERE ISTAX = 'Y'
                   GROUP BY SALINVDET_CODE, APPAMT) TAX
                     ON (M.CODE = SALINVDET_CODE)
                  INNER JOIN SIZE_ORDER S ON TRIM (I.CATEGORY3) = S.SIZE_NAME
            WHERE (   M.INVCODE IN
                         (    SELECT REGEXP_SUBSTR ('@DocumentId@',
                                                    '[^|~|]+',
                                                    1,
                                                    LEVEL)
                                        COL1
                                FROM DUAL
                          CONNECT BY LEVEL <=
                                          REGEXP_COUNT ('@DocumentId@', '|~|')
                                        + 1)
                   OR NVL (REGEXP_COUNT ('@DocumentId@', '|~|') + 1, 0) = 0)
         GROUP BY M.INVCODE,
                  I.DEPARTMENT,
                  I.CATEGORY1,
                  I.CATEGORY3,
                  I.HSN_CODE,
                  I.MRP,
                  I.WSP,
                  DCD.FACTOR,
                  M.RATE,
                  TAX.CGST_RATE,
                  TAX.SGST_RATE,
                  TAX.IGST_RATE,
                  S.SIZE_NAME,
                  S.SORT_ORDER),
     GROUPED
     AS (  SELECT INVCODE,
                  DEPARTMENT,
                  CATEGORY1,
                  HSN_CODE,
                  MRP,
                  WSP,
                  DISCOUNT_FACTOR,
                  SUM (INVOICE_QUANTITY) INVOICE_QUANTITY,
                  INVOICE_RATE,
                  SUM (TAXABLE_AMOUNT) TAXABLE_AMOUNT,
                  CGST_RATE,
                  SUM (CGST_AMOUNT)    CGST_AMOUNT,
                  SGST_RATE,
                  SUM (SGST_AMOUNT)    SGST_AMOUNT,
                  IGST_RATE,
                  SUM (IGST_AMOUNT)    IGST_AMOUNT,
                  MIN (SORT_ORDER)     START_ORDER,
                  MAX (SORT_ORDER)     END_ORDER,
                  MIN (SIZE_NAME) KEEP (DENSE_RANK FIRST ORDER BY SORT_ORDER)
                     START_SIZE,
                  MAX (SIZE_NAME) KEEP (DENSE_RANK LAST ORDER BY SORT_ORDER)
                     END_SIZE
             FROM ORDERED
         GROUP BY INVCODE,
                  DEPARTMENT,
                  CATEGORY1,
                  HSN_CODE,
                  MRP,
                  WSP,
                  DISCOUNT_FACTOR,
                  INVOICE_RATE,
                  CGST_RATE,
                  SGST_RATE,
                  IGST_RATE,
                  GRP)
  SELECT GINVIEW.FNC_UK ()    UK,
         INVCODE,
         DEPARTMENT,
         CATEGORY1,
         HSN_CODE,
         MRP,
         WSP,
         DISCOUNT_FACTOR,
         SUM (INVOICE_QUANTITY) INVOICE_QUANTITY,
         INVOICE_RATE,
         SUM (TAXABLE_AMOUNT) TAXABLE_AMOUNT,
         CGST_RATE,
         SUM (CGST_AMOUNT)    CGST_AMOUNT,
         SGST_RATE,
         SUM (SGST_AMOUNT)    SGST_AMOUNT,
         IGST_RATE,
         SUM (IGST_AMOUNT)    IGST_AMOUNT,
            '['
         || LISTAGG (
               CASE
                  WHEN START_SIZE = END_SIZE THEN START_SIZE
                  ELSE START_SIZE || '-' || END_SIZE
               END,
               ',')
            WITHIN GROUP (ORDER BY START_ORDER)
         || ']'
            AS SIZE_CHART
    FROM GROUPED
GROUP BY INVCODE,
         DEPARTMENT,
         CATEGORY1,
         HSN_CODE,
         MRP,
         WSP,
         DISCOUNT_FACTOR,
         INVOICE_RATE,
         CGST_RATE,
         SGST_RATE,
         IGST_RATE
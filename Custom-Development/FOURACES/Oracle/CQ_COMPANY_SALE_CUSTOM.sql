/*><><>< || Custom Development || Object : CQ_COMPANY_SALE_CUSTOM || Ticket Id : 399834 || Developer : Dipankar || ><><><*/
SELECT GINVIEW.FNC_UK () UK,
       "Sale Mode",
       "Channel Type",
       "Sub-channel Type",
       "Store Type",
       "Sale Type",
       "Entry Date",
       SITECODE,
       SLCODE,
       ICODE,
       QTY,
       RSP,
       RATE,
       "Gross Amount",
       "Discount Amount",
       "Extra Tax Amount",
       "Shipment Charges",
       "COD Charges",
       "Gift Wrap Charges",
       "Net Amount",
       COGS,
       "Tax Amount",
       "Promo Discount",
       "Item Remarks",
       TAXABLEAMT,
       OWNER_GSTIN_NO,
       OWNER_GSTIN_STATE_CODE,
       CP_GSTIN_NO,
       CP_GSTIN_STATE_CODE,
       HSN_SAC_CODE,
       IGSTRATE,
       IGSTAMT,
       CGSTRATE,
       CGSTAMT,
       SGSTRATE,
       SGSTAMT,
       CESSRATE,
       CESSAMT,
       OTHER_CHG,
       "SALES LEDGER"
  FROM (SELECT 'Retail Sale'              "Sale Mode",
               'Store'                    "Channel Type",
               CASE
                  WHEN C.SITETYPE LIKE '%OO-CM' THEN 'Owned Store Sale'
                  ELSE 'Franchise (Consignment) Sale'
               END
                  "Sub-channel Type",
               CASE
                  WHEN COALESCE (C.ISPOS, 'N') = 'N' THEN 'Unmanaged'
                  WHEN COALESCE (C.ISPOS, 'N') = 'Y' THEN 'Managed'
               END
                  "Store Type",
               CASE WHEN B.QTY >= 0 THEN 'Sales' ELSE 'Sales Return' END
                  "Sale Type",
               A.CSDATE                   "Entry Date",
               A.ADMSITE_CODE             SITECODE,
               A.PCODE                    SLCODE,
               B.ICODE,
               COALESCE (B.QTY, 0)        QTY,
               COALESCE (B.MRP, 0)        RSP,
               COALESCE (B.RATE, 0)       RATE,
               COALESCE (B.GRSAMT, 0)     "Gross Amount",
               COALESCE (B.DISCOUNT, 0)   "Discount Amount",
               COALESCE (B.EXTAXAMT, 0)   "Extra Tax Amount",
               COALESCE (B.SHIPCHG, 0)    "Shipment Charges",
               COALESCE (B.CODCHG, 0)     "COD Charges",
               COALESCE (B.GWCHG, 0)      "Gift Wrap Charges",
               COALESCE (B.NETAMT, 0)     "Net Amount",
               COALESCE (B.COSTRATE, 0)   COGS,
               COALESCE (B.TAXAMT, 0)     "Tax Amount",
               COALESCE (B.PROMOAMT, 0)   "Promo Discount",
               B.REMARKS                  "Item Remarks",
               COALESCE (B.TAXABLEAMT, 0) TAXABLEAMT,
               A.OWNER_GSTIN_NO,
               A.OWNER_GSTIN_STATE_CODE,
               A.CP_GSTIN_NO,
               A.CP_GSTIN_STATE_CODE,
               B.HSN_SAC_CODE,
               B.IGSTRATE,
               B.IGSTAMT,
               B.CGSTRATE,
               B.CGSTAMT,
               B.SGSTRATE,
               B.SGSTAMT,
               B.CESSRATE,
               B.CESSAMT,
               0                          OTHER_CHG,
               G.GLNAME                   "SALES LEDGER"
          FROM SALCSMAIN A
               INNER JOIN SALCSDET B ON A.CSCODE = B.CSCODE
               INNER JOIN ADMSITE C ON A.ADMSITE_CODE = C.CODE
               LEFT JOIN FINSL D ON A.PCODE = D.SLCODE
               LEFT JOIN FINGL G ON A.CONSIGNMENT_SALES_GLCODE = D.GLCODE
         WHERE     A.CHANNELTYPE = 'RTL'
               AND TRUNC (A.CSDATE) BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                                        AND TO_DATE ('@DTTO@', 'YYYY-MM-DD')
        UNION ALL
        SELECT 'Retail Sale'            "Sale Mode",
               'E-commerce'             "Channel Type",
               CASE
                  WHEN C.SITETYPE LIKE '%OO-CM' THEN 'Fulfilled by Seller'
                  ELSE 'Fulfilled by Marketplace'
               END
                  "Sub-channel Type",
               'Not Applicable'         "Store Type",
               CASE WHEN B.QTY >= 0 THEN 'Sales' ELSE 'Sales Return' END
                  "Sale Type",
               A.CSDATE                 "Entry Date",
               A.ADMSITE_CODE           SITECODE,
               A.PCODE                  SLCODE,
               B.ICODE,
               COALESCE (B.QTY, 0)      QTY,
               COALESCE (B.MRP, 0)      RSP,
               COALESCE (B.RATE, 0)     RATE,
               COALESCE (B.GRSAMT, 0)   "Gross Amount",
               COALESCE (B.DISCOUNT, 0) "Discount Amount",
               COALESCE (B.EXTAXAMT, 0) "Extra Tax Amount",
               COALESCE (B.SHIPCHG, 0)  "Shipment Charges",
               COALESCE (B.CODCHG, 0)   "COD Charges",
               COALESCE (B.GWCHG, 0)    "Gift Wrap Charges",
               COALESCE (B.NETAMT, 0)   "Net Amount",
               COALESCE (B.COSTRATE, 0) COGS,
               COALESCE (B.TAXAMT, 0)   "Tax Amount",
               COALESCE (B.PROMOAMT, 0) "Promo Discount",
               B.REMARKS                "Item Remarks",
               COALESCE (B.TAXABLEAMT, 0),
               A.OWNER_GSTIN_NO,
               A.OWNER_GSTIN_STATE_CODE,
               A.CP_GSTIN_NO,
               A.CP_GSTIN_STATE_CODE,
               B.HSN_SAC_CODE,
               B.IGSTRATE,
               B.IGSTAMT,
               B.CGSTRATE,
               B.CGSTAMT,
               B.SGSTRATE,
               B.SGSTAMT,
               B.CESSRATE,
               B.CESSAMT,
               0                        OTHER_CHG,
               G.GLNAME                 "SALES LEDGER"
          FROM SALCSMAIN A
               INNER JOIN SALCSDET B ON A.CSCODE = B.CSCODE
               INNER JOIN ADMSITE C ON A.ADMSITE_CODE = C.CODE
               LEFT JOIN FINSL D ON A.PCODE = D.SLCODE
               LEFT JOIN FINGL G ON A.CONSIGNMENT_SALES_GLCODE = D.GLCODE
         WHERE     A.CHANNELTYPE = 'ETL'
               AND TRUNC (A.CSDATE) BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                                        AND TO_DATE ('@DTTO@', 'YYYY-MM-DD')
        UNION ALL
        SELECT 'Wholesale'                         "Sale Mode",
               'Warehouse Sale'                    "Channel Type",
               CASE
                  WHEN COALESCE (C.ISSECONDARY, 'N') = 'Y' THEN 'Outright'
                  ELSE 'Shop in Shop'
               END
                  "Sub-channel Type",
               'Not Applicable'                    "Store Type",
               'Sales'                             "Sale Type",
               A.INVDT                             "Entry Date",
               A.ADMSITE_CODE                      SITECODE,
               A.PCODE,
               B.ICODE,
               B.INVQTY,
               B.MRP,
               B.RATE,
               0                                   "Gross Amount",
               0                                   "Discount Amount",
               0                                   "Extra Tax",
               0                                   "Shipment Charges",
               0                                   "COD Charges",
               0                                   "Gift Wrap Charges",
               B.INVAMT                            "Net Amount",
               B.COSTRATE                          COGS,
               B.TAXAMT                            "Tax Amount",
               0                                   "Promo Discount",
               B.REM                               "Item Remarks",
               COALESCE (TAX.TAXABLEAMT, INVQTY * RATE),
               A.OWNER_GSTIN_NO,
               A.OWNER_GSTIN_STATE_CODE,
               A.CP_GSTIN_NO,
               A.CP_GSTIN_STATE_CODE,
               B.HSN_SAC_CODE,
               TAX.IGSTRATE,
               TAX.IGSTAMT,
               TAX.CGSTRATE,
               TAX.CGSTAMT,
               TAX.SGSTRATE,
               TAX.SGSTAMT,
               TAX.CESSRATE,
               TAX.CESSAMT,
               ROUND (B.INVQTY * OTH.OTHER_CHG, 2) OTHER_CHG,
               G.GLNAME                            "SALES LEDGER"
          FROM SALINVMAIN A
               INNER JOIN SALINVDET B ON A.INVCODE = B.INVCODE
               INNER JOIN ADMSITE C ON A.ADMSITE_CODE = C.CODE
               INNER JOIN FINSL D
                  ON A.PCODE = D.SLCODE AND C.SLCODE = D.SLCODE
               LEFT JOIN FINGL G ON A.GLCODE = G.GLCODE
               LEFT JOIN
               (  SELECT SALINVDET_CODE,
                         APPAMT TAXABLEAMT,
                         SUM (
                            CASE
                               WHEN GST_COMPONENT = 'CGST' THEN RATE
                               ELSE 0
                            END)
                            CGSTRATE,
                         SUM (
                            CASE
                               WHEN GST_COMPONENT = 'CGST' THEN CHGAMT
                               ELSE 0
                            END)
                            CGSTAMT,
                         SUM (
                            CASE
                               WHEN GST_COMPONENT = 'SGST' THEN RATE
                               ELSE 0
                            END)
                            SGSTRATE,
                         SUM (
                            CASE
                               WHEN GST_COMPONENT = 'SGST' THEN CHGAMT
                               ELSE 0
                            END)
                            SGSTAMT,
                         SUM (
                            CASE
                               WHEN GST_COMPONENT = 'IGST' THEN RATE
                               ELSE 0
                            END)
                            IGSTRATE,
                         SUM (
                            CASE
                               WHEN GST_COMPONENT = 'IGST' THEN CHGAMT
                               ELSE 0
                            END)
                            IGSTAMT,
                         SUM (
                            CASE
                               WHEN GST_COMPONENT = 'CESS' THEN RATE
                               ELSE 0
                            END)
                            CESSRATE,
                         SUM (
                            CASE
                               WHEN GST_COMPONENT = 'CESS' THEN CHGAMT
                               ELSE 0
                            END)
                            CESSAMT
                    FROM SALINVCHG_ITEM
                   WHERE SOURCE = 'G'
                GROUP BY SALINVDET_CODE, APPAMT) TAX
                  ON B.CODE = TAX.SALINVDET_CODE
               LEFT JOIN
               (  SELECT M.INVCODE,
                         ROUND (SUM (CHGAMT) / SUM (QTY), 6) OTHER_CHG
                    FROM (  SELECT INVCODE, SUM (CHGAMT) CHGAMT
                              FROM SALINVCHG
                             WHERE ISTAX = 'N' AND OPERATION_LEVEL = 'H'
                          GROUP BY INVCODE) M,
                         (  SELECT INVCODE, SUM (INVQTY) QTY
                              FROM SALINVDET
                          GROUP BY INVCODE) D
                   WHERE M.INVCODE = D.INVCODE
                GROUP BY M.INVCODE) OTH
                  ON A.INVCODE = OTH.INVCODE
         WHERE     D.SALETYPE = 'O'
               AND TRUNC (A.INVDT) BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                                       AND TO_DATE ('@DTTO@', 'YYYY-MM-DD')
        UNION ALL
        SELECT 'Wholesale'                                      "Sale Mode",
               'Warehouse Sale'                                 "Channel Type",
               CASE
                  WHEN COALESCE (C.ISSECONDARY, 'N') = 'Y' THEN 'Outright'
                  ELSE 'Shop in Shop'
               END
                  "Sub-channel Type",
               'Not Applicable'                                 "Store Type",
               'Sales Return'                                   "Sale Type",
               A.RTDT                                           "Entry Date",
               A.ADMSITE_CODE                                   SITECODE,
               A.PCODE,
               B.ICODE,
               0 - B.QTY,
               B.MRP,
               B.RATE,
               0                                                "Gross Amount",
               0                                                "Discount Amount",
               0                                                "Extra Tax",
               0                                                "Shipment Charges",
               0                                                "COD Charges",
               0                                                "Gift Wrap Charges",
               0 - (COALESCE (B.QTY, 0) * COALESCE (B.RATE, 0)) "Net Amount",
               B.COSTRATE                                       COGS,
               0 - CHG.TAX_AMOUNT                               "Tax Amount",
               0
                  "Promo Discount",
               B.REM
                  "Item Remarks",
                 0
               - COALESCE (TAX.TAXABLEAMT,
                           (COALESCE (B.QTY, 0) * COALESCE (B.RATE, 0))),
               A.OWNER_GSTIN_NO,
               A.OWNER_GSTIN_STATE_CODE,
               A.CP_GSTIN_NO,
               A.CP_GSTIN_STATE_CODE,
               B.HSN_SAC_CODE,
               TAX.IGSTRATE,
               0 - TAX.IGSTAMT,
               TAX.CGSTRATE,
               0 - TAX.CGSTAMT,
               TAX.SGSTRATE,
               0 - TAX.SGSTAMT,
               TAX.CESSRATE,
               0 - TAX.CESSAMT,
               ROUND (B.QTY * OTH.OTHER_CHG, 2)                 OTHER_CHG,
               G.GLNAME
                  "SALES LEDGER"
          FROM SALRTMAIN A
               INNER JOIN SALRTDET B ON A.RTCODE = B.RTCODE
               INNER JOIN ADMSITE C ON A.ADMSITE_CODE = C.CODE
               INNER JOIN FINSL D
                  ON A.PCODE = D.SLCODE AND C.SLCODE = D.SLCODE
               LEFT JOIN FINGL G ON A.GLCODE = G.GLCODE
               LEFT JOIN
               (  SELECT SALRTCHG_ITEM.SALRTDET_CODE,
                         SUM (COALESCE (SALRTCHG_ITEM.CHGAMT, 0)) TAX_AMOUNT
                    FROM SALRTCHG_ITEM
                   WHERE     COALESCE (SALRTCHG_ITEM.ISTAX, 'N') = 'Y'
                         AND SALRTCHG_ITEM.RTCODE IN
                                (SELECT RTCODE
                                   FROM SALRTMAIN
                                  WHERE TRUNC (RTDT) BETWEEN TO_DATE (
                                                                '@DTFR@',
                                                                'YYYY-MM-DD')
                                                         AND TO_DATE (
                                                                '@DTTO@',
                                                                'YYYY-MM-DD'))
                GROUP BY SALRTCHG_ITEM.SALRTDET_CODE) CHG
                  ON B.CODE = CHG.SALRTDET_CODE
               LEFT JOIN
               (  SELECT SALRTDET_CODE,
                         APPAMT TAXABLEAMT,
                         SUM (
                            CASE
                               WHEN GST_COMPONENT = 'CGST' THEN RATE
                               ELSE 0
                            END)
                            CGSTRATE,
                         SUM (
                            CASE
                               WHEN GST_COMPONENT = 'CGST' THEN CHGAMT
                               ELSE 0
                            END)
                            CGSTAMT,
                         SUM (
                            CASE
                               WHEN GST_COMPONENT = 'SGST' THEN RATE
                               ELSE 0
                            END)
                            SGSTRATE,
                         SUM (
                            CASE
                               WHEN GST_COMPONENT = 'SGST' THEN CHGAMT
                               ELSE 0
                            END)
                            SGSTAMT,
                         SUM (
                            CASE
                               WHEN GST_COMPONENT = 'IGST' THEN RATE
                               ELSE 0
                            END)
                            IGSTRATE,
                         SUM (
                            CASE
                               WHEN GST_COMPONENT = 'IGST' THEN CHGAMT
                               ELSE 0
                            END)
                            IGSTAMT,
                         SUM (
                            CASE
                               WHEN GST_COMPONENT = 'CESS' THEN RATE
                               ELSE 0
                            END)
                            CESSRATE,
                         SUM (
                            CASE
                               WHEN GST_COMPONENT = 'CESS' THEN CHGAMT
                               ELSE 0
                            END)
                            CESSAMT
                    FROM SALRTCHG_ITEM
                   WHERE SOURCE = 'G'
                GROUP BY SALRTDET_CODE, APPAMT) TAX
                  ON B.CODE = TAX.SALRTDET_CODE
               LEFT JOIN
               (  SELECT M.RTCODE,
                         ROUND (SUM (CHGAMT) / SUM (QTY), 6) OTHER_CHG
                    FROM (  SELECT RTCODE, SUM (CHGAMT) CHGAMT
                              FROM SALRTCHG@DB_LINK_TO_READ
                             WHERE ISTAX = 'N' AND OPERATION_LEVEL = 'H'
                          GROUP BY RTCODE) M,
                         (  SELECT RTCODE, SUM (QTY) QTY
                              FROM SALRTDET
                          GROUP BY RTCODE) D
                   WHERE M.RTCODE = D.RTCODE
                GROUP BY M.RTCODE) OTH
                  ON B.RTCODE = OTH.RTCODE
         WHERE     D.SALETYPE = 'O'
               AND TRUNC (A.RTDT) BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                                      AND TO_DATE ('@DTTO@', 'YYYY-MM-DD')) F